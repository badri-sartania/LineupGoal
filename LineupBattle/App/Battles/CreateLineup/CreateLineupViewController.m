//
// Created by Anders Borre Hansen on 16/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <BlocksKit/UIAlertView+BlocksKit.h>
#import "Crashlytics.h"
#import "FieldItemView.h"
#import "CreateLineupViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "Utils.h"
#import "Identification.h"
#import "DefaultTableView.h"
#import "SimpleTableSectionView.h"
#import "Match.h"
#import "MatchCellView.h"
#import "DefaultSubscriptionViewController.h"
#import "MatchPageViewController.h"
#import "NSMutableArray+Flatten.h"
#import "Lineup.h"
#import "NSDate+Lineupbattle.h"
#import "UIColor+LineupBattle.h"
#import "SimpleTableSectionWithHeaderTextView.h"
#import "MatchesHelper.h"
#import "HelpViewController.h"
#import "ProfileImageWithBadgeView.h"
#import "FlagView.h"
#import "SimpleLocale.h"
#import "Wallet.h"
#import "ShopViewController.h"
#import "DefaultNavigationController.h"
#import "Mixpanel.h"
#import "OAStackView.h"
#import "SpinnerHelper.h"
#import "SCLAlertView.h"
#import "Date.h"
#import "HexColors.h"
#import <AFNetworking/AFURLResponseSerialization.h>

#import "BattleViewModel.h"
#import "BattleViewController.h"


@interface CreateLineupViewController ()
@property(nonatomic, strong) BattleTemplateViewModel *viewModel;
@property(nonatomic, strong) BattleFieldPlayerView *lastFieldItemView;
@property(nonatomic, strong) DefaultLabel *name;
@property(nonatomic, strong) DefaultTableView *tableView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) FieldView *fieldView;
//@property(nonatomic, strong) CaptainButton *captainButton;
@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) MZTimerLabel *timer;
@property(nonatomic, copy) NSString *lastSectionViewDateString;
@property(nonatomic, strong) NSTimer *endOfBattleIntervalTimer;
@property(nonatomic) NSUInteger lastTeamSelectPlayerOffset;
@property(nonatomic, strong) NSArray *teamsInMatchOrder;

@property(nonatomic, strong) UIButton *tabLineupButton;
@property(nonatomic, strong) UIButton *tabMatchesButton;

@property(nonatomic, strong) UIView *statusView;
@property(nonatomic, strong) MZTimerLabel *lbStatus;

// Stats
@property (nonatomic) NSInteger mixpanelNumberOfPicks;
@property (nonatomic) NSInteger mixpanelNumberOfMaxPerTeamErrors;
@property (nonatomic) BOOL mixpanelCaptainErrorShown;
@property (nonatomic) BOOL mixpanelLineupInvalidShown;
@property (nonatomic) BOOL mixpanelLineupShopShown;
@property (nonatomic) BOOL mixpanelTimesUp;
@end

static NSInteger navigationBarHeight = 64;
static NSInteger joinButtonHeight = 67;

@implementation CreateLineupViewController

- (instancetype)initCreateInviteOnlyBattleWithDelegate:(id <CreateLineupViewControllerDelegate>)delegate battleTemplateId:(NSString *)battleTemplateId {
    self = [self initPublicBattleWithDelegate:delegate battleTemplateId:battleTemplateId];

    if (self) {
        self.viewModel.inviteOnly = YES;
        self.navigationItem.rightBarButtonItem.title = @"Create";
    }

    return self;
}

- (instancetype)initJoinInvitedBattle:(Battle *)battle delegate:(id <CreateLineupViewControllerDelegate>)delegate {
    self = [self initPublicBattleWithDelegate:delegate battleTemplateId:battle.template.objectId];

    if (self) {
        self.viewModel.inviteOnly = YES;
        self.viewModel.battle = battle;
        self.buildMode = @"create";
    }

    return self;
}

