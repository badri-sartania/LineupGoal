//
// Created by Anders Borre Hansen on 16/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <JGProgressHUD/JGProgressHUD.h>
#import "Crashlytics.h"
#import <BlocksKit/NSArray+BlocksKit.h>
#import <Mixpanel/Mixpanel.h>
//#import "SCLAlertView-Objective-C/SCLAlertView.h"
#import "SCLAlertView.h"
#import "BattleViewController.h"
#import "MenuButtonWithBadge.h"
#import "UserLineupTableViewController.h"
#import "Utils.h"
#import "Match.h"
#import "MatchCellView.h"
#import "SimpleTableSectionView.h"
#import "MatchPageViewController.h"
#import "PlayerSectionView.h"
#import "MessageViewController.h"
#import "DefaultNavigationController.h"
#import "PlayerViewController.h"
#import "SimpleTableSectionWithHeaderTextView.h"
#import "CoinView.h"
#import "DefaultTableView.h"
#import "BattlePlayerPointsTableViewCell.h"
#import "MatchesHelper.h"
#import "HelpViewController.h"
#import "UIColor+LineupBattle.h"
#import "BattleUserTableViewCell.h"
#import "ProfileTableViewController.h"
#import "SimpleLocale.h"
#import "NSObject+isNull.h"
#import "BattleInviteTableViewCell.h"
#import "SpinnerHelper.h"
#import "Answers.h"
#import "HexColors.h"
#import "OAStackView.h"


typedef NS_ENUM(NSInteger, BattleTableView) {
    LeaderboardBattleTableView,
    MatchesBattleTableView,
    PointsBattleTableView
};

typedef NS_ENUM(NSInteger, ActiveTabButton) {
    AllUserButton,
    FriendsButton
};

@interface BattleViewController ()
@property(nonatomic, strong) BattleViewModel *viewModel;
@property(nonatomic, strong) MenuButton *selectedMenuButton;
@property(nonatomic, strong) UIButton *selectedGameTabButton;

// Caching data properties

@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) UILabel *navTitle;
@property(nonatomic, strong) UILabel *navSubTitle;
@property(nonatomic, strong) MenuButton *menuGame;
@property(nonatomic, strong) MenuButton *menuMatches;
@property(nonatomic, strong) MenuButton *menuPlayers;
@property(nonatomic, strong) UIButton *tabGameAll;
@property(nonatomic, strong) UIButton *tabGameFriends;
@property(nonatomic, strong) UIView *tabGameFriendsView;

@property(nonatomic, strong) NSArray *leaderboardArray;
@property(nonatomic, strong) NSArray *competitions;
@property(nonatomic, strong) NSArray *playersArray;
@property(nonatomic, strong) MessageViewController *chatViewController;
@property(nonatomic, strong) User *currentUser;
@property(nonatomic, strong) MenuButtonWithBadge *menuChat;
@property(nonatomic, copy) NSString *lastSectionViewDateString;
@property(nonatomic, strong) DefaultTableView *tableView;
@property(nonatomic, strong) UITableView *friendsList;
@property(nonatomic, strong) JGProgressHUD *hud;
@property(nonatomic) BOOL battleTracked;
@property(nonatomic) NSInteger activeButton;
@end

@implementation BattleViewController

static NSInteger navigationBarHeight = 185;

- (id)initWithViewModel:(BattleViewModel *)viewModel {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;
        self.title = @"Battle";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"bell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(bellButtonPressed:)];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.openMethod = @"push";
        self.activeButton = AllUserButton;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];

    // Will invoke fetch game template command
    self.viewModel.active = YES;
    [self.menuChat setBadgeCounter:self.viewModel.chatHandler.getNumberOfUnreadMessages];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupTableView];
    [self setupTabGameFriendsContent];
    
//    UIView *headerView = [[UIView alloc] init];
//    [self.view addSubview:headerView];
//    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.left.top.equalTo(self.view);
//        make.height.equalTo(@140);
//    }];

    // Top
    DefaultLabel *battleName = [DefaultLabel initWithBoldSystemFontSize:14 color:[UIColor actionColor]];
    CoinView *battlePot = [[CoinView alloc] initWithCoins:0];
    battlePot.coinLabel.font = [UIFont boldSystemFontOfSize:12];
    DefaultLabel *battlePotDesc = [DefaultLabel initWithText:@"Total prize:"];
    battlePotDesc.font = [UIFont systemFontOfSize:12];
    DefaultLabel *battleState = [DefaultLabel initWithSystemFontSize:12];
    battlePot.hidden = YES;
    battlePotDesc.hidden = YES;

    // Menu
