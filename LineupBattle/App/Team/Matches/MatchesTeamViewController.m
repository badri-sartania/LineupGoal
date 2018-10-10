//
//  MatchesTeamViewController.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 31/12/13.
//  Copyright (c) 2013 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "Crashlytics.h"
#import "MatchesTeamViewController.h"
#import "TeamViewController.h"
#import "DefaultSubscriptionViewController.h"
#import "TopTeamView.h"
#import "MatchCellView.h"
#import "MatchPageViewController.h"
#import "Array.h"
#import "SimpleTableSectionView.h"
#import "MatchDateSectionView.h"
#import "DefaultTableView.h"
#import "NSDate+Lineupbattle.h"
#import "SimpleLocale.h"

@interface MatchesTeamViewController ()
@property (nonatomic, strong) TopTeamView *topTeamView;
@property (nonatomic, strong) DefaultTableView *tableView;
@property (nonatomic, strong) NSIndexPath *lastPlayedIndexPath;
@end

@implementation MatchesTeamViewController

- (id)initWithViewModel:(TeamViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;

        [self updateData];
    }

    return self;
}

- (void)updateData {
    [self.topTeamView updateData:self.viewModel.team];

    NSArray *matches = self.viewModel.team.matches;

    if(matches.count > 0) {
        self.matches = [Array sortArrayWithDictionaries:matches key:@"kickOff" assending:YES];
        self.lastPlayedIndexPath = [self findIndexPathForLatestPlayedMatch:self.matches];

        [self.tableView disableNotificationOverlay];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:self.lastPlayedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else {
        [self.tableView enableNotificationOverlayWithImage:nil text:[SimpleLocale USAlternative:@"No games found" forString:@"No matches found"]];
    }

    [self.tableView stopSpinner];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.topTeamView];
    [self.view addSubview:self.tableView];

    [self.topTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@130);
        make.width.equalTo(self.view);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTeamView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.topTeamView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
    }];

    [self.tableView startSpinner];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectCellSelection];
}

- (NSIndexPath *)findIndexPathForLatestPlayedMatch:(NSArray *)sortedMatches {
    NSUInteger totalMatches = sortedMatches.count;
    NSUInteger currentMatchIndex = 0;
    NSDate *now = [NSDate date];

    for (; currentMatchIndex < totalMatches; currentMatchIndex++) {
        Match *match = sortedMatches[currentMatchIndex];
        if ([match.kickOff greaterThan:now]) {
            // scroll to the latest game that should have been played (could be postponed etc)
            NSInteger section = !currentMatchIndex ? 0 : currentMatchIndex - 1;
            return [NSIndexPath indexPathForRow:0 inSection:section];
        }
    }

    NSInteger fallbackSection = totalMatches == 0 ? 0 : totalMatches-1;
    return  [NSIndexPath indexPathForRow:0 inSection:fallbackSection];
}

#pragma mark - Section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.matches.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MatchDateSectionView *sectionView = [[MatchDateSectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 30.f)];
    Match *match = self.matches[(NSUInteger)section];
    [sectionView setSectionDataWithTitle:[[YLMoment momentWithDate:match.kickOff] format:@"d MMMM yyyy"] league:match.competition.name];
    return sectionView;
}

#pragma mark - Cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.matches[(NSUInteger) indexPath.section];
    NSString *matchIdentifier = [NSString stringWithFormat:@"match%@", match.status];

    MatchCellView *cell = [tableView dequeueReusableCellWithIdentifier:matchIdentifier];

    if(cell == nil) {
        cell = [[MatchCellView alloc] initWithStyle:0 reuseIdentifier:matchIdentifier];
    }

    [cell setupMatch:match];

    return cell;
}

#pragma mark - Events
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.matches[(NSUInteger) indexPath.section];

    CLS_LOG(@"Match: %@", match.objectId);

    DefaultSubscriptionViewController *subscriptionViewControllerWithMatchViewController = [[[MatchPageViewController alloc] initWithMatch:match] wrapInSubscriptionViewController];
    [self.navigationController pushViewController:subscriptionViewControllerWithMatchViewController animated:YES];

    NSMutableDictionary *meta = [NSMutableDictionary dictionaryWithDictionary:@{
        @"matchId": match.objectId,
        @"origin": @"team"
    }];

    if (match.kickOff) {
        meta[@"kickOff"] = match.kickOff;
        meta[@"kickOffDiff"] = @(match.kickOffDiff);
    }

    if (match.home && match.home.name) meta[@"homeTeam"] = match.home.name;
    if (match.away && match.away.name) meta[@"awayTeam"] = match.away.name;
    if (match.period) meta[@"period"] = match.periodStr;
    if (match.clock) meta[@"clock"] = match.clock;

    [[Mixpanel sharedInstance] track:@"Match" properties:meta];
}

#pragma mark - Views
- (TopTeamView *)topTeamView {
   if (!_topTeamView) {
        _topTeamView = [[TopTeamView alloc] init];
   }

   return _topTeamView;
}

- (DefaultTableView *)tableView {
   if (!_tableView) {
       _tableView = [[DefaultTableView alloc] initWithDelegate:self];
       _tableView.dataSource = self;
       [_tableView enableSpinner];
       [_tableView enableRefreshControl];
   }

   return _tableView;
}

- (void)refreshTable {
    [self.viewModel fetchDetailsCatchError:NO success:^{
        [self.tableView stopSpinner];
    }];
}
@end
