//
//  GamesTableViewController.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 16/12/14.
//  Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "Crashlytics.h"
#import "LBMTLModel.h"
#import "BattlesTableViewController.h"
#import "BattleViewController.h"
#import "DefaultNavigationController.h"
#import "DefaultViewCell.h"
#import "HTTP.h"
#import "ProfileTableViewController.h"
#import "Identification.h"
#import "ShopViewController.h"
#import "Utils.h"
#import "Wallet.h"
#import "XPBarView.h"
#import "SimpleLocale.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "NoBattlesTemplatesViewCell.h"
#import "BattleShopTableViewController.h"
#import "BattleButtonView.h"
#import "ChallengesTableViewController.h"
#import "UIView+Border.h"
#import "SpinnerHelper.h"
#import "Mixpanel.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"
#import "HTTP+RAC.h"
#import "ProfileBattleViewCell.h"
#import "PointsView.h"
#import "SectionHeaderView.h"
#import "NSDate+LineupBattle.h"


@interface BattlesTableViewController ()
@property (nonatomic, strong) NSArray *battles;
@property (nonatomic, strong) NSArray *battleTemplates;
@property (nonatomic, strong) RACDisposable *autoupdaterSignalDisposable;
@property (nonatomic, strong) ProfileImageWithBadgeView *profileImageWithBadgeView;
@property (nonatomic, strong) DefaultLabel *coinLabel;
@property (nonatomic, strong) XPBarView *xpBarView;
@property (nonatomic, strong) PointsView *xpLabel;
@property (nonatomic, strong) JGProgressHUD *hud;
@end

@implementation BattlesTableViewController {
    NSDate *_sevenDaysFromNow;
}

static NSInteger numberOfButtons = 1;
static NSInteger navigationBarHeight = 82;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight, [Utils screenWidth], [Utils screenHeight] - navigationBarHeight - 50)]; // 50 is tabbar height
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView setSeparatorColor:[UIColor hx_colorWithHexString:@"#ecf0f1"]];
        [self.view addSubview:self.tableView];
        
        [self.tableView registerClass:[DefaultViewCell class] forCellReuseIdentifier:@"button"];
        [self.tableView registerClass:[ProfileBattleViewCell class] forCellReuseIdentifier:@"activeBattleViewCell"];
        [self.tableView registerClass:[BattlesTableViewCell class] forCellReuseIdentifier:@"battleTypeViewCell"];
        [self.tableView registerClass:[NoBattlesTemplatesViewCell class] forCellReuseIdentifier:@"noBattleTemplateViewCell"];

        // Request products
        [[Shop instance] requestProducts];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCredits:) name:WalletNotificationCreditChangeName object:[Wallet instance]];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
//    self.navigationItem.title = @"Lineup Battles";
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Set Tableview Delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Profile Header Top
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 140)];
    [headerView bottomBorderWithColor:[UIColor hx_colorWithHexString:@"#D8D8D8"] width:1.f offset:0];

    self.xpBarView = [[XPBarView alloc] init];
    [headerView addSubview:self.xpBarView];

    self.xpLabel = [[PointsView alloc] init];
    [self.xpLabel setFontSize:11];
    [headerView addSubview:self.xpLabel];

//    [self.xpBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.profileImageWithBadgeView.mas_bottom).offset(10);
//        make.centerX.equalTo(self.profileImageWithBadgeView);
//        make.width.equalTo(@80);
//        make.height.equalTo(@5);
//    }];

    [self.xpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xpBarView.mas_bottom).offset(7);
        make.centerX.equalTo(self.xpBarView);
    }];

    // Credits
    NSInteger topHeight = 25;
    NSInteger rightMargin = -25;

    UIImageView *coinsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"creditRect"]];
    
    DefaultLabel *availableLabel = [DefaultLabel initWithText:@"Available"];
    availableLabel.font = [UIFont systemFontOfSize:14];

    [headerView addSubview:coinsImageView];
//    [headerView addSubview:self.coinLabel];
    [headerView addSubview:availableLabel];

//    [@[coinsImageView, buttonOverlay] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(headerView).offset(rightMargin+18);
//        make.top.equalTo(headerView).offset(topHeight);
//        make.width.equalTo(@172);
//        make.height.equalTo(@53);
//    }];

   
    [availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(rightMargin);
        make.top.equalTo(headerView).offset(topHeight+30);
    }];

    // Table
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self
                            action:@selector(fetchDataWithErrorNotification)
                  forControlEvents:UIControlEventValueChanged];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor hx_colorWithHexString:@"ecf0f1"];

    // Loading indicator
    // TODO: - uncomment after api integration