//    MenuButton *menuEntries = [[MenuButton alloc] initWithDelegate:self index:0 image: [UIImage imageNamed:@"battle_entries"] imageHighlighted:[UIImage imageNamed:@"battle_entries_selected"]];
//    MenuButton *menuMatches = [[MenuButton alloc] initWithDelegate:self index:1 image:[UIImage imageNamed:@"battle_ball"] imageHighlighted:[UIImage imageNamed:@"battle_ball_selected"]];
//    MenuButton *menuPlayers = [[MenuButton alloc] initWithDelegate:self index:2 image:[UIImage imageNamed:@"battle_player"] imageHighlighted:[UIImage imageNamed:@"battle_player_selected"]];
//    self.menuChat = [[MenuButtonWithBadge alloc] initWithDelegate:self index:3 image:[UIImage imageNamed:@"battle_chat"] imageHighlighted:nil];
//    self.menuChat.hidden = YES;

//    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
//    infoButton.tintColor = [UIColor actionColor];
//    [infoButton setTitleColor:[UIColor highlightColor] forState:UIControlStateHighlighted];
//    [headerView addSubview:infoButton];
//    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headerView).offset(20);
//        make.right.equalTo(headerView).offset(-17);
//        make.size.equalTo(@20);
//    }];
//    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
//
//    [headerView addSubview:battleName];
//    [headerView addSubview:battlePot];
//    [headerView addSubview:battlePotDesc];
//    [headerView addSubview:battleState];
//    [headerView addSubview:menuEntries];
//    [headerView addSubview:menuMatches];
//    [headerView addSubview:menuPlayers];
//    [headerView addSubview:self.menuChat];

    // Set highlight on first button;
//    [menuEntries setHighlighted:YES];
//    self.selectedMenuButton = menuEntries;

//    [@[battleName, battleState] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headerView);
//    }];
//
//    [@[battlePot] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headerView).offset(28);
//        make.height.equalTo(@14);
//    }];
//
//    [battleName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headerView).offset(20);
//    }];

//    [@[battlePot] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(battleName.mas_bottom).offset(3);
//    }];
//
//    [battlePotDesc mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(battlePot.mas_left).offset(-3);
//        make.centerY.equalTo(battlePot);
//    }];
//
//    [battleState mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(battlePot.mas_bottom).offset(3);
//    }];

    // Position Menu
