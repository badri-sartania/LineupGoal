//
//  ProfileTableViewController.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 10/04/15.
//  Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <JGProgressHUD/JGProgressHUD.h>
#import <YLMoment/YLMoment.h>
#import "ProfileTableViewController.h"
#import "Utils.h"
#import "DefaultImageView.h"
#import "DefaultLabel.h"
#import "PlayerSectionView.h"
#import "HTTP.h"
#import "User.h"
#import "BattleViewController.h"
#import "ImageViewWithBadge.h"
#import "FlagView.h"
#import "XPBarView.h"
#import "StyleKitView.h"
#import "StyleKit.h"
#import "ProfileBattleViewCell.h"
#import "EditProfileViewController.h"
#import "Identification.h"
#import "NSArray+Reverse.h"
#import "SpinnerHelper.h"
#import "Mixpanel.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"
#import "HTTP+RAC.h"
#import "PointsView.h"
#import "CoinView.h"

@interface ProfileTableViewController ()
@property(nonatomic, strong) NSArray *battles;
@property(nonatomic, strong) NSMutableArray *battlesByDate;
@property(nonatomic, copy) NSString *profileId;
@property(nonatomic, strong) User *user;
@property(nonatomic, strong) NSString *myUserId;
@property(nonatomic, strong) UIView *navigationBar;
@end

static NSInteger navigationBarHeight = 64;
static NSInteger profilePhotoSize = 100.0f;

@implementation ProfileTableViewController {
    ImageViewWithBadge *_profileImageView;
    DefaultLabel *_profileNameLabel;
    FlagView *_flagView;
    /*
     * Old UI components *
     
    DefaultLabel *_xpLevelLabel;
    PointsView *_xpPointsView;
    XPBarView *_xpBarView;
    DefaultLabel *_xpExplainLabel;
     
     */
    JGProgressHUD *_hud;
    DefaultLabel *_bestLineupLabel;
    DefaultLabel *_bestMonthLabel;
    CoinView *_bragTotalWinLabel;
    
}

- (instancetype)initWithProfileId:(NSString *)profileId {
    self = [super init];
    if (self) {
        if ([profileId isEqualToString:[Identification userId]]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editProfile)];
        }
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.title = @"Profile";
        self.profileId = profileId;
        self.myUserId = [Identification userId];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];

    UIView *headerView = [self setupProfileHeaderView];
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 100.f)];
    dummyView.backgroundColor = [UIColor primaryColor];
    [self.view addSubview:dummyView];
    [dummyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(-10);
        make.height.equalTo(@300);
    }];
    // Table View
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight, [Utils screenWidth], [Utils screenHeight] - navigationBarHeight)]; // 50 is tabbar height
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[ProfileBattleViewCell class] forCellReuseIdentifier:@"activeBattleViewCell"];

    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.refreshControl.backgroundColor = [UIColor primaryColor];
    [self.tableView.refreshControl addTarget:self
                            action:@selector(fetchData)
                  forControlEvents:UIControlEventValueChanged];

    _hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];
    self.tableView.layer.zPosition = 1;
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.top.equalTo(self.navigationBar.mas_bottom);
//        make.bottom.equalTo(self.view);
//    }];
    [self.view addSubview:self.tableView];
}

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
    [navTitle setText:@"PROFILE"];
    navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
    }];
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navButton setImage:[UIImage imageNamed:@"ic_arrow_down"]
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
    
    if ([self.myUserId isEqualToString:self.profileId]) {
        // User is me??
        UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
        [navRightButton setImage:[UIImage imageNamed:@"ic_settings"]
                        forState:UIControlStateNormal];
        [navRightButton setContentMode:UIViewContentModeCenter];
        [navRightButton addTarget:self
                           action:@selector(editProfile)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:navRightButton];
        [navRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navigationBar);
            make.top.equalTo(self.navigationBar).offset(20);
            make.bottom.equalTo(self.navigationBar);
            make.width.equalTo(@54);
        }];
    }
}

- (UIView *) setupProfileHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 300.f)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    // Profile background
    UIImageView *profileBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_back"]];
    [headerView addSubview:profileBg];
    
    // Profile Image
    _profileImageView = [[ImageViewWithBadge alloc] initWithBadgeScale:0.0f];