//    self.hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];
    self.tableView.layer.zPosition = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self navigationController] setNavigationBarHidden:YES];
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

#pragma mark - Setup NavigationBar
- (void)setupNavigationBar {
    // Setup navigation bar
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], navigationBarHeight)];
    [navigationBar setBackgroundColor:[UIColor hx_colorWithHexString:@"34495e"]];
    [self.view addSubview:navigationBar];
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(navigationBarHeight);
    }];
    
    // Profile image
    self.profileImageWithBadgeView = [[ProfileImageWithBadgeView alloc] initWithImageName:nil badgeText:@""];
    self.profileImageWithBadgeView.delegate = self;
    [navigationBar addSubview:self.profileImageWithBadgeView];
    [self.profileImageWithBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationBar).offset(14);
        make.top.equalTo(navigationBar).offset(27);
    }];
    
    UIImage *markImage = [UIImage imageNamed:@"img_logo"];
    UIImageView *navMark = [[UIImageView alloc] initWithImage:markImage];
    [navigationBar addSubview:navMark];
    [navMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationBar).offset(36);
        make.centerX.equalTo(navigationBar);
    }];
    
    UIImage *addBoltImage = [UIImage imageNamed:@"ic_add_bolt"];
    UIImageView *addBoltButtonImage = [[UIImageView alloc] initWithImage:addBoltImage];
    [navigationBar addSubview:addBoltButtonImage];
    [addBoltButtonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@36);
        make.height.equalTo(@49);
        make.right.equalTo(navigationBar).offset(-10);
        make.top.equalTo(navigationBar).offset(25);
    }];
    
    NSString *creditsString = @"";
    if ([Wallet instance].credits) {
        creditsString = [[Wallet instance].credits stringValue];
    }
    self.coinLabel = [DefaultLabel initWithText:creditsString];
    self.coinLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    self.coinLabel.textColor = [UIColor whiteColor];
    [navigationBar addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navigationBar).offset(-38);
        make.top.equalTo(navigationBar).offset(57);
    }];
    
    UIButton *buttonOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonOverlay addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:buttonOverlay];
    [buttonOverlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@49);
        make.right.equalTo(navigationBar).offset(-10);
        make.top.equalTo(navigationBar).offset(25);
    }];
}

#pragma mark - Refresh and fetch data
- (void)fetchDataWithErrorNotification {
    [self fetchDataWithErrorNotification:YES];
}

- (void)fetchDataWithErrorNotification:(BOOL)showError {
    
    //* TODO: - update after api ready
    
    @weakify(self);
    [[[HTTP instance] battlesSignal] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);
        self.battleTemplates = dic[@"templates"];
        self.battles = dic[@"active"];
        
        [Utils hideConnectionErrorNotification];
        [self.tableView reloadData];
        [self.tableView.refreshControl endRefreshing];
        
        [_hud dismiss];
    } error:^(NSError *error) {
        @strongify(self);
        
        if (showError) [Utils showConnectionErrorNotification];
        
        [self.tableView.refreshControl endRefreshing];
        [_hud dismiss];
        CLS_LOG(@"Error loading data: %@", error);
    }];
    
//    [[[HTTP instance] get:[NSString stringWithFormat:@"/users/%@", [Identification userId]]] subscribeNext:^(NSDictionary *dic) {
//        @strongify(self);
//        //TODO
//    } error:^(NSError *error) {
//    }];
    
    /* dont use lobby api anymore all in one api endpoint as active / invited
    [[[HTTP instance] lobbySignal] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);

        User *user = dic[@"user"];
        self.battles = user.battles;

        [self.profileImageWithBadgeView.imageViewWithBadge.imageView loadImageWithUrlString:[user profileImagePath:80] placeholder:@"playerPlaceholder"];

        if (user && user.wallet) {
            [[Wallet instance] setCredits:[user.wallet integerValue] timestamp:user.walletUpdatedAt];
        }

        [self.profileImageWithBadgeView.imageViewWithBadge setBadgeText:[user.level stringValue] ?: @"1"];
        if (user && user.photoToken) [self.profileImageWithBadgeView.imageViewWithBadge.imageView loadImageWithUrlString:[user profileImagePath:80] placeholder:@"playerPlaceholder"];
        NSInteger percentage = user.xpProgressionInPercentage;
        [self.xpBarView setProcentage:percentage];
        [self.xpLabel setLevelFormat:[user.xp integerValue] target:[user.xpToNextLevel integerValue]];
        [Utils hideConnectionErrorNotification];
        [self.tableView reloadData];
        [self.tableView.refreshControl endRefreshing];

        [_hud dismiss];
    } error:^(NSError *error) {
        @strongify(self);

        // TODO: - comment on error notification
//        if (showError) [Utils showConnectionErrorNotification];

        [self.tableView.refreshControl endRefreshing];
        [_hud dismiss];
        CLS_LOG(@"Error loading data: %@", error);
    }];
     
    // */
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 50.f + 33.0f; // Add dummy section header
        }
        return 50.f;
    } else {
        return 72.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self battlesTemplatesAvailable]) {
        return self.battleTemplates.count + 2;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.f;
    if (section == 1) return 70.f ;
    if (section == 2) return 20.f;      // because under section 1
    return 33.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self battlesAvailable] ? self.battles.count : 0;