// Public join
- (instancetype)initPublicBattleWithDelegate:(id <CreateLineupViewControllerDelegate>)delegate battleTemplateId:(NSString *)battleTemplateId {
    self = [super init];

    if (self) {
        self.viewModel = [[BattleTemplateViewModel alloc] initWithEmptyLineupAndBattleTemplateId:battleTemplateId];
        self.delegate = delegate;
        self.buildMode = @"create";
//        self.navigationItem.title = @"CREATE A LINEUP";
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStylePlain target:self action:@selector(submitTeam)];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        self.timer = [[MZTimerLabel alloc] init];
//        self.timer.frame = CGRectMake(0,0,120,20);
//        self.timer.timeLabel.font = [UIFont systemFontOfSize:18.0f];
//        self.timer.timeLabel.textColor = [UIColor whiteColor];
//        self.timer.timeLabel.textAlignment = NSTextAlignmentCenter;
//
//        self.navigationItem.titleView = self.timer;
    }

    return self;
}

- (instancetype)initEditBattleWithDelegate:(id <CreateLineupViewControllerDelegate>)delegate battle:(Battle *)battle {
    self = [super init];
    if (self) {
        self.viewModel = [[BattleTemplateViewModel alloc] initWithBattle:battle];
        self.delegate = delegate;
        self.isEditingExistingLineup = YES;
        self.buildMode = @"edit";
        self.navigationItem.title = @"Edit Lineup";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateLineupAction)];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    [self.tableView deselectCellSelection];

    if (self.viewModel.model.startDate) {
        [self updateTimer];
    }

    self.endOfBattleIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkIfBattleHasStarted) userInfo:nil repeats:YES];

    // Will invoke fetch game template command
    self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;

    [self invalidateTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[Mixpanel sharedInstance] timeEvent:@"Create lineup event"];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupBottomView];
    [self setupScrollContent];
    
    [self loadInitialData];
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

    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
    }];
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navButton setContentMode:UIViewContentModeCenter];
    [navButton addTarget:self
                  action:@selector(cancelAction)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navButton];
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).offset(20);
        make.bottom.equalTo(self.navigationBar);
        make.width.equalTo(@54);
    }];
    
    if ([self.buildMode isEqualToString:@"create"]) {
        [navTitle setText:@"CREATE A LINEUP"];
        [navButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    } else {
        [navTitle setText:@"YOUR LINEUP"];
        [navButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    }
    
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navRightButton setImage:[UIImage imageNamed:@"ic_rules"]
               forState:UIControlStateNormal];
    [navRightButton setContentMode:UIViewContentModeCenter];
    [navRightButton addTarget:self
                  action:@selector(showInfo)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navRightButton];
    [navRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).offset(20);
        make.bottom.equalTo(self.navigationBar);
        make.width.equalTo(@54);
    }];
}

- (UIView *)setupStatusAndProfileView {
    self.statusView = [[UIView alloc] init];
    [self.view addSubview:self.statusView];
    
//    self.lbStatus = [[UILabel alloc] init];
    self.lbStatus = [[MZTimerLabel alloc] init];
    self.lbStatus.delegate = self;
    [self.lbStatus sizeToFit];
    [self.statusView addSubview:self.lbStatus];

    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    [self.statusView setBackgroundColor:[UIColor hx_colorWithHexString:@"#E74C3C"]];
    
    [self.lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusView);
        make.centerX.equalTo(self.statusView);
    }];
    self.lbStatus.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    self.lbStatus.text = @"";
    self.lbStatus.textColor = [UIColor whiteColor];
    
    UIView *profileView = [[UIView alloc] init];
    [self.view addSubview:profileView];
    [profileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusView.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@54);
    }];
    
    // Button
    UIButton *button = [[UIButton alloc] init];
    [button setContentMode:UIViewContentModeCenter];
    [button addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(onTapUser:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(cancelHighlight:) forControlEvents:UIControlEventTouchCancel];
    [profileView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(profileView);
        make.left.equalTo(profileView);
        make.right.equalTo(profileView);
        make.bottom.equalTo(profileView);
    }];
    
    // Profile Photo
    ProfileImageWithBadgeView *profileImageWithBadgeView = [[ProfileImageWithBadgeView alloc] initWithImageName:nil badgeText:nil];
    if (_user.photoToken) [profileImageWithBadgeView.imageViewWithBadge.imageView loadImageWithUrlString:[_user profileImagePath:80] placeholder:@"playerPlaceholder"];
    [profileView addSubview:profileImageWithBadgeView];
    
    [profileImageWithBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(@5);
    }];
    
    // Name, Flag
    DefaultLabel *nameLabel = [DefaultLabel initWithText:self.user.name];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    nameLabel.textColor = [UIColor primaryTextColor];
    FlagView *flagView = [[FlagView alloc] initWithCountryCode:self.user.country countryCodeFormat:CountryCodeFormatISO31661Alpha2];
    [profileView addSubview:nameLabel];
    [profileView addSubview:flagView];
    
    [@[nameLabel, flagView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(profileImageWithBadgeView.mas_right).offset(10);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
    }];
    [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@25);
        make.height.equalTo(@24);
    }];
    
    // Right chevron right image
    UIImageView *imageRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_gray_arrow_right"]];
    [profileView addSubview:imageRight];
    [imageRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(profileView);
        make.right.equalTo(profileView).offset(-5);
    }];
    
    return profileView;
}