//    CGFloat centerXOffsetInner = [Utils screenWidth] / 11.f;
//    CGFloat centerXOffsetOuter = [Utils screenWidth] / 3.5f;
//    [@[menuEntries, menuMatches, menuPlayers, self.menuChat] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headerView.mas_bottom);
//        make.width.equalTo(@40);
//        make.height.equalTo(@40);
//    }];
//    [menuEntries mas_updateConstraints:^(MASConstraintMaker *make) {
//       make.centerX.equalTo(headerView).offset(-centerXOffsetOuter);
//    }];
//    [menuMatches mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headerView).offset(-centerXOffsetInner);
//    }];
//    [menuPlayers mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headerView).offset(centerXOffsetInner);
//    }];
//    [self.menuChat mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headerView).offset(centerXOffsetOuter);
//    }];

    // Loading indicator until data has arrived
    self.hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];

    @weakify(self);
    [[[[[RACObserve(self.viewModel, model) ignore:nil] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]] map:^id (Battle *battle) {
        return @{
            @"currentUser": [battle.users bk_match:^BOOL (User *user) {
                return [user.current boolValue];
            }] ?: [NSNull null],
            @"sortedUsers": [BattleViewModel sortUsersByPoints:battle.users] ?: @[],
            @"competitions": [MatchesHelper sortedByDateAndGroupedByLeague:battle.matches] ?: @[],
            @"players": [BattleViewModel sortedPlayersWithModel:battle] ?: @[]
        };
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);

        self.currentUser = dic[@"currentUser"];
        self.leaderboardArray = dic[@"sortedUsers"];
        self.competitions = dic[@"competitions"];
        self.playersArray = dic[@"players"];

        [self.hud dismissAnimated:YES];
        [self.tableView reloadData];
        [self.friendsList reloadData];

        // Chat
        if (![self.currentUser isNull] && self.menuChat.hidden) {
            [[RACObserve(self.viewModel.chatHandler, initialChatMessagesAdded) ignore:@0] subscribeNext:^(id x) {
                @strongify(self);
                self.menuChat.hidden = NO;
                [self.menuChat setBadgeCounter:self.viewModel.chatHandler.getNumberOfUnreadMessages];
            }];

            [[self.viewModel.chatHandler observeMessagesChange] subscribeNext:^(RACTuple *arrayChange) {
                @strongify(self);
                [self.menuChat setBadgeCounter:self.viewModel.chatHandler.getNumberOfUnreadMessages];
            }];
        }

        // Battle Top Data
        self.navTitle.text = self.viewModel.model.template.name;
        self.navSubTitle.text = [self.viewModel.model stateString];
        
        battleName.text = self.viewModel.model.template.name;
        battleState.text = [self.viewModel.model stateString];
        [battlePot setCoins:[self.viewModel.model.pot integerValue]];
        battlePot.hidden = NO;
        battlePotDesc.hidden = NO;

        // Bell indicator
        [self setBellState:self.viewModel.model.subscribed];

#if !TARGET_IPHONE_SIMULATOR
        if (!self.battleTracked) {
            [Answers logContentViewWithName:self.viewModel.model.template.name contentType:@"battle" contentId:self.viewModel.model.template.objectId customAttributes:@{
               @"state": self.viewModel.model.stateString ?: [NSNull null],
               @"inviteOnly": @(self.viewModel.model.inviteOnly),
               @"joined": self.currentUser != nil ? @YES : @NO
            }];
            self.battleTracked = YES;
        }
#endif
    }];
}

#pragma mark - Setup UI
- (void)setupNavigationBar {
    // Setup navigation bar
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], navigationBarHeight)];
    [self.navigationBar setBackgroundColor:[UIColor hx_colorWithHexString:@"34495e"]];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(navigationBarHeight);
    }];
    
    self.navTitle = [[UILabel alloc] init];
    [self.navTitle setText:@"SATURDAY MIX"];
    self.navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    self.navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:self.navTitle];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(32);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@21);
    }];
    
    self.navSubTitle = [[UILabel alloc] init];
    [self.navSubTitle setText:@"Ends in 02:15:43"];
    self.navSubTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    self.navSubTitle.textColor = [UIColor hx_colorWithHexString:@"80ffffff"];
    [self.navigationBar addSubview:self.navSubTitle];
    [self.navSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navTitle.mas_bottom);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@15);
    }];
    
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navButton setImage:[UIImage imageNamed:@"ic_back"]
               forState:UIControlStateNormal];
    [navButton setContentMode:UIViewContentModeCenter];
    [navButton addTarget:self
                  action:@selector(goBack)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navButton];
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).offset(20);
        make.width.equalTo(@54);
        make.height.equalTo(@44);
    }];
    
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navRightButton setImage:[UIImage imageNamed:@"ic_bell_empty"]
                    forState:UIControlStateNormal];
    [navRightButton setContentMode:UIViewContentModeCenter];
    [navRightButton addTarget:self
                       action:@selector(bellButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navRightButton];
    [navRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).offset(20);
        make.width.equalTo(@54);
        make.height.equalTo(@44);
    }];
    
    UIView *tabView = [[UIView alloc] init];
    [self.navigationBar addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar);
        make.right.equalTo(self.navigationBar);
        make.bottom.equalTo(self.navigationBar);
        make.height.mas_equalTo(@96);
    }];
    
    self.menuGame = [[MenuButton alloc] initWithDelegate:self index:0 image: [UIImage imageNamed:@"img_battle_game"] imageHighlighted:[UIImage imageNamed:@"img_battle_game_selected"] title: @"GAME"];
    self.menuMatches = [[MenuButton alloc] initWithDelegate:self index:1 image:[UIImage imageNamed:@"img_battle_matches"] imageHighlighted:[UIImage imageNamed:@"img_battle_matches_selected"] title: @"MATCHES"];
    self.menuPlayers = [[MenuButton alloc] initWithDelegate:self index:2 image:[UIImage imageNamed:@"img_battle_players"] imageHighlighted:[UIImage imageNamed:@"img_battle_players_selected"] title: @"PLAYERS"];
    
    [tabView addSubview:self.menuGame];
    [tabView addSubview:self.menuMatches];
    [tabView addSubview:self.menuPlayers];
    
    [@[self.menuGame, self.menuMatches, self.menuPlayers] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tabView.mas_bottom);
        make.width.equalTo(@70);
        make.height.equalTo(@96);
    }];
    
    CGFloat centerXOffsetSide = [Utils screenWidth] / 3.f;
    
    [self.menuGame mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tabView).offset(-centerXOffsetSide);
    }];
    [self.menuMatches mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tabView);
    }];
    [self.menuPlayers mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tabView).offset(centerXOffsetSide);
    }];
    
    // Set highlight on first button;
    [self.menuGame setHighlighted:YES];
    self.selectedMenuButton = self.menuGame;
}