//        return 1; // TODO: - comment after test
    } else if (section == 1){
        return 0;
    } else { // TODO: - update with battles
//        if (section == 2) {
//            return 2;
//        } else {
//            return 1;
//        }
        
        if ([self battlesTemplatesAvailable]) {
            return [self battleTemplatesForSection:(section - 2)].count;
        } else {
            return 0;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70.0f)];
    sectionView.layer.zPosition = 10000;
    sectionView.backgroundColor = [UIColor hx_colorWithHexString:@"ecf0f1"];
    
    if (section == 0) {
        SectionHeaderView *sectionHeader = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width - 14, 20)];
        [sectionHeader setTitle:@"JOINED GAMES"];
        [sectionHeader setBackgroundColor:[UIColor lightBackgroundColor]];
        
        [sectionView addSubview:sectionHeader];
        [sectionHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView).offset(7);
            make.right.equalTo(sectionView).offset(-7);
            make.bottom.equalTo(sectionView);
            make.height.equalTo(@0);
        }];
        
    } else if (section == 1) {
//        sectionView.backgroundColor = [UIColor hx_colorWithHexString:@"fff000"];

        UIImageView *imgHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_table_header"]];
        
        [sectionView addSubview:imgHeader];
        [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sectionView).offset(2);
            make.bottom.equalTo(sectionView).offset(-4);
            make.centerY.equalTo(sectionView);
            make.centerX.equalTo(sectionView);
        }];
    } else {
        SectionHeaderView *sectionHeader = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width - 14, 20)];
        
        NSDictionary *grouping = self.battleTemplates[(NSUInteger)(section - 2)];
        [sectionHeader setTitle: [[self dateFormatter:grouping[@"date"]] uppercaseString]];
        [sectionHeader setBackgroundColor:[UIColor lightBackgroundColor]];
        [sectionView setBackgroundColor:[UIColor hx_colorWithHexString:@"ecf0f1"]];
        
        [sectionView addSubview:sectionHeader];
        [sectionHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView).offset(7);
            make.right.equalTo(sectionView).offset(-7);
            make.bottom.equalTo(sectionView);
            make.height.equalTo(@20);
        }];
    }
        
    /* Test data -
        if (section == 2) { // TODO: - update with battles
        SectionHeaderView *sectionHeader = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width - 14, 20)];
        [sectionHeader setTitle:@"TODAY"];
        [sectionHeader setBackgroundColor:[UIColor hx_colorWithHexString:@"#34495E"]];
        
        [sectionView addSubview:sectionHeader];
        [sectionHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView).offset(7);
            make.right.equalTo(sectionView).offset(-7);
            make.bottom.equalTo(sectionView);
            make.height.equalTo(@20);
        }];
    } else if (section == 3) { // TODO: - update with battles
        SectionHeaderView *sectionHeader = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width - 14, 20)];
        [sectionHeader setTitle:@"TUESDAY"];
        [sectionHeader setBackgroundColor:[UIColor hx_colorWithHexString:@"#34495E"]];
        
        [sectionView addSubview:sectionHeader];
        [sectionHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView).offset(7);
            make.right.equalTo(sectionView).offset(-7);
            make.bottom.equalTo(sectionView);
            make.height.equalTo(@20);
        }];
    }
    
    // */

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
    if (indexPath.section == 0) {
        Battle *battle = self.battles[(NSUInteger)indexPath.row];
        ProfileBattleViewCell *cell = (ProfileBattleViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activeBattleViewCell" forIndexPath:indexPath];
        [cell setData:battle position:indexPath.row];
        if (indexPath.row == 0) {
            [cell setHorizontalMargin:7 withHeader:@"JOINED GAMES"];
        } else {
            [cell setHorizontalMargin:7];
        }
//        [cell setShadowCell:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    } else if (indexPath.section > 1) {
        
        if ([self battlesTemplatesAvailable]) {
            BattleTemplate *battleTemplate = [self battleForIndexPath:indexPath];
            BattlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"battleTypeViewCell" forIndexPath:indexPath];
            
            cell.delegate = self;
            [cell setData:battleTemplate :(int)(indexPath.row)];
            cell.indexPath = indexPath;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.userInteractionEnabled = ![battleTemplate.joined boolValue];
            
            return cell;
        }
        
        /* Test Data
//        BattleTemplate *battleTemplate = [self battleForIndexPath:indexPath];
        BattlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"battleTypeViewCell" forIndexPath:indexPath];
        
        cell.delegate = self;
//        [cell setData:battleTemplate];
        if (indexPath.section == 2) {
            [cell setDemoAt:(int)(indexPath.row)];
        } else if (indexPath.section == 3) {
            [cell setDemoAt:2];
        }
        
        cell.indexPath = indexPath;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
//        cell.userInteractionEnabled = ![battleTemplate.joined boolValue];
        
        return cell;
        */
    }
    return nil;