- (UIView *)setupTabView {
    // Battle name
    self.name = [DefaultLabel initWithCenterText:@" "];
    self.name.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0f];
    self.name.textColor = [UIColor hx_colorWithHexString:@"34495e"];
    
    // inviteOnlyIndicator
    DefaultLabel *inviteOnlyIndicator = [DefaultLabel initWithCenterText:@"Invite-Only"];
    inviteOnlyIndicator.hidden = !self.viewModel.inviteOnly;
    
    OAStackView *stackView = [[OAStackView alloc] initWithArrangedSubviews:@[self.name, inviteOnlyIndicator]];
    stackView.spacing = 3.f;
    [self.view addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    UIColor *borderBottomColor = [UIColor hx_colorWithHexString:@"ECF0F1"];
    UIView *borderView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f)];
    [borderView setBackgroundColor:borderBottomColor];
    [self.view addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stackView.mas_bottom).offset(6);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    // SegmentView
    self.tabLineupButton = [[UIButton alloc] init];
    [self.tabLineupButton setTitle:@"YOUR LINEUP" forState:UIControlStateNormal];
    self.tabLineupButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 12];
    [self makeActive:self.tabLineupButton isActive:YES];
    [self.tabLineupButton.layer setCornerRadius:15];
    [self.tabLineupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@106);
        make.height.equalTo(@30);
    }];
    [self.tabLineupButton addTarget:self
                             action:@selector(onTabLineupClicked)
                   forControlEvents:UIControlEventTouchUpInside];
    
    self.tabMatchesButton = [[UIButton alloc] init];
    [self.tabMatchesButton setTitle:@"MATCHES" forState:UIControlStateNormal];
    self.tabMatchesButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 12];
    [self makeActive:self.tabMatchesButton isActive:NO];
    [self.tabMatchesButton.layer setCornerRadius:15];
    [self.tabMatchesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@106);
        make.height.equalTo(@30);
    }];
    [self.tabMatchesButton addTarget:self
                              action:@selector(onTabMatchesClicked)
                    forControlEvents:UIControlEventTouchUpInside];
    
    OAStackView *tabContainer = [[OAStackView alloc] initWithArrangedSubviews:@[self.tabLineupButton, self.tabMatchesButton]];
    tabContainer.spacing = 30.f;
    [self.view addSubview:tabContainer];
    [tabContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    return tabContainer;
}

- (void)setupScrollContent {
    UIView *headerSection;
    if ([self.buildMode isEqualToString:@"edit"]) {
        headerSection = [self setupStatusAndProfileView];
    } else {
        // Stackview
        headerSection = [self setupTabView];
    }
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.top.equalTo(headerSection.mas_bottom).offset(10);
    }];
    
    /*
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"YOUR LINEUP", [SimpleLocale USAlternative:@"MATCHES" forString:@"Matches"]]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    [segmentedControl setTintColor:[UIColor actionColor]];
    [contentView addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stackView);
        make.top.equalTo(borderView.mas_bottom).offset(10.f);
    }];
     */
    
    //    // Create Team text
    //    DefaultLabel *createTeamHeaderLabel = [DefaultLabel initWithText:@"Create your team"];
    //    createTeamHeaderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    //    [self.scrollView addSubview:createTeamHeaderLabel];
    //    [createTeamHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(contentView);
    //        make.top.equalTo(segmentedControl.mas_bottom).offset(15);
    //    }];
    //
    //    // Create Team subtext
    //    DefaultLabel *createTeamSubHeaderLabel = [DefaultLabel initWithText:[NSString stringWithFormat:@"Pick the best players from available %@", [SimpleLocale USAlternative:@"games" forString:@"matches"]]];
    //    createTeamSubHeaderLabel.font = [UIFont systemFontOfSize:12];
    //    [self.scrollView addSubview:createTeamSubHeaderLabel];
    //    [createTeamSubHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(contentView);
    //        make.top.equalTo(createTeamHeaderLabel.mas_bottom).offset(4);
    //    }];
    
    // Field image
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"halffield"]];
    self.imageView.clipsToBounds = YES;
    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@477);
        make.width.equalTo(@([Utils screenWidth] - 4));
    }];
    
    // Field players
    self.fieldView = [[FieldView alloc] init];
    self.fieldView.delegate = self;
    self.fieldView.dataSource = self;
    [self.scrollView addSubview:self.fieldView];
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(12);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@([Utils screenWidth] - 4));
        make.height.equalTo(@(468));
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-2);
    }];
    
    // Captain button
    /*
    self.captainButton = [[CaptainButton alloc] init];
    self.captainButton.delegate = self;
    [self.scrollView addSubview:self.captainButton];
    [self.captainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@65);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.captainButton.mas_bottom);
    }];
     */
    
    //Setup tableView
    self.tableView = [[DefaultTableView alloc] initWithDelegate:self];
    [self.tableView registerClass:[MatchCellView class] forCellReuseIdentifier:@"matchCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerSection.mas_bottom).offset(6);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-4);
    }];
    self.tableView.hidden = YES;
}