- (void) setupTableView {
    self.tableView = [[DefaultTableView alloc] init];
    [self.tableView enableRefreshControl];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.defaultTableViewDelegate = self;
    [self.tableView registerClass:[BattleUserTableViewCell class] forCellReuseIdentifier:@"leaderboardViewCell"];
    [self.tableView registerClass:[MatchCellView class] forCellReuseIdentifier:@"matchCellView"];
    [self.tableView registerClass:[BattlePlayerPointsTableViewCell class] forCellReuseIdentifier:@"playerCellView"];
    [self.tableView registerClass:[BattleInviteTableViewCell class] forCellReuseIdentifier:@"inviteTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (UIView *)setupSegmentSectionHeader {
    // SegmentView
    self.tabGameAll = [[UIButton alloc] init];
    [self.tabGameAll setTitle:@"ALL" forState:UIControlStateNormal];
    self.tabGameAll.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 12];
    [self.tabGameAll.layer setCornerRadius:15];
    [self.tabGameAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@106);
        make.height.equalTo(@30);
    }];
    [self.tabGameAll addTarget:self
                        action:@selector(onTabAllClicked)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.tabGameFriends = [[UIButton alloc] init];
    [self.tabGameFriends setTitle:@"FRIENDS" forState:UIControlStateNormal];
    self.tabGameFriends.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 12];
    [self.tabGameFriends.layer setCornerRadius:15];
    [self.tabGameFriends mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@106);
        make.height.equalTo(@30);
    }];
    [self.tabGameFriends addTarget:self
                            action:@selector(onTabFriendsClicked)
                  forControlEvents:UIControlEventTouchUpInside];
    
    OAStackView *tabContainer = [[OAStackView alloc] initWithArrangedSubviews:@[self.tabGameAll, self.tabGameFriends]];
    tabContainer.spacing = 30.f;
    
    UIView *container = [[UIView alloc] init];
    [container addSubview:tabContainer];
    [tabContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(container);
    }];
    
    [self updateTabStatus:self.activeButton];
    return container;
}