//    } else if (self.battles.count > 0) {
//        Battle *battle = self.battles[(NSUInteger)indexPath.row];
//        ProfileBattleViewCell *cell = (ProfileBattleViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activeBattleViewCell" forIndexPath:indexPath];
//        [cell setData:battle];
//        return cell;
//    } else {
//        NoBattlesTemplatesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noBattleTemplateViewCell" forIndexPath:indexPath];
//        cell.noBattleLabel.text = @"No battles?\nCheck Play Now";
//        cell.userInteractionEnabled = NO;
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            BattleShopTableViewController *shop = [[BattleShopTableViewController alloc] init];
//            [self.navigationController pushViewController:shop animated:YES];
//        }
        Battle *battle = self.battles[(NSUInteger)indexPath.row];
        
        [[Mixpanel sharedInstance] track:@"Battle" properties:@{
                                                                @"id": battle.objectId ?: [NSNull null],
                                                                @"entry": battle.template.entry ?: [NSNull null],
                                                                @"from": @"lobby"
                                                                }];
        
        
        BattleViewModel *viewModel = [[BattleViewModel alloc] initWithBattleId:battle.objectId];
        BattleViewController *gameView = [[BattleViewController alloc] initWithViewModel:viewModel];
        gameView.openMethod = @"present";
        UINavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:gameView];
        
        [self presentViewController:navigationController animated:YES completion:nil];
    } else {
        
        // TODO: - uncomment after api integrated
//        if ([self battlesTemplatesAvailable]) {
            BattleTemplate *template = [self battleForIndexPath:indexPath];
            CreateLineupViewController *createTeam;
            
            // TODO: - check : inviteOnly is for ChallengesTableViewController
//            if (self.inviteOnly) {
//                createTeam = [[CreateLineupViewController alloc] initCreateInviteOnlyBattleWithDelegate:self battleTemplateId:template.objectId];
//            } else {
                createTeam = [[CreateLineupViewController alloc] initPublicBattleWithDelegate:self battleTemplateId:template.objectId];
//            }
            
            DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:createTeam];
            [self presentViewController:navigationController animated:YES completion:nil];
//        }
    }
}

- (void)createTeamViewController:(CreateLineupViewController *)controller doneWithReturnObj:(NSDictionary *)dic withPlayers:(NSArray *)players {
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
- (BOOL)battlesAvailable {
    return self.battles.count > 0;
}

- (NSDictionary *)dictionaryForSectionIndex:(NSInteger)section {
    return self.battleTemplates[(NSUInteger)section];
}

- (NSArray *)battleTemplatesForSection:(NSInteger)section {
    return [self dictionaryForSectionIndex:section][@"templates"];
}

- (BattleTemplate *)battleForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionArray = [self dictionaryForSectionIndex:indexPath.section - 2];
    return sectionArray[@"templates"][(NSUInteger)indexPath.row];
}

#pragma mark - Actions
- (void)profileAction {
    ProfileTableViewController *profileTableViewController = [[ProfileTableViewController alloc] initWithProfileId:[Identification userId]];
    profileTableViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(profileCloseAction)];
    DefaultNavigationController *defaultNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:profileTableViewController];

    [self presentViewController:defaultNavigationController animated:YES completion:nil];
}

- (void)profileCloseAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)profileButtonPressed:(UIButton *)profileButton {
   [self profileAction];
}

- (void)shopAction {
    ShopViewController *shopViewController = [[ShopViewController alloc] init];
    DefaultNavigationController *shopNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:shopViewController];
    [self presentViewController:shopNavigationController animated:YES completion:nil];
}

#pragma mark - Notifications
- (void)updateCredits:(id)updateCredits {
    self.coinLabel.text = [[[Wallet instance] credits] stringValue];
}

- (BOOL)battlesTemplatesAvailable {
    return self.battleTemplates.count > 0;
}

@end