- (void)setupBottomView {
    self.bottomView = [[UIView alloc] init];
    [self.bottomView setBackgroundColor:[UIColor hx_colorWithHexString:@"34495e"]];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(joinButtonHeight));
    }];
    
    UIButton *joinButton = [[UIButton alloc] init];
    if ([self.buildMode isEqualToString:@"create"]) {
        [joinButton setTitle:@"Join game" forState:UIControlStateNormal];
        [joinButton addTarget:self
                       action:@selector(submitTeam)
             forControlEvents:UIControlEventTouchUpInside];
    } else {
        [joinButton setTitle:@"SUBMIT CHANGES" forState:UIControlStateNormal];
        [joinButton addTarget:self
                       action:@selector(updateLineupAction)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
    [joinButton setTitleColor:[UIColor hx_colorWithHexString:@"2ecc71"] forState:UIControlStateNormal];
    joinButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 18];
    [self.bottomView addSubview:joinButton];
    [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
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

#pragma mark - action

- (void)loadInitialData {
    //* TODO: - uncomment after api integration
     
     // Progress hud shown before data is loaded
     JGProgressHUD *hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];
     
     // Reload data
     @weakify(self, hud);
     [[RACObserve(self.viewModel, model) ignore:nil] subscribeNext:^(BattleTemplate *battleTemplate) {
         @strongify(self, hud);
         self.name.text = battleTemplate.name;
         [self.fieldView reloadData];
     
         // TODO: - integrate captain logic
//         [self.captainButton setPlayer:self.viewModel.lineup.captain];
     
         if ([[[YLMoment momentWithDate:self.viewModel.model.startDate] startOf:@"day"].date greaterThan:[NSDate date]]) {
             self.timer.timeFormat =  @"d'd' HH:mm:ss";
             self.lbStatus.timeFormat =  @"d'd' HH:mm:ss";
         }
         
         [self updateTimer];
     
         [hud dismissAnimated:YES];
         [self checkIfBattleHasStarted];
         [self setSubmitButtonColor];
     } error:^(NSError *error) {
         @strongify(hud);
         [hud dismissAnimated:YES];
     }];
     
     // */
    
    /* TODO: - commment after api integration
    self.name.text = @"TEST BATTLE";
    [self.fieldView reloadData];
    
//    [self.captainButton setPlayer:self.viewModel.lineup.captain];
    
    if ([[[YLMoment momentWithDate:self.viewModel.model.startDate] startOf:@"day"].date greaterThan:[NSDate date]]) {
        self.timer.timeFormat =  @"d'd' HH:mm:ss";
    }
    
    [self updateTimer];
    
    //    [hud dismissAnimated:YES];
    [self checkIfBattleHasStarted];
    [self setSubmitButtonColor];
    // */
}

- (void)updateTimer {
    // Timer to game start
//    self.timer.timerType = MZTimerLabelTypeTimer;
//    [self.timer setCountDownToDate:self.viewModel.model.startDate];
//    self.timer.textColor = [UIColor blackColor];
//    [self.timer start];
    
    self.lbStatus.timerType = MZTimerLabelTypeTimer;
    [self.lbStatus setCountDownToDate:self.viewModel.model.startDate];
    self.lbStatus.textColor = [UIColor whiteColor];
    [self.lbStatus start];
}

- (void)setSubmitButtonColor {
    NSString *color = self.viewModel.lineup.valid ? @"#1d952b" : @"#bef3c4";
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor hx_colorWithHexString:color];
}