- (void)makeActive:(UIButton *)button isActive:(BOOL) active{
    if (active) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor hx_colorWithHexString:@"34495e"]];
    } else {
        [button setTitleColor:[UIColor hx_colorWithHexString:@"34495e"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)onTabAllClicked {
    [self updateTabStatus:AllUserButton];
}

- (void)onTabFriendsClicked {
    [self updateTabStatus:FriendsButton];
}

- (void)updateTabStatus:(NSInteger)activeButton {
    self.activeButton = activeButton;
    if (activeButton == AllUserButton) {
        [self makeActive:self.tabGameAll isActive:YES];
        [self makeActive:self.tabGameFriends isActive:NO];
        self.selectedGameTabButton = self.tabGameAll;
        [self.tabGameFriendsView setHidden:YES];
    } else {
        [self makeActive:self.tabGameFriends isActive:YES];
        [self makeActive:self.tabGameAll isActive:NO];
        self.selectedGameTabButton = self.tabGameFriends;
        [self.tabGameFriendsView setHidden:NO];
    }
}

- (void)setupTabGameFriendsContent {
    self.tabGameFriendsView = [[UIView alloc] init];
    [self.view addSubview:self.tabGameFriendsView];
    [self.tabGameFriendsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(50);
    }];
    
    self.friendsList = [[UITableView alloc] init];
    self.friendsList.delegate = self;
    self.friendsList.dataSource = self;
    [self.friendsList registerClass:[BattleUserTableViewCell class] forCellReuseIdentifier:@"leaderboardViewCell"];
    self.friendsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tabGameFriendsView addSubview:self.friendsList];
    [self.friendsList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tabGameFriendsView);
    }];
    
    UIView *connectView = [[UIView alloc] init];
    [self.tabGameFriendsView addSubview:connectView];
    [connectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabGameFriendsView).offset(259);
        make.left.right.bottom.equalTo(self.tabGameFriendsView);
    }];
    
    UILabel *lblDescription = [[UILabel alloc] init];
    lblDescription = [[UILabel alloc] init];
    [lblDescription setText:@"See your friends lineups!"];
    lblDescription.font = [UIFont fontWithName:@"NanumPen" size:25.0f];
    lblDescription.textColor = [UIColor hx_colorWithHexString:@"2c3e50"];
    [lblDescription setTextAlignment:NSTextAlignmentCenter];
    [connectView addSubview:lblDescription];
    [lblDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(connectView);
        make.height.mas_equalTo(@29);
    }];
    
    UIButton *btnFacebook = [[UIButton alloc] init];
    [btnFacebook setImage:[UIImage imageNamed:@"img_facebook_button"]
               forState:UIControlStateNormal];
    [btnFacebook setContentMode:UIViewContentModeCenter];
    [btnFacebook addTarget:self
                  action:@selector(goBack)
        forControlEvents:UIControlEventTouchUpInside];
    [connectView addSubview:btnFacebook];
    [btnFacebook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblDescription.mas_bottom).offset(7);
        make.centerX.equalTo(connectView);
        make.width.equalTo(@278);
        make.height.equalTo(@40);
    }];
    
    UILabel *lblSubDescription = [[UILabel alloc] init];
    lblSubDescription = [[UILabel alloc] init];
    [lblSubDescription setText:@"No spamming over, we promise."];
    lblSubDescription.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    lblSubDescription.textColor = [UIColor hx_colorWithHexString:@"3498db"];
    [lblSubDescription setTextAlignment:NSTextAlignmentCenter];
    [connectView addSubview:lblSubDescription];
    [lblSubDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnFacebook.mas_bottom).offset(3);
        make.left.right.equalTo(connectView);
        make.height.mas_equalTo(@16);
    }];
    
    [self.tabGameFriendsView setHidden:YES];
}

#pragma mark - Action

- (void)showInfo {
    HelpViewController *battleInfoViewController = [[HelpViewController alloc] initForBattle];
    UINavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:battleInfoViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)refreshTable {
    @weakify(self);
    [[self.viewModel refreshDataSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView stopSpinner];
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView stopSpinner];
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self typeOfTableView]) {
        case LeaderboardBattleTableView:
            return 64.f;
        case MatchesBattleTableView:
            return 52.f;
        default:
            return 64.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch ([self typeOfTableView]) {
        case MatchesBattleTableView:
            return self.competitions.count;
        default:
            return 1;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        switch ([self typeOfTableView]) {
                case MatchesBattleTableView: {
                    return [MatchesHelper heightForSection:section competitions:self.competitions];
                }
                case LeaderboardBattleTableView: {
                    return 50.f;
                }
                case PointsBattleTableView: {
                    return 0.f;
                }
            default:
                return 30.f;
        }
    }
    return 0.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        switch ([self typeOfTableView]) {
                case LeaderboardBattleTableView: {
                    UIView *sectionView = [self setupSegmentSectionHeader];
                    sectionView.backgroundColor = [UIColor whiteColor];
                    return sectionView;
                };
                case PointsBattleTableView: {
                    return nil;
                };
                case MatchesBattleTableView: {
                    NSDictionary *league = self.competitions[(NSUInteger) section];
                    SimpleTableSectionView *sectionView;
                    
//                    if ([MatchesHelper shouldDisplaySectionWithHeaderTextWithCompetitions:self.competitions section:section]) {
//                        NSString *headerText = [[YLMoment momentWithDate:league[@"date"]] format:@"EEEE d LLLL"];
//                        sectionView = [[SimpleTableSectionWithHeaderTextView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70.f) text:headerText];
//                        self.lastSectionViewDateString = league[@"dateString"];
//                    } else {
//                        sectionView = [[SimpleTableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.f)];
//                        [sectionView setUnderlineToNormalPosition];
//                    }
                    sectionView = [[SimpleTableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.f)];
                    [sectionView setSectionDataWithTitle:league[@"name"] flagCode:league[@"country"] countryCodeFormat:CountryCodeFormatFifa];
                    sectionView.backgroundColor = [UIColor whiteColor];
                    
                    return sectionView;
                }
            default:
                return UIView.new;
        };
    }
    return UIView.new;
}