//    [_profileImageView setBadgeText:@"1"];
    [_profileImageView.imageView circleWithBorder:[UIColor whiteColor] diameter:profilePhotoSize borderWidth:4.0f];
    [headerView addSubview:_profileImageView];
    
    // Name
    _profileNameLabel = [DefaultLabel initWithText:@"Anonymous"];
    _profileNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0f];
    [_profileNameLabel setTextColor:[UIColor primaryColor]];
    [headerView addSubview:_profileNameLabel];
    
    // Flag
    _flagView = [[FlagView alloc] initWithCountryCode:nil countryCodeFormat:CountryCodeFormatISO31661Alpha2];
    _flagView.countryLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    [_flagView.countryLabel setTextColor:[UIColor secondaryTextColor]];
    [headerView addSubview:_flagView];
    
    // XPLevel label
//    _xpLevelLabel = [DefaultLabel init];
//    [headerView addSubview:_xpLevelLabel];
    
    // XPBar
//    _xpBarView = [[XPBarView alloc] init];
//    [headerView addSubview:_xpBarView];
    
    // XP Explain lab
//    _xpPointsView = [[PointsView alloc] initWithPoints:0];
//    [_xpPointsView setFontSize:12];
//    [headerView addSubview:_xpPointsView];
//    _xpExplainLabel = [DefaultLabel initWithSystemFontSize:12 color:[UIColor darkGrayTextColor]];
//    _xpExplainLabel.text = [NSString stringWithFormat:@"needed for level up"];
//    [headerView addSubview:_xpExplainLabel];
    
    // Setup views for Best Lineup
    UIView *lineupContainer = [[UIView alloc] init];
    [headerView addSubview:lineupContainer];
    
    UIView *rightBorderView = [[UIView alloc] init];
    rightBorderView.backgroundColor = [UIColor lightBorderColor];
    [lineupContainer addSubview:rightBorderView];
    
    _bestLineupLabel = [DefaultLabel initWithText:@""];
    _bestLineupLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0f];
    [_bestLineupLabel setTextColor:[UIColor primaryColor]];
    
    DefaultLabel *bestLineupDescription = [DefaultLabel initWithText:@"BEST LINEUP"];
    bestLineupDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    bestLineupDescription.textColor = [UIColor secondaryTextColor];
    [lineupContainer addSubview:_bestLineupLabel];
    [lineupContainer addSubview:bestLineupDescription];
    
    // Setup Best Lineup View constraints
    [lineupContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.width.equalTo(@([Utils screenWidth] * 0.33));
        make.height.equalTo(@44);
        make.top.equalTo(_flagView.mas_bottom).offset(30);
    }];
    [@[_bestLineupLabel, bestLineupDescription] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lineupContainer);
    }];
    [rightBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineupContainer);
        make.right.equalTo(lineupContainer);
        make.width.equalTo(@1.0f);
        make.height.equalTo(@44);
    }];
    [_bestLineupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineupContainer);
    }];
    [bestLineupDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineupContainer);
    }];
    // End to Setup Best Lineup View constraints
    
    // Setup views for Best Month
    UIView *monthContainer = [[UIView alloc] init];
    [headerView addSubview:monthContainer];
    
    _bestMonthLabel = [DefaultLabel initWithText:@""];
    _bestMonthLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0f];
    [_bestMonthLabel setTextColor:[UIColor primaryColor]];
    
    DefaultLabel *bestMonthDescription = [DefaultLabel initWithText:@"BEST MONTH"];
    bestMonthDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    bestMonthDescription.textColor = [UIColor secondaryTextColor];
    [monthContainer addSubview:_bestMonthLabel];
    [monthContainer addSubview:bestMonthDescription];
    
    // Setup Best Month View constraints
    [monthContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([Utils screenWidth] * 0.33));
        make.height.equalTo(@44);
        make.top.equalTo(_flagView.mas_bottom).offset(30);
    }];
    [@[_bestMonthLabel, bestMonthDescription] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(monthContainer);
    }];
    [_bestMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthContainer);
    }];
    [bestMonthDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(monthContainer);
    }];
    // End to Setup Best Month View constraints
    
    // Right Brag side
    UIView *boltContainer = [[UIView alloc] init];
    [headerView addSubview:boltContainer];
    
    UIView *leftBorderView = [[UIView alloc] init];
    leftBorderView.backgroundColor = [UIColor lightBorderColor];
    [boltContainer addSubview:leftBorderView];
    
    _bragTotalWinLabel = [[CoinView alloc] initWithBigCoins:0 direction:CoinDirectionLeft];