- (void)onTabLineupClicked {
    [self makeActive:self.tabLineupButton isActive:YES];
    [self makeActive:self.tabMatchesButton isActive:NO];
    self.tableView.hidden = YES;
    self.scrollView.hidden = NO;
//    self.captainButton.hidden = NO;
    self.infoButton.hidden = NO;
}

- (void)onTabMatchesClicked {
    [self makeActive:self.tabMatchesButton isActive:YES];
    [self makeActive:self.tabLineupButton isActive:NO];
    self.tableView.hidden = NO;
    self.scrollView.hidden = YES;
//    self.captainButton.hidden = YES;
    self.infoButton.hidden = YES;
    [self.tableView reloadData];
}

#pragma mark - TimerLabel Delegate
-(NSString*)timerLabel:(MZTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    NSString* strStatus;
    if (time > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"d'd' HH:mm:ss";
        
        strStatus = [NSString stringWithFormat:@"Game starts in %@", [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
    } else {
        strStatus = @"Game started";
        [self.lbStatus pause];
    }
    
    return strStatus;
}

// TODO: - remove after test
- (void)valueChanged:(id)valueChanged {
    if (((UISegmentedControl *)valueChanged).selectedSegmentIndex == 0) {
        self.tableView.hidden = YES;
        self.scrollView.hidden = NO;
//        self.captainButton.hidden = NO;
        self.infoButton.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.scrollView.hidden = YES;
//        self.captainButton.hidden = YES;
        self.infoButton.hidden = YES;
        [self.tableView reloadData];
    }
}

#pragma mark - Field Delegate
- (NSInteger)numberOfSectionsInFieldView:(FieldView *)fieldView {
    return self.viewModel.lineup.lineup.count;
}

- (NSInteger)numberOfItemsForSectionInFieldView:(FieldView *)fieldView section:(NSInteger)section {
    return [self sectionArray:section].count;
}

- (BOOL)fieldViewShouldBeReversed:(FieldView *)fieldView {
    return YES;
}

- (CGFloat)fieldView:(FieldView *)fieldView marginForSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)fieldView:(FieldView *)fieldView marginBetweenItemsInSection:(NSInteger)section {
    return [Utils screenWidth] / 16;
}

- (CGFloat)fieldView:(FieldView *)fieldView heightForSection:(NSInteger)section {
    return 112.f;
}

- (FieldItemView *)fieldView:(FieldView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player = [self playerForIndexPath:indexPath];
    BattleFieldPlayerView *playerView = [[BattleFieldPlayerView alloc] initWithPlayer:player];

    return playerView;
}

- (void)fieldView:(FieldView *)fieldView didSelectFieldItemView:(FieldItemView *)fieldItemView {
    BattleFieldPlayerView *gameFieldPlayerView = (BattleFieldPlayerView *)fieldItemView;
    self.lastFieldItemView = gameFieldPlayerView;
    SelectPlayerViewController *selectPlayerViewController = [[SelectPlayerViewController alloc] initWithViewModel:self.viewModel positionType:gameFieldPlayerView.player.position lastTeamOffset:self.lastTeamSelectPlayerOffset positionPlayer:gameFieldPlayerView.player];
    selectPlayerViewController.delegate = self;
    [self.navigationController pushViewController:selectPlayerViewController animated:YES];
}

- (void)fieldView:(FieldView *)fieldView didSelectCaptainFieldItemView:(FieldItemView *)fieldItemView {
    [self captainSelected:((BattleFieldPlayerView *)fieldItemView).player];
}

#pragma mark - NSIndexPath helpers
- (NSArray *)sectionArray:(NSInteger)section {
    return self.viewModel.lineup.lineup[(NSUInteger)section];
}

- (Player *)playerForIndexPath:(NSIndexPath *)indexPath {
    NSArray *section =  [self sectionArray:indexPath.section];
    Player *player = section[(NSUInteger)indexPath.row];
    return player;
}

#pragma mark - Select Player Delegate
- (BOOL)selectedPlayer:(Player *)player forTeam:(Team *)team offset:(NSUInteger)offset {
    NSIndexPath *indexPath = self.lastFieldItemView.indexPath;

    player.team = team;

    // Check for conditions replacing adding player
    BOOL lessPlayersAllowedForTeam = [self.viewModel lessPlayersAllowedForTeam:team];
    BOOL replacePlayerFromSameTeam = [self.lastFieldItemView.player.team.objectId isEqualToString:team.objectId];

    if (!lessPlayersAllowedForTeam && !replacePlayerFromSameTeam) {
        self.mixpanelNumberOfMaxPerTeamErrors++;
        return NO;
    }

    // Replace player on position with new player
    [self.viewModel.lineup setLineupPlayerForIndexPath:indexPath player:player];

    // Remove captain if not in lineup
    [self removeCaptainIfNotInLineup];

    // Set new player in fieldView
    [self.lastFieldItemView setPlayer:player];
    [self.navigationController popViewControllerAnimated:YES];
    [self setSubmitButtonColor];
    
    self.lastTeamSelectPlayerOffset = offset;

    self.mixpanelNumberOfPicks++;

    return YES;
}

#pragma mark - Button events

- (void)onTapUser:(UIButton *)button {
    NSLog(@"<User> clicked");
    if (button != nil) {
        button.backgroundColor = [UIColor whiteColor];
    }
}

- (void)buttonHighlight:(UIButton *)button {
    button.backgroundColor = [UIColor lightBorderColor];
}

- (void)cancelHighlight:(UIButton *)button {
    button.backgroundColor = [UIColor whiteColor];
}

- (void)captainButtonAction:(CaptainButton *)captainButton {
    ChooseCaptainTableViewController *captainTableViewController = [[ChooseCaptainTableViewController alloc] initWithPlayers:self.viewModel.lineup.players];
    captainTableViewController.delegate = self;
    [self.navigationController pushViewController:captainTableViewController animated:YES];
}

- (BOOL)hasEnoughCredits {
    NSInteger credits = [[Wallet instance].credits integerValue];
    NSInteger entryFee = [self.viewModel.model.entry integerValue];

//    return credits >= entryFee;
    // MARK-TEST
    return YES;
}

- (void)showInsufficientFundsAlert {
    NSInteger credits = [[Wallet instance].credits integerValue];
    NSInteger entryFee = [self.viewModel.model.entry integerValue];

    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
    alert.backgroundType = Transparent;
    [alert addButton:@"Visit Shop" actionBlock:^{
        self.mixpanelLineupShopShown = YES;
        ShopViewController *shopViewController = [[ShopViewController alloc] init];
        DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:shopViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
    [alert showError:@"Not enough credits" subTitle:[NSString stringWithFormat:@"You need %li more credits to join this battle", (long)(entryFee - credits)] closeButtonTitle:@"Cancel" duration:0];
}

- (void)showUserNameAlertAction {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
    alert.backgroundType = Transparent;
    UITextField *textField = [alert addTextField:@"Your name"];
    [alert addButton:@"Send" actionBlock:^{
        if (textField.text && ![textField.text isEqualToString:@""]) {
            self.viewModel.userName = textField.text;
            [self submitTeam];
        } else {
            [self showUserNameAlertAction];
        }
    }];
    [alert showNotice:self title:@"Enter your name" subTitle:@"Will be shown to other users" closeButtonTitle:@"Cancel" duration:0];
}

// Actions
- (void)submitTeam {
    
    /* TODO: - remove after test
    NSDictionary *dic = @{@"_id": @"2323"};
    BattleViewModel *viewModel = [[BattleViewModel alloc] initWithModelDictionary:dic];
    BattleViewController *gameView = [[BattleViewController alloc] initWithViewModel:viewModel];
    [self presentViewController:gameView animated:YES completion:nil];
    
    // */
    
    //* TODO: - uncomment after test
     
    @weakify(self);

    // Verification
    if (!self.viewModel.lineup.valid) {
        [self showLineupAlert];
        return;
    } else if (!self.viewModel.lineup.captain) {
        [self showCaptainAlert];
        return;
    }

    // Check if enough coins
    if (![self hasEnoughCredits]) {
        [self showInsufficientFundsAlert];
        return;
    }

    // Ask for user name if not set
    if (![Identification hasSetUserName] && !self.viewModel.userName) {
        [self showUserNameAlertAction];
        return;
    }

    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    JGProgressHUD *hud = [SpinnerHelper JGProgressHUDSpinnerInView:self.view text:@"Submitting"];

    // Determine where to send invite
    RACSignal *joinSignal = self.viewModel.battle && self.viewModel.battle.invitedBy ? [self.viewModel joinInvitedBattle] : [self.viewModel joinBattle];

    @weakify(hud);
    [joinSignal subscribeNext:^(id x) {
        @strongify(self);
        [self lineupTrackingWithResult:@"joined"];
//        [self.delegate createTeamViewController:self doneWithReturnObj:x];
        [self.delegate createTeamViewController:self doneWithReturnObj:x withPlayers:self.viewModel.lineup.players];
        [Utils hideConnectionErrorNotification];

        [[Mixpanel sharedInstance].people increment:@"battlesJoined" by:@(1)];

#if !TARGET_IPHONE_SIMULATOR
        [Answers logCustomEventWithName:@"Battle Joined" customAttributes:@{
            @"battleId": self.viewModel.model.objectId ?: [NSNull null],
            @"battleName": self.viewModel.model.name ?: [NSNull null],
            @"inviteOnly": @(self.viewModel.inviteOnly),
            @"startDate": self.viewModel.model.startDate ? [Date dateToISO8601String:self.viewModel.model.startDate] : [NSNull null]
        }];
#endif

        if (![Identification hasSetUserName]) [Identification setUserNameAsSet];
    } error:^(NSError *error) {
        @strongify(hud);
        [hud dismissAnimated:YES];
        [Utils showConnectionErrorNotification];
        CLS_LOG(@"error: %@", error);

        NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];

        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"Error submitting lineup" message:errorResponse];
        [alert bk_addButtonWithTitle:@"Ok" handler:^{}];
        [alert show];
    }];
     
     // */
}

- (void)updateLineupAction {
    if (!self.viewModel.lineup.valid) {
        [self showLineupAlert];
        return;
    } else if (!self.viewModel.lineup.captain) {
        [self showCaptainAlert];
        return;
    }

    JGProgressHUD *hud = [SpinnerHelper JGProgressHUDSpinnerInView:self.view text:@"Updating"];

    @weakify(self, hud);
    [[self.viewModel updateBattleSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self lineupTrackingWithResult:@"updated"];
        [self.delegate createTeamViewController:self doneWithReturnObj:[Lineup applyFieldIndexToLineup:self.viewModel.lineup.lineupFlatten] withPlayers:self.viewModel.lineup.players];
        [Utils hideConnectionErrorNotification];
    } error:^(NSError *error) {
        @strongify(hud);
        [Utils showConnectionErrorNotification];
        [hud dismissAnimated:YES];
        CLS_LOG(@"error: %@", error);
    }];
}

