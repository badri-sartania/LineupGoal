//
// Created by Anders Borre Hansen on 06/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "MatchPageViewController.h"
#import "EventMatchViewController.h"
#import "LineupMatchViewController.h"
#import "LeagueTableViewController.h"
#import "LeagueMatchViewController.h"
#import "UIColor+LineupBattle.h"
#import "TTScrollSlidingPagesController.h"
#import "Utils.h"

typedef NS_ENUM(NSInteger, MatchPageTab) {
    EventMatchPageTab,
    SquadMatchPageTab,
    StandMatchPageTab
};


@interface MatchPageViewController ()

@property (nonatomic, strong) Match *match;
@property (nonatomic, strong) EventMatchViewController *eventController;
@property (nonatomic, strong) LineupMatchViewController *fieldController;
@property (nonatomic, strong) LeagueMatchViewController *leagueController;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UILabel *navTitle;
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) UIImageView *activeCursor;
@property (nonatomic, strong) UIButton *btnEventTab;
@property (nonatomic, strong) UIButton *btnSquadTab;
@property (nonatomic, strong) UIButton *btnStandTab;
@property (nonatomic) MatchPageTab activeMatchPage;
@end

static NSInteger navigationBarHeight = 64;
static NSInteger tabBarHeight = 40;

@implementation MatchPageViewController

- (id)initWithMatch:(Match *)match {
    self = [super init];

    if (self) {
        self.viewModel = [[MatchViewModel alloc] initWithMatch:match];
        self.activeMatchPage = EventMatchPageTab;
    }

    return self;
}

- (DefaultSubscriptionViewController *)wrapInSubscriptionViewController {
    DefaultSubscriptionViewController *subscriptionViewController = [[DefaultSubscriptionViewController alloc] initWithViewModel:self.viewModel mainViewController:self];
    return subscriptionViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTabBar];
    
    [self.slider.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

    self.eventController =  [[EventMatchViewController alloc] initWithViewModel:self.viewModel];
    self.eventController.title = @"Events";
    self.fieldController =  [[LineupMatchViewController alloc] initWithViewModel:self.viewModel];
    self.fieldController.title = @"Lineup";
    self.leagueController = [[LeagueMatchViewController alloc] initWithViewModel:self.viewModel];
    self.leagueController.title = @"Table";

    [self addSubPageControllers:@[
        @{
            @"title": @"Events",
            @"controller" : self.eventController
        },
        @{
            @"title": @"Lineup",
            @"controller": self.fieldController
        },
        @{
            @"title": @"Table",
            @"controller": self.leagueController
        }
    ]];

    @weakify(self);
    [[[self.viewModel fetchMatchDetailsSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeCompleted:^{
        @strongify(self);
        [self reloadSubviews];
    }];
    self.slider.delegate = self;
}

- (void)reloadSubviews {
    // Update bell icon
    [((DefaultSubscriptionViewController *) self.parentViewController) updateBellIcon:self.viewModel.subscription];

    [self.eventController updateView];
    [self.fieldController updateView];
    [self.leagueController updateView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel disposeFetch];
    [self.viewModel disposeAutoFetch];
}

#pragma mark - Setup UIs
- (void)setupNavigationBar {
    // Setup navigation bar
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], navigationBarHeight)];
    [self.navigationBar setBackgroundColor:[UIColor primaryColor]];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(navigationBarHeight);
    }];
    
    self.navTitle = [[UILabel alloc] init];
    [self.navTitle setText:@"MATCH"];
    self.navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    self.navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:self.navTitle];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
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
        make.bottom.equalTo(self.navigationBar);
        make.width.equalTo(@54);
    }];
    
}

- (void)setupTabBar {
    self.tabBar = [[UIView alloc] init];
    [self.view addSubview:self.tabBar];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.right.equalTo(self.view);
        make.height.equalTo(@(tabBarHeight));
    }];
    self.tabBar.backgroundColor = [UIColor primaryColor];
    
    [self setupPageNavigation];
}

- (void)setupPageNavigation {
    
    // Initialize Tab buttons.
    self.btnEventTab = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    [self.btnEventTab setImage:[UIImage imageNamed:@"ic_match_event"] forState:UIControlStateNormal];
    [self.btnEventTab setContentMode:UIViewContentModeCenter];
    [self.btnEventTab addTarget:self action:@selector(onTabClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEventTab setTag:EventMatchPageTab];
    
    self.btnSquadTab = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 19)];
    [self.btnSquadTab setImage:[UIImage imageNamed:@"ic_match_squad"] forState:UIControlStateNormal];
    [self.btnSquadTab setContentMode:UIViewContentModeCenter];
    [self.btnSquadTab addTarget:self action:@selector(onTabClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSquadTab setTag:SquadMatchPageTab];
    
    self.btnStandTab = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 19)];
    [self.btnStandTab setImage:[UIImage imageNamed:@"ic_match_standing"] forState:UIControlStateNormal];
    [self.btnStandTab setContentMode:UIViewContentModeCenter];
    [self.btnStandTab addTarget:self action:@selector(onTabClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnStandTab setTag:StandMatchPageTab];
    
    self.activeCursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_match_tab_active"]];
    
    [self.tabBar addSubview:self.btnEventTab];
    [self.tabBar addSubview:self.btnSquadTab];
    [self.tabBar addSubview:self.btnStandTab];
    [self.tabBar addSubview:self.activeCursor];
    
    // Adjust constraints.
    [@[self.btnEventTab, self.btnSquadTab, self.btnStandTab] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tabBar);
    }];
    
    [self.btnSquadTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tabBar);
    }];
    
    [self.btnEventTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnSquadTab.mas_left).offset(-80);
    }];
    
    [self.btnStandTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnSquadTab.mas_right).offset(80);
    }];
    
    [self updateActivePageNavigation];
}

- (void)updateActivePageNavigation {
    CGRect activeTabFrame;
    self.btnEventTab.alpha = 0.5;
    self.btnSquadTab.alpha = 0.5;
    self.btnStandTab.alpha = 0.5;
    
    switch (self.activeMatchPage) {
        case SquadMatchPageTab:
            activeTabFrame = self.btnSquadTab.frame;
            self.btnSquadTab.alpha = 1.0;
            [self.navTitle setText:@"LINEUP"];
            break;
        case StandMatchPageTab:
            activeTabFrame = self.btnStandTab.frame;
            self.btnStandTab.alpha = 1.0;
            [self.navTitle setText:@"LEAGUE"];
            break;
        default:
            activeTabFrame = self.btnEventTab.frame;
            [self.navTitle setText:@"MATCH"];
            self.btnEventTab.alpha = 1.0;
            break;
    }
    
    [self.activeCursor setFrame:CGRectMake(([Utils screenWidth] / 2) + (self.activeMatchPage - 1) * (80 + activeTabFrame.size.width / 2 + self.btnSquadTab.frame.size.width / 2) - 5, tabBarHeight - 4, 10, 4)];
}

#pragma mark - Button actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTabClicked:(UIButton *)button {
    self.activeMatchPage = button.tag;
    [self.slider scrollToPage:self.activeMatchPage animated:YES];
    [self updateActivePageNavigation];
}

#pragma mark - Scroll delegate

-(void)didScrollToViewAtIndex:(NSUInteger)index {
    self.activeMatchPage = index;
    [self updateActivePageNavigation];
}
@end


