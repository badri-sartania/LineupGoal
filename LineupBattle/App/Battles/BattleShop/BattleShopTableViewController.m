//
// Created by Anders Borre Hansen on 28/07/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <JGProgressHUD/JGProgressHUD.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import <YLMoment/YLMoment.h>
#import "LBMTLModel.h"
#import "BattleShopTableViewController.h"
#import "NoBattlesTemplatesViewCell.h"
#import "Utils.h"
#import "HTTP.h"
#import "BattleViewModel.h"
#import "SimpleTableSectionView.h"
#import "CLSLogging.h"
#import "DefaultNavigationController.h"
#import "BattleViewController.h"
#import "SimpleLocale.h"
#import "Wallet.h"
#import "SpinnerHelper.h"
#import "PlayerSectionView.h"
#import "NSDate+LineupBattle.h"
#import "HexColors.h"
#import "HTTP+RAC.h"
#import "LineupBattleResource.h"
#import "Identification.h"


@interface BattleShopTableViewController ()
@property (nonatomic, strong) NSArray *battleTemplates;
@property(nonatomic, strong) RACDisposable *autoupdaterSignalDisposable;
@property (nonatomic, strong) JGProgressHUD *hud;
@end

@implementation BattleShopTableViewController {
    NSDate *_sevenDaysFromNow;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        self.inviteOnly = NO;
        [self.tableView registerClass:[BattlesTableViewCell class] forCellReuseIdentifier:@"battleTypeViewCell"];
        [self.tableView registerClass:[NoBattlesTemplatesViewCell class] forCellReuseIdentifier:@"noBattleTemplateViewCell"];
        self.navigationItem.title = @"Pick a Battle";
    }

    return self;
}

- (instancetype)initWithInviteOnly:(BOOL)inviteOnly {
    self = [self init];

    if (self) {
        self.inviteOnly = inviteOnly;
        self.navigationItem.title = @"Invite-Only Battle";
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _sevenDaysFromNow = [[YLMoment now] addAmountOfTime:7 forCalendarUnit:NSCalendarUnitDay].date;

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    // Table
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchDataWithErrorNotification)
                  forControlEvents:UIControlEventValueChanged];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Loading indicator
    self.hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];
    self.tableView.layer.zPosition = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self fetchDataWithErrorNotification:YES];

    @weakify(self);
    self.autoupdaterSignalDisposable = [[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self);
        [self fetchDataWithErrorNotification:NO];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.autoupdaterSignalDisposable dispose];
}

#pragma mark - Refresh and fetch data
- (void)fetchDataWithErrorNotification {
    [self fetchDataWithErrorNotification:YES];
}

- (void)fetchDataWithErrorNotification:(BOOL)showError {
    @weakify(self);
    [[[HTTP instance] battlesSignal] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);
        self.battleTemplates = dic[@"templates"];

        [Utils hideConnectionErrorNotification];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];

        [_hud dismiss];
    } error:^(NSError *error) {
        @strongify(self);

        if (showError) [Utils showConnectionErrorNotification];

        [self.refreshControl endRefreshing];
        [_hud dismiss];
        CLS_LOG(@"Error loading data: %@", error);
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self battlesTemplatesAvailable]) {
        return 115.f;
    }

    return 200.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.battleTemplates.count ?: 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self battlesTemplatesAvailable]) {
        return [self battleTemplatesForSection:section].count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self battlesTemplatesAvailable]) {
		UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.f)];

		sectionView.backgroundColor = [UIColor hx_colorWithHexString:@"f2f2f2"];

		DefaultLabel *label = [DefaultLabel initWithCenterText:@"My Battles"];
		label.font = [UIFont boldSystemFontOfSize:14.f];
		[sectionView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(sectionView);
			make.left.equalTo(sectionView).offset(10);
		}];

		NSDictionary *grouping = self.battleTemplates[(NSUInteger)section];
		label.text = [[self dateFormatter:grouping[@"date"]] capitalizedString];

		return sectionView;
	}

	SimpleTableSectionView *sectionView = [[SimpleTableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.f)];
	[sectionView setUnderlineToNormalPosition];
	[sectionView setSectionDataWithTitle:@"Battles Available" flagCode:@"UNK" countryCodeFormat:CountryCodeFormatFifa];
	return sectionView;
}

