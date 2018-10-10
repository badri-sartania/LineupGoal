//
// Created by Anders Hansen on 17/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Crashlytics.h"
#import "MatchesTableViewController.h"
#import "SimpleTableSectionView.h"
#import "Match.h"
#import "MatchCellView.h"
#import "MatchPageViewController.h"
#import "Mixpanel.h"
#import "DefaultTableView.h"
#import "NSDate+Lineupbattle.h"
#import "MatchesHelper.h"
#import "SimpleLocale.h"
#import "Utils.h"
#import "HTTP.h"
#import "Date.h"
#import "HTTP+RAC.h"

@interface MatchesTableViewController ()
@property (nonatomic, strong) DefaultTableView *tableView;
@property (nonatomic, strong) NSArray *competitions;
@property (nonatomic, strong) RACDisposable *disposable;
@property(nonatomic, strong) RACDisposable *intervalDisposer;
@end

@implementation MatchesTableViewController

- (id)initWithDate:(YLMoment *)date {
    self = [super init];

    if (self) {
        self.date = date;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectCellSelection];
    [self fetchDate:self.date clearTable:NO];
    [self setupSubscriptionFetchAtInterval:30];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.intervalDisposer dispose];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Bindings
- (void)setupSubscriptionFetchAtInterval:(NSInteger)interval {
    NSDate *now = [NSDate date];
    NSDate *threeHoursAfterMidnight = [[[YLMoment momentWithDate:self.date.date] endOf:@"d"] addAmountOfTime:3 forUnitKey:@"h"].date;
    NSDate *startOfDay = [[YLMoment momentWithDate:self.date.date] startOf:@"d"].date;

    if ([now greaterThan:startOfDay] && [threeHoursAfterMidnight greaterThan:now]) {
        @weakify(self);
        self.intervalDisposer = [[RACSignal
            interval:interval onScheduler:[RACScheduler mainThreadScheduler]]
            subscribeNext:^(id x) {
                @strongify(self);
                [self fetchDate:self.date clearTable:NO];
            }];
    }
}

#pragma mark - Data handling operations
- (void)subscriptionViewHandling {
    [self.tableView reloadData];

    if(self.competitions.count == 0) {
        [self.tableView enableNotificationOverlayWithImage:nil text:[NSString stringWithFormat:@"No %@ for this date", [SimpleLocale USAlternative:@"games" forString:@"matches"]]];
    }
}

- (void)fetchDate:(YLMoment *)date clearTable:(BOOL)clearTable {
    [self.tableView disableNotificationOverlay];
    self.date = date;

    if (clearTable) {
        self.competitions = nil;
        [self.tableView reloadData];
        [self.tableView startSpinner];
    }

    // Clear existing request is currently running before making a new one
    [self.disposable dispose];
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/883#issuecomment-27139568

    @weakify(self);

    NSString *dateString = [Date getRequestDateFormat:self.date.date];

    self.disposable = [[[[[HTTP instance] fetchMatchesByRange:dateString endDateString:dateString] ignore:nil] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id response) {
        @strongify(self);

        NSArray *matches = [Match arrayTransformer:response];
        self.competitions = [MatchesHelper groupByCompetition:matches];

        if (self.competitions != nil) {
            [self subscriptionViewHandling];
        }

        [Utils hideConnectionErrorNotification];
        [self.tableView stopSpinner];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);

        // Only show errors if there is no data
        if (self.competitions.count == 0) {
            [self.tableView enableNotificationOverlayWithImage:nil text:@"Could not load matches"];
        }

        if (clearTable) [Utils showConnectionErrorNotification];

        [self.tableView stopSpinner];
    }];
}

#pragma mark - Table View data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.competitions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.competitions[(NSUInteger)section][@"matches"]).count;
}

#pragma mark - Table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *league = self.competitions[(NSUInteger)section];
    SimpleTableSectionView *sectionView = [[SimpleTableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.f)];
    [sectionView setSectionDataWithTitle:league[@"name"] flagCode:league[@"country"] countryCodeFormat:CountryCodeFormatFifa];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.competitions[(NSUInteger)indexPath.section][@"matches"][(NSUInteger) indexPath.row];
    NSString *matchIdentifier = [NSString stringWithFormat:@"match%@", match.status];

    MatchCellView *cell = [tableView dequeueReusableCellWithIdentifier:matchIdentifier];

    if (cell == nil) {
        cell = [[MatchCellView alloc] initWithStyle:0 reuseIdentifier:matchIdentifier];
    }

    [cell setupMatch:match];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.competitions[(NSUInteger) indexPath.section][@"matches"][(NSUInteger) indexPath.row];

    CLS_LOG(@"Match %@", match.objectId);

    DefaultSubscriptionViewController *subscriptionViewControllerWithMatchPageViewController = [[[MatchPageViewController alloc] initWithMatch:match] wrapInSubscriptionViewController];

    [self.navigationController pushViewController:subscriptionViewControllerWithMatchPageViewController animated:YES];

    [[Mixpanel sharedInstance] track:@"Match" properties:@{
        @"matchId": match.objectId ?: [NSNull null],
        @"origin": @"matches",
        @"kickOff": match.kickOff ?: [NSNull null],
        @"kickOffDiff": @(match.kickOffDiff),
        @"homeTeam": match.home && match.home.name ? match.home.name : [NSNull null],
        @"homeTeam": match.away && match.away.name ? match.away.name : [NSNull null],
        @"period": match.periodStr ?: [NSNull null],
        @"clock": match.clock ?: [NSNull null]
    }];
}

#pragma mark - TableView other
- (void)refreshTable {
    [self.tableView.tableLoadingSpinner stopAnimating];
    [self fetchDate:self.date clearTable:NO];
}

#pragma mark - Views
- (DefaultTableView *)tableView {
    if(!_tableView) {
        // Init and something I don't know what do good for
        _tableView = [[DefaultTableView alloc] initWithDelegate:self];
        _tableView.dataSource = self;
        [_tableView enableSpinner];
        [_tableView enableRefreshControl];
    }

    return _tableView;
}

@end