//    _bragTotalWinLabel.coinLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0f];
    
    DefaultLabel *blotWonDescription = [DefaultLabel initWithText:@"BOLTS WON"];
    blotWonDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    blotWonDescription.textColor = [UIColor secondaryTextColor];
    [boltContainer addSubview:_bragTotalWinLabel];
    [boltContainer addSubview:blotWonDescription];
    
    // Setup Bolt View constraints
    [boltContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView);
        make.width.equalTo(@([Utils screenWidth] * 0.33));
        make.height.equalTo(@44);
        make.top.equalTo(_flagView.mas_bottom).offset(30);
    }];
    [@[_bragTotalWinLabel, blotWonDescription] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(boltContainer);
    }];
    [leftBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boltContainer);
        make.left.equalTo(boltContainer);
        make.width.equalTo(@1.0f);
        make.height.equalTo(@44);
    }];
    [_bragTotalWinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boltContainer).offset(12);
    }];
    [blotWonDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(boltContainer);
    }];
    // End to Setup Bolt View constraints
    
#pragma mark - Layout
    [@[profileBg, _profileImageView, _profileNameLabel, _flagView, monthContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
    }];
    
    [profileBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.height.equalTo(@([Utils screenWidth] * 0.274));
    }];
    
    [_profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(34);
        make.size.equalTo(@(profilePhotoSize));
    }];
    
    [_profileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_profileImageView.mas_bottom).offset(8);
    }];
    
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_profileNameLabel.mas_bottom).offset(3);
        make.height.equalTo(@18);
    }];
    
    // Brag Labels
//    static NSInteger bragMarginXOffset = 10;
//    static NSInteger bragMarginYOffset = 20;
//    static NSInteger bragSubHeaderOffset = 6;
//
//    [@[_bragBiggestWinLabel, _bragTotalWinLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(bragImageView).offset(-bragMarginYOffset);
//        make.height.equalTo(@15);
//    }];
//
//    [bragSubHeaderLeft mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bragTotalWinLabel.mas_bottom).offset(bragSubHeaderOffset);
//    }];
//
//    [bragSubHeaderRight mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bragTotalWinLabel.mas_bottom).offset(bragSubHeaderOffset);
//    }];
//
//    [@[_bragBiggestWinLabel, bragSubHeaderLeft] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(bragImageView.mas_left).offset(-bragMarginXOffset);
//    }];
//
//    [@[_bragTotalWinLabel, bragSubHeaderRight] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bragImageView.mas_right).offset(bragMarginXOffset);
//    }];
    
    /////////////////////////////////////////////////////////
    
//    [_xpLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_flagView.mas_bottom).offset(20);
//    }];
//
//    [_xpBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_xpLevelLabel.mas_bottom).offset(10);
//        make.width.equalTo(@([Utils screenWidth] * 0.75));
//        make.height.equalTo(@10);
//    }];
//
//    [@[_xpPointsView, _xpExplainLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_xpBarView.mas_bottom).offset(5);
//    }];
//
//    [_xpPointsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@13);
//        make.centerX.equalTo(headerView).offset(-107/2);
//    }];
//
//    [_xpExplainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_xpPointsView.mas_right).offset(4);
//        make.centerY.equalTo(_xpPointsView);
//    }];
    
    // Brag Visual
//    [bragImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headerView).offset(-20);
//    }];
//
//    [fightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(bragImageView).offset(-20);
//        make.width.equalTo(@37);
//        make.height.equalTo(@33);
//    }];
    
    return headerView;
}

- (BOOL)addBattleToCalendar:(Battle *)battle {
    BOOL existMonth = NO;
    NSString *month = [[YLMoment momentWithDate:battle.template.startDate] format:@"MMMM yyyy"];
    for (NSDictionary *dict in self.battlesByDate) {
        if ([month isEqualToString:[dict objectForKey:@"month"]]) {
            existMonth = YES;
            NSMutableArray *battles = [dict objectForKey:@"battles"];
            [battles addObject:battle];
        }
    }
    
    if (!existMonth) {
        NSMutableArray *battles = [[NSMutableArray alloc] init];
        [battles addObject:battle];
        [self.battlesByDate addObject:@{
                                        @"month" : month,
                                        @"battles" : battles
                                        }];
    }
    
    return existMonth;
}