- (NSString *)dateFormatter:(NSDate *)date {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

	if ([date isToday]) {
		return @"Today";
	} else if ([date lessThan:_sevenDaysFromNow]) {
		[formatter setLocalizedDateFormatFromTemplate:@"EEEE"];
		return [formatter stringFromDate:date];
	} else {
		[formatter setLocalizedDateFormatFromTemplate:@"ddMMMMEEE"];
		return [formatter stringFromDate:date];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Show in reverse order
    if ([self battlesTemplatesAvailable]) {
        BattleTemplate *battleTemplate = [self battleForIndexPath:indexPath];
        BattlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"battleTypeViewCell" forIndexPath:indexPath];

        cell.delegate = self;
//        [cell setData:battleTemplate];
        cell.indexPath = indexPath;

        cell.userInteractionEnabled = ![battleTemplate.joined boolValue];

        return cell;
    } else {
        NoBattlesTemplatesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noBattleTemplateViewCell" forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        return cell;
    }
}

- (void)buttonWasPressed:(BattlesTableViewCell *)battlesTableViewCell {
    NSIndexPath *indexPath = battlesTableViewCell.indexPath;

    BattleTemplate *template = self.battleTemplates[(NSUInteger)indexPath.section][@"templates"][indexPath.row];
    NSString *startDateString = [[self dateFormatter:template.startDate] capitalizedString];
    NSString *actionText = [template.reminder boolValue] ? @"Remove reminder" : @"Remind me 15 minutes before start";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:template.name message:startDateString preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:actionText style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [APNHelper doubleConfirmationWithTitle:@"Enable push notifications" message:@"To recieve reminders you need to enable push notifications" accepted:^{
            [Utils registerForAPN];
        }];

        BOOL reminder = ![template.reminder boolValue];
        [LineupBattleResource sendBattleTemplateSubscription:template.objectId reminder:reminder success:^() {
            [battlesTableViewCell setReminderStatus:reminder];
            template.reminder = @(reminder);
        } failure:^(NSError *error) {}];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self battlesTemplatesAvailable]) {
        BattleTemplate *template = [self battleForIndexPath:indexPath];
        CreateLineupViewController *createTeam;

        if (self.inviteOnly) {
            createTeam = [[CreateLineupViewController alloc] initCreateInviteOnlyBattleWithDelegate:self battleTemplateId:template.objectId];
        } else {
            createTeam = [[CreateLineupViewController alloc] initPublicBattleWithDelegate:self battleTemplateId:template.objectId];
        }

        DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:createTeam];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)createTeamViewController:(CreateLineupViewController *)controller doneWithReturnObj:(NSDictionary *)dic withPlayers:(id) players{
    if (dic) {
        BattleViewModel *viewModel = [[BattleViewModel alloc] initWithModelDictionary:dic];
        BattleViewController *gameView = [[BattleViewController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:gameView animated:NO];

        @weakify(viewModel)
        [APNHelper showBattleNotificationControlsFor:gameView type:^(BattleNotificationControl state) {
            @strongify(viewModel);
            [viewModel handleSubscriptionChoice:state];
        } title:@"Battle Joined" message:[NSString stringWithFormat:@"Receive notifications on %@ events so you're updated on the action.", [SimpleLocale USAlternative:@"game" forString:@"match"]]];

        [self fetchDataWithErrorNotification:YES];
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers
- (NSDictionary *)dictionaryForSectionIndex:(NSInteger)section {
    return self.battleTemplates[(NSUInteger)section];
}

- (NSArray *)battleTemplatesForSection:(NSInteger)section {
    return [self dictionaryForSectionIndex:section][@"templates"];
}

- (BattleTemplate *)battleForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionArray = [self dictionaryForSectionIndex:indexPath.section];
    return sectionArray[@"templates"][(NSUInteger)indexPath.row];
}

#pragma mark - Group helper
- (NSArray *)sortBattleTemplatesByStartDate:(NSArray *)battleTemplates {
    NSArray *sortedMatches = [battleTemplates sortedArrayUsingComparator:^NSComparisonResult(BattleTemplate *a, BattleTemplate *b) {
        NSComparisonResult result = [a.startDate compare:b.startDate];

        if (result == NSOrderedSame) {
            result = [a.name compare:b.name];
        }

        return result;
    }];

    return sortedMatches;
}

#pragma mark - Notifications
- (BOOL)battlesTemplatesAvailable {
    return self.battleTemplates.count > 0;
}

@end