- (void)cancelAction {
    [self lineupTrackingWithResult:@"cancelled"];

    if (self.viewModel.lineup.players.count > 0) {
        NSString *titleText = @"Do you want to cancel?";
        NSString *messageText = @"If you cancel you will lose your lineup";
        NSString *actionButtonText = @"Yes, cancel";
        NSString *closeButtonText = @"Stay";

        if (self.isEditingExistingLineup) {
            messageText = @"If you cancel, you will lose any changes you made to your lineup";
        }

        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:titleText message:messageText];
        [alert bk_addButtonWithTitle:actionButtonText handler:^{
            [self.delegate createTeamViewController:self doneWithReturnObj:nil withPlayers:nil];
        }];
        [alert bk_addButtonWithTitle:closeButtonText handler:^{}];
        [alert show];
    } else {
        [self.delegate createTeamViewController:self doneWithReturnObj:nil withPlayers:nil];
    }
}

- (void)captainSelected:(Player *)player {
//    [self.captainButton setPlayer:player];
    [self.viewModel.lineup setCaptain:player];
    [self.fieldView reloadData];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showInfo {
    HelpViewController *battleInfoViewController = [[HelpViewController alloc] initForCreateLineup];
    UINavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:battleInfoViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Action helpers
- (void)showLineupAlert {
    self.mixpanelLineupInvalidShown = YES;
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = FadeIn;
    [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
    [alert showNotice:self title:@"Not enough players" subTitle:@"All 8 players must be selected before submitting" closeButtonTitle:@"Got it" duration:0];
}

- (void)showCaptainAlert {
    self.mixpanelCaptainErrorShown = YES;
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = FadeIn;
    [alert showNotice:self title:@"You need to set Captain" subTitle:@"You can set your captain below your lineup" closeButtonTitle:@"Got it" duration:0];
}

- (void)removeCaptainIfNotInLineup {
    if (![self.viewModel.lineup isCaptainInLineup]) {
        self.viewModel.lineup.captain = nil;
//        [self.captainButton setPlayer:nil];
    }
}

- (void)checkIfBattleHasStarted {
    if (self.viewModel.model.startDate && [self.viewModel.model.startDate isInThePast]) {
        // Stop timer
        [self invalidateTimer];
        self.mixpanelTimesUp = YES;
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
        alert.backgroundType = Shadow;

        @weakify(self);
        [alert addButton:@"Okay" actionBlock:^{
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
            [self lineupTrackingWithResult:@"cancelled"];
        }];
        [alert showError:@"Time's up" subTitle:@"Unfortunaly the battle has started and joining is no longer possible" closeButtonTitle:nil duration:0];

    }
}

#pragma mark - Table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return [MatchesHelper heightForSection:section competitions:self.viewModel.competitions];
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *league = self.viewModel.competitions[(NSUInteger) section];
    SimpleTableSectionView *sectionView = [[SimpleTableSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.f)];
    [sectionView setSectionDataWithTitle:league[@"name"] flagCode:league[@"country"] countryCodeFormat:CountryCodeFormatFifa];
    sectionView.backgroundColor = [UIColor whiteColor];
    
//    if ([MatchesHelper shouldDisplaySectionWithHeaderTextWithCompetitions:self.viewModel.competitions section:section]) {
//        NSString *headerText = [[YLMoment momentWithDate:league[@"date"]] format:@"EEEE d LLLL"];
//
//    }

    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.viewModel.competitions[(NSUInteger)indexPath.section][@"matches"][(NSUInteger) indexPath.row];
    MatchCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell" forIndexPath:indexPath];

    [cell setupMatch:match];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.competitions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.viewModel.competitions[(NSUInteger)section][@"matches"]).count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.viewModel.competitions[(NSUInteger)indexPath.section][@"matches"][(NSUInteger) indexPath.row];
    CLS_LOG(@"Match %@", match.objectId);

    DefaultSubscriptionViewController *subscriptionViewControllerWithMatchPageViewController = [[[MatchPageViewController alloc] initWithMatch:match] wrapInSubscriptionViewController];
    [self.navigationController pushViewController:subscriptionViewControllerWithMatchPageViewController animated:YES];
}

#pragma mark - Mixpanel

- (void)lineupTrackingWithResult:(NSString *)result {
    NSInteger playerPicks = self.mixpanelNumberOfPicks;
    NSInteger lineupCount = self.viewModel.lineup.lineupFlatten.count;
    NSInteger picksPerPlayer = playerPicks / lineupCount;
    NSTimeInterval secondsBeforeStart = [[NSDate date] timeIntervalSinceDate:self.viewModel.model.startDate];

    [[Mixpanel sharedInstance] track:@"Create lineup event" properties:@{
        @"inviteOnly": @(self.viewModel.inviteOnly),
        @"result": result ?: @"",
        @"editLineup": @(self.isEditingExistingLineup),
        @"battleTemplateId": self.viewModel.model.objectId ?: @"",
        @"timeBeforeStartInSec": @(ceil(secondsBeforeStart)),
        @"lineupCount": @(lineupCount),
        @"picksPerPlayer": @(picksPerPlayer),
        @"playerPicks": @(playerPicks),
        @"maxPerTeamErrors": @(self.mixpanelNumberOfMaxPerTeamErrors),
        @"teamsInLineup": @([self.viewModel.lineup numberOfTeams]),
        @"errorCaptainShown": @(self.mixpanelCaptainErrorShown),
        @"errorLineupShown": @(self.mixpanelLineupInvalidShown),
        @"captainPosition": self.viewModel.lineup.captain.position ?: @"",
        @"shopShown": @(self.mixpanelLineupShopShown),
        @"timesUpShown": @(self.mixpanelTimesUp)
    }];
}

#pragma mark - Helpers
- (void)invalidateTimer {
    [self.endOfBattleIntervalTimer invalidate];
    self.endOfBattleIntervalTimer = nil;
}

@end