- (NSInteger)typeOfTableView {
    return self.selectedMenuButton.index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        switch ([self typeOfTableView]) {
            case LeaderboardBattleTableView:
                return self.leaderboardArray.count+[self inviteOnlyButtonCount];
            case MatchesBattleTableView:
                return ((NSArray *)self.competitions[(NSUInteger)section][@"matches"]).count;
            case PointsBattleTableView:
                return self.playersArray.count;
            default:
                return 0;
        };
    } else {
        return 3;
    }
}

- (NSUInteger)inviteOnlyButtonCount {
    return self.viewModel.model.inviteOnly && self.viewModel.model.state == BattleTemplateStateNotStarted && self.currentUser ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        switch ([self typeOfTableView]) {
                case LeaderboardBattleTableView: {
                    if ([self.leaderboa]rdArray.count == indexPath.row) {
                        BattleInviteTableViewCell *cell = (BattleInviteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"inviteTableViewCell" forIndexPath:indexPath];
                        [cell markAsFull:[self.viewModel.model isFull] position:0];
                        return cell;
                    } else {
                        User *user = self.leaderboardArray[(NSUInteger)indexPath.row];
                        BattleUserTableViewCell *cell = (BattleUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leaderboardViewCell" forIndexPath:indexPath];
                        
//                        NSInteger placement = self.viewModel.model.state == BattleTemplateStateNotStarted ? indexPath.row + 1 : [user.pos integerValue];
                        [cell setUser:user points:[user.points integerValue] placement:indexPath.row + 1 battle:self.viewModel.model];
                        return cell;
                    }
                }
                case MatchesBattleTableView: {
                    Match *match = self.competitions[(NSUInteger)indexPath.section][@"matches"][(NSUInteger)indexPath.row];
                    MatchCellView *cell = (MatchCellView *)[tableView dequeueReusableCellWithIdentifier:@"matchCellView" forIndexPath:indexPath];
                    [cell setupMatch:match];
                    return cell;
                }
                case PointsBattleTableView: {
                    Player *player = self.playersArray[(NSUInteger)indexPath.row];
                    BattlePlayerPointsTableViewCell *cell = (BattlePlayerPointsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"playerCellView" forIndexPath:indexPath];
                    [cell setPlayer:player placement:indexPath.row+1];
                    
                    return cell;
                }
            default:
                return nil;
        }
    } else {
        User *user = indexPath.row == 0 ? self.currentUser : [[User alloc] init];
        BattleUserTableViewCell *cell = (BattleUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leaderboardViewCell" forIndexPath:indexPath];
        
//        NSInteger placement = self.viewModel.model.state == BattleTemplateStateNotStarted ? indexPath.row + 1 : [user.pos integerValue];
        [cell setUser:user points:[user.points integerValue] placement:indexPath.row + 1 battle:self.viewModel.model];
        [cell showCoinView:NO];
        if (indexPath.row > 0) {
            [cell setupFriendRowAt: indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        switch ([self typeOfTableView]) {
            case LeaderboardBattleTableView: {
                if (self.leaderboardArray.count == indexPath.row) {
                    InviteFriendsTableViewController *tableViewController = [[InviteFriendsTableViewController alloc] initWithBattleViewModel:self.viewModel];
                    tableViewController.delegate = self;
                    
                    if ([self.viewModel.model isFull]) {
                        [self showFullBattleAlert];
                    } else {
                        [self.navigationController pushViewController:tableViewController animated:YES];
                    }
                } else {
                    User *user = self.leaderboardArray[(NSUInteger)indexPath.row];
                    UserLineupTableViewController *userLineupTableViewController = [[UserLineupTableViewController alloc] initUser:user viewModel:self.viewModel];
                    [self.navigationController pushViewController:userLineupTableViewController animated:YES];
                }
                
                break;
            }
            case MatchesBattleTableView: {
                Match *match = self.competitions[(NSUInteger)indexPath.section][@"matches"][(NSUInteger) indexPath.row];
                CLS_LOG(@"Match %@", match.objectId);
                
                DefaultSubscriptionViewController *subscriptionViewControllerWithMatchPageViewController = [[[MatchPageViewController alloc] initWithMatch:match] wrapInSubscriptionViewController];
                [self.navigationController pushViewController:subscriptionViewControllerWithMatchPageViewController animated:YES];
                break;
            }
            case PointsBattleTableView: {
                Player *player = self.playersArray[(NSUInteger)indexPath.row];
                
                // Load player view
                PlayerViewController *playerViewController = [PlayerViewController initWithPlayer:player];
                [[Mixpanel sharedInstance] track:@"Player" properties:@{
                                                                        @"id": player.objectId ?: [NSNull null],
                                                                        @"name": player.name ?: [NSNull null],
                                                                        @"from": @"battle"
                                                                        }];
                [self.navigationController pushViewController:playerViewController animated:YES];
            }
            default:
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            ProfileTableViewController *profileTableViewController = [[ProfileTableViewController alloc] initWithProfileId:self.currentUser.objectId];
            UINavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:profileTableViewController];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        }
    }
}

- (void)showFullBattleAlert {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = FadeIn;
    [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
    [alert showNotice:self title:@"Battle Full" subTitle:[NSString stringWithFormat:@"Only %@ users can join or be invited to a battle", self.viewModel.model.template.maxUsers] closeButtonTitle:@"Got it" duration:0];
}

#pragma mark - Bell state
- (void)setBellState:(BOOL)subscribed {
    self.navigationItem.rightBarButtonItem.image = subscribed ? [UIImage imageNamed:@"bell_selected"] : [UIImage imageNamed:@"bell"];
}

#pragma mark - Button delegate
- (void)menuButtonPressed:(MenuButton *)menuButton {
    if (menuButton.index < 3) {
        [self.selectedMenuButton setHighlighted:NO];
        [menuButton setHighlighted:YES];
        self.selectedMenuButton = menuButton;
        [self.tableView reloadData];
        [self.friendsList reloadData];
        self.chatViewController.view.hidden = YES;
        
        if (menuButton == self.menuGame && self.selectedGameTabButton == self.tabGameFriends) {
            [self makeActive:self.tabGameFriends isActive:YES];
            [self makeActive:self.tabGameAll isActive:NO];
            [self.tabGameFriendsView setHidden:NO];
        } else {
            [self makeActive:self.tabGameAll isActive:YES];
            [self makeActive:self.tabGameFriends isActive:NO];
            [self.tabGameFriendsView setHidden:YES];
        }
    } else {
        MessageViewController *viewController = [[MessageViewController alloc] initWithChatHandler:self.viewModel.chatHandler];
        DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:viewController];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)goBack {
    if ([self.openMethod isEqualToString:@"push"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)bellButtonPressed:(id)bellButtonPressed {
    @weakify(self);
    [APNHelper showBattleNotificationControlsFor:self type:^(BattleNotificationControl control) {
        @strongify(self);
        [self setBellState:control < BattleNotificationControlNoMatches];
        [self.viewModel handleSubscriptionChoice:control];
    } title:[SimpleLocale USAlternative:@"Game notifications" forString:@"Match notifications"] message:@"Change your notification selection"];
}

- (void)friendsSelected:(InviteFriendsTableViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
    self.hud.textLabel.text = @"Updating";
    [self.hud showInView:self.view animated:YES];
    [self refreshTable];
}

@end