- (void)fetchData {
    @weakify(self);
    [[[HTTP instance] get:[NSString stringWithFormat:@"/users/%@", self.profileId]] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);

        self.user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dic error:NULL];

        [_hud dismissAnimated:YES];
        [self.tableView.refreshControl endRefreshing];

        self.battles = [MTLJSONAdapter modelsOfClass:[Battle class] fromJSONArray:dic[@"battles"] error:NULL];
        self.battlesByDate = [[NSMutableArray alloc] init];
        for (Battle *battle in self.battles) {
            [self addBattleToCalendar:battle];
        }
        self.battlesByDate = [self.battlesByDate sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary * obj2) {
            Battle *battle1 = [obj1 objectForKey:@"battles"][0];
            Battle *battle2 = [obj2 objectForKey:@"battles"][0];
            return [battle2.template.startDate compare:battle1.template.startDate];
        }];
        [self.tableView reloadData];

        // Level setup
//        NSString *formationText = [NSString stringWithFormat:@"LEVEL %@", self.user.level ?: @1];
//        NSMutableAttributedString *xpLevelAttriText = [[NSMutableAttributedString alloc] initWithString:formationText];
//        [xpLevelAttriText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(5, formationText.length - 5)];
//        _xpLevelLabel.attributedText = xpLevelAttriText;
//        [_xpBarView setProcentage:self.user.xpProgressionInPercentage];
//        [_xpPointsView setPoints:[self.user.xpToNextLevel integerValue]];

        // Profile info
        _profileImageView.badgeView.textLabel.text = [self.user.level stringValue];
        if (self.user.photoToken) [_profileImageView.imageView loadImageWithUrlString:[self.user profileImagePath:profilePhotoSize] placeholder:@"playerPlaceholder"];
        if (self.user.name) _profileNameLabel.text = self.user.name;
        if (self.user.country) [_flagView setISO2CountryCode:self.user.country];

        // Best Lineup Text update
        if ([self.user.bestLineup integerValue]) {
            [_bestLineupLabel setText:[NSString stringWithFormat:@"%d", [self.user.bestLineup intValue]]];
        } else {
            [_bestLineupLabel setText:@"0"];
        }
        
        // Best Month Text Update
        if ([self.user.bestMonth integerValue]) {
            [_bestMonthLabel setText:[NSString stringWithFormat:@"%d", [self.user.bestMonth intValue]]];
        } else {
            [_bestMonthLabel setText:@"0"];
        }
        
        // Bolts won coin update
        [_bragTotalWinLabel setCoins:[self.user.won integerValue] ?: 0];

        [Utils hideConnectionErrorNotification];
    } error:^(NSError *error) {
        @strongify(self);

        [Utils showConnectionErrorNotification];

        [_hud dismissAnimated:YES];
        [self.tableView.refreshControl endRefreshing];
    }];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) editProfile {
    [self.navigationController pushViewController:[[EditProfileViewController alloc] initWithUser:self.user] animated:YES];
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dict = self.battlesByDate[section];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    sectionView.backgroundColor = [UIColor whiteColor];
    DefaultLabel *label = [DefaultLabel initWithText:[dict objectForKey:@"month"]];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
    [label setTextColor:[UIColor hx_colorWithHexString:@"#BDC3C7"]];
    [sectionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView);
        make.centerY.equalTo(sectionView).offset(6);
    }];
    
//    PlayerSectionView *sectionView = [[PlayerSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    [sectionView setSectionTitle:[NSString stringWithFormat:@"Battles (%li)", (long)self.battles.count]];
//    [sectionView setSectionLastText:@"Winnings"];
//
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.battlesByDate.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.battlesByDate[section];
    NSMutableArray *battles = [dict objectForKey:@"battles"];
    return battles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.battlesByDate[indexPath.section];
    NSMutableArray *battles = [dict objectForKey:@"battles"];
    
    Battle *battle = battles[(NSUInteger)indexPath.row];
    ProfileBattleViewCell *cell = (ProfileBattleViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activeBattleViewCell" forIndexPath:indexPath];
    [cell setData:battle position:indexPath.row];
    [cell setHorizontalMargin:0];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.battlesByDate[indexPath.section];
    NSMutableArray *battles = [dict objectForKey:@"battles"];
    Battle *battle = battles[(NSUInteger)indexPath.row];
    BattleViewModel *viewModel = [[BattleViewModel alloc] initWithBattleId:battle.objectId];

    [[Mixpanel sharedInstance] track:@"Battle" properties:@{
        @"id": battle.objectId ?: [NSNull null],
        @"entry": battle.template.entry ?: [NSNull null],
        @"from": @"profile"
    }];

    BattleViewController *viewController = [[BattleViewController alloc] initWithViewModel:viewModel];

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
