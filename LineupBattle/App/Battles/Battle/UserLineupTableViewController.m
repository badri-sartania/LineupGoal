//
// Created by Anders Borre Hansen on 29/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "UserLineupTableViewController.h"
#import "Lineup.h"
#import "Identification.h"
#import "PlayerViewController.h"
#import "Utils.h"
#import "HelpViewController.h"
#import "PointsCalculation.h"
#import "PlayerPointsTableViewCell.h"
#import "DefaultNavigationController.h"
#import "NSDate+Lineupbattle.h"
#import "SimpleTableSectionView.h"
#import "PlayerSectionView.h"
#import "PointsView.h"
#import "ProfileImageWithBadgeView.h"
#import "FlagView.h"
#import "ProfileTableViewController.h"
#import "NSNumber+OrdinalSuffix.h"
#import "Date.h"
#import "HexColors.h"
#import "NSArray+BlocksKit.h"
#import "UIColor+LineupBattle.h"


@interface UserLineupTableViewController ()
@property(nonatomic, strong) NSArray *lineup;
@property(nonatomic, strong) User *user;
@property(nonatomic, strong) NSString *myUserId;
@property(nonatomic, strong) NSArray *playerPoints;
@property(nonatomic, strong) BattleViewModel *viewModel;
@property(nonatomic, strong) FieldView *fieldView;
@property(nonatomic, strong) RACDisposable *intervalDisposer;
@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) UIView *statusView;
@property(nonatomic, strong) UILabel *lbStatus;
@end

static NSInteger navigationBarHeight = 64;
static NSInteger editButtonHeight = 67;

@implementation UserLineupTableViewController

- (instancetype)initUser:(User *)user viewModel:(BattleViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.user = user;
        self.myUserId = [Identification userId];

        self.viewModel = viewModel;
        NSArray *pointsForPlayers = [self pointsForPlayers];
        self.playerPoints  = [pointsForPlayers sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *point1, NSDictionary *point2) {
            if (!point1[@"ts"]) return NSOrderedDescending;
            if (!point2[@"ts"]) return NSOrderedAscending;

            return [[Date stringToDate:point2[@"ts"]] compare:[Date stringToDate:point1[@"ts"]]];
        }];
        self.lineup = [self formatLineup];
        self.title = @"User lineup";

        if ([self.user.current boolValue]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editLineupAction)];
            [self disableEditButtonIfNeeded];
        }

        [self.tableView registerClass:[PlayerPointsTableViewCell class] forCellReuseIdentifier:@"pointsCell"];
    }

    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.intervalDisposer dispose];
    self.intervalDisposer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpIntervalCheckerIfNeeded];
    [self disableEditButtonIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupTableView];

    [self.fieldView reloadData];
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
    
    UILabel *navTitle = [[UILabel alloc] init];
    [navTitle setText:@"LINEUP"];
    navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UIView *)setupProfileView {
    self.statusView = [[UIView alloc] init];
    [self.view addSubview:self.statusView];
    
    self.lbStatus = [[UILabel alloc] init];
    [self.lbStatus sizeToFit];
    [self.statusView addSubview:self.lbStatus];
    
    if ([self userIsMe] && ![self isGameStarted]) {
        
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationBar.mas_bottom);
            make.left.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@30);
        }];
        [self.statusView setBackgroundColor:[UIColor hx_colorWithHexString:@"#F1C40F"]];

        [self.lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.statusView);
            make.centerX.equalTo(self.statusView);
        }];
        self.lbStatus.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        self.lbStatus.text = @"You can edit lineup until game starts";
        self.lbStatus.textColor = [UIColor whiteColor];
    } else {
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationBar.mas_bottom);
            make.left.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@0);
        }];
    }
    
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
    profileImageWithBadgeView.delegate = self;
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

- (void)setupTableView {
    
    UIView *profileView = [self setupProfileView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, navigationBarHeight, [Utils screenWidth], 510.f)];
    UIView *bottomView = [self setupBottomView];
    
    // Field Image
    UIImageView *fieldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"halffield"]];
    fieldImageView.clipsToBounds = YES;
//    [fieldImageView setContentMode:UIViewContentModeScaleToFill];
    [headerView addSubview:fieldImageView];
    [fieldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.centerX.equalTo(headerView);
        make.height.equalTo(@468);
        make.width.equalTo(@([Utils screenWidth]-4));
    }];
    
    // Place
//    DefaultLabel *placeLabel = [DefaultLabel init];
//    NSString *placeText = [NSString stringWithFormat:@"Place %@", [@([self.viewModel leaderboardPositionOfUser:self.user]) ordinalNumberSuffixString]];
//    NSMutableAttributedString *placeAttriText = [[NSMutableAttributedString alloc] initWithString:placeText];
//    [placeAttriText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(6, placeText.length-6)];
//    placeLabel.attributedText = placeAttriText;
//
    // Formation
//    DefaultLabel *formationLabel = [DefaultLabel init];
//    NSString *formationText = [NSString stringWithFormat:@"Formation %@", [self.viewModel formationString]];
//    NSMutableAttributedString *formationAttriText = [[NSMutableAttributedString alloc] initWithString:formationText];
//    [formationAttriText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(9, formationText.length-9)];
//    formationLabel.attributedText = formationAttriText;
//
//    [headerView addSubview:placeLabel];
//    [headerView addSubview:formationLabel];
//
//    [@[placeLabel, formationLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(fieldImageView.mas_top).offset(-3);
//    }];
//    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerView).offset(5);
//    }];
//    [formationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(headerView).offset(-5);
//    }];
    
    // Field View
    self.fieldView = [[FieldView alloc] init];
    self.fieldView.delegate = self;
    self.fieldView.dataSource = self;
    
    [headerView addSubview:self.fieldView];
    
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(20.f);
        make.centerX.equalTo(headerView);
        make.width.equalTo(headerView);
        make.height.equalTo(@(468));
    }];
    
    if (self.lineup.count == 0) {
        DefaultLabel *text = [DefaultLabel initWithText:@"This lineup will be available when the battle starts"];
        text.textColor = [UIColor hx_colorWithHexString:@"9cdf73"];
        text.font = [UIFont systemFontOfSize:20];
        text.numberOfLines = 0;
        text.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:text];
        
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.fieldView);
            make.size.equalTo(@250);
        }];
    }
    
    // Total points
    PointsView *pointsView = [[PointsView alloc] initWithPoints:[PointsCalculation totalValueOfPoints:self.playerPoints]];
    pointsView.pointsLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    pointsView.pointsDescriptionLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    DefaultLabel *pointsLabel = [DefaultLabel initWithText:@"Total"];
    pointsLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    
    [headerView addSubview:pointsView];
    [headerView addSubview:pointsLabel];
    
    [pointsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView).offset(20);
        make.top.equalTo(fieldImageView.mas_bottom).offset(20);
    }];
    [pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pointsView.mas_left).offset(-5);
        make.centerY.equalTo(pointsView);
    }];
    
    NSUInteger height = [Utils screenHeight] - navigationBarHeight - profileView.frame.size.height;
    if ([self userIsMe]) {
        height = height - editButtonHeight;
    }
    self.tableView = [[UITableView alloc] init]; // 50 is tabbar height
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(profileView.mas_bottom).offset(4);
        make.left.equalTo(self.view);
        make.width.equalTo(@([Utils screenWidth]));
        if (bottomView != nil) {
            make.bottom.equalTo(bottomView.mas_top);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (UIView *)setupBottomView {
    if (![self userIsMe] || [self isGameStarted]) return nil;
    
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:[UIColor hx_colorWithHexString:@"34495e"]];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(editButtonHeight));
    }];
    
    UIButton *editButton = [[UIButton alloc] init];
    [editButton setTitle:@"EDIT TEAM" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor hx_colorWithHexString:@"2ecc71"] forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 18];
    [editButton addTarget:self
                   action:@selector(editTeam)
         forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.centerY.equalTo(bottomView);
    }];
    
    return bottomView;
}


#pragma mark - Button actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showInfo {
    HelpViewController *battleInfoViewController = [[HelpViewController alloc] initForCreateLineup];
    UINavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:battleInfoViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)editTeam {
    NSLog(@"<EDIT TEAM> pressed");
    CreateLineupViewController *createLineupViewController = [[CreateLineupViewController alloc] initEditBattleWithDelegate:self battle:self.viewModel.model];
    createLineupViewController.user = self.user;
//    DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:createLineupViewController];
//    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    [self.navigationController pushViewController:createLineupViewController animated:YES];
}

- (void)onTapUser:(UIButton *)button {
    NSLog(@"<User> clicked");
    if (button != nil) {
        button.backgroundColor = [UIColor whiteColor];
    }
    ProfileTableViewController *profileTableViewController = [[ProfileTableViewController alloc] initWithProfileId:self.user.objectId];
    UINavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:profileTableViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)buttonHighlight:(UIButton *)button {
    button.backgroundColor = [UIColor lightBorderColor];
}

- (void)cancelHighlight:(UIButton *)button {
    button.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Edit state methods

- (BOOL)isGameStarted {
    return [self.viewModel.model.template.startDate isInThePast];
}

- (void)disableEditButtonIfNeeded {
    if ([self isGameStarted]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)setUpIntervalCheckerIfNeeded {
    if ([self.user.current boolValue] && [self.viewModel.model.template.startDate isInTheFuture]) {
        @weakify(self);
        if (self.intervalDisposer) return;
        self.intervalDisposer = [[RACSignal interval:10 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            @strongify(self);
            [self disableEditButtonIfNeeded];
        }];
    }
}

#pragma mark - Field Delegate
- (FieldItemView *)fieldView:(FieldView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player = [self playerForIndexPath:indexPath];
    NSInteger points = [PointsCalculation pointsForPlayer:player points:self.playerPoints];
    BattleFieldPlayerView *playerView = [[BattleFieldPlayerView alloc] initWithPlayer:player points:points];
    [playerView showCaptainBadge:[player.captain boolValue]];
    playerView.delegate = nil;
    
//    BattleFieldPlayerView *playerView = [[BattleFieldPlayerView alloc] initWithPlayer:player];
    return playerView;
}

- (void)fieldView:(FieldView *)fieldView didSelectFieldItemView:(FieldItemView *)fieldItemView {
    BattleFieldPlayerView *gameFieldPlayerView = (BattleFieldPlayerView *)fieldItemView;
    Player *player = gameFieldPlayerView.player;
    gameFieldPlayerView.delegate = nil;
    
    // Load player view
    PlayerViewController *playerViewController = [PlayerViewController initWithPlayer:player];
    [[Mixpanel sharedInstance] track:@"Player" properties:@{
            @"id": player.objectId ?: [NSNull null],
            @"name": player.name ?: [NSNull null],
            @"from": @"user-lineup"
    }];
    [self.navigationController pushViewController:playerViewController animated:YES];
}

- (void)fieldView:(FieldView *)fieldView didSelectCaptainFieldItemView:(FieldItemView *)fieldItemView {
    [self fieldView:fieldView didSelectFieldItemView:fieldItemView];
}

- (NSInteger)numberOfSectionsInFieldView:(FieldView *)fieldView {
    return self.lineup.count;
}

- (NSInteger)numberOfItemsForSectionInFieldView:(FieldView *)fieldView section:(NSInteger)section {
    return [self sectionArray:section].count;
}

- (BOOL)fieldViewShouldBeReversed:(FieldView *)fieldView {
    return YES;
}

- (CGFloat)fieldView:(FieldView *)fieldView marginForSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)fieldView:(FieldView *)fieldView marginBetweenItemsInSection:(NSInteger)section {
    return [Utils screenWidth] / 11;
}

- (CGFloat)fieldView:(FieldView *)fieldView heightForSection:(NSInteger)section {
    return 100.f;
}

#pragma mark - NSIndexPath helpers
- (NSArray *)sectionArray:(NSInteger)section {
    return ((NSArray *)self.lineup[(NSUInteger)section]);
}

- (Player *)playerForIndexPath:(NSIndexPath *)indexPath {
    NSArray *section =  [self sectionArray:indexPath.section];
    Player *player = ((Player *)section[(NSUInteger)indexPath.row]);
    return player;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlayerSectionView *sectionView = [[PlayerSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    [sectionView setSectionTitle:@"Player Events"];
    [sectionView setSectionLastText:@"Points"];

    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playerPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *point = self.playerPoints[(NSUInteger)indexPath.row];
    PlayerPointsTableViewCell *cell = (PlayerPointsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"pointsCell" forIndexPath:indexPath];

    NSString *timeString = point[@"ts"] ? [[Date stringToYLMoment:point[@"ts"]] fromMoment:[YLMoment now]] : @"";

    [cell setPoint:point badge:[point[@"captain"] boolValue] timeString:timeString];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions
- (void)editLineupAction {
    CreateLineupViewController *createLineupViewController = [[CreateLineupViewController alloc] initEditBattleWithDelegate:self battle:self.viewModel.model];
    DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:createLineupViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - CreateLineupViewController
- (void)createTeamViewController:(CreateLineupViewController *)controller doneWithReturnObj:(id)obj withPlayers:(id)players {
    // We get changed lineup back from update lineup and replaces it in model
    // under the assumption that the same lineup can be fetch on the server
    if ([players isKindOfClass:[NSArray class]]) {
        // Replace players with new players
        self.user.players = players;

        // Update points cache with player changes
        self.playerPoints = [self pointsForPlayers];

        // Set the new lineup
        self.lineup = [self formatLineup];
    }

//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

    [[self.viewModel refreshDataSignal] subscribeNext:^(id x) {}];

    // Update the UI
    [self.fieldView reloadData];
    [self.tableView reloadData];
}

#pragma mark - Helpers
- (NSArray *)pointsForPlayers {
    return [PointsCalculation pointsArrayForPlayersWithCaptainMultiplier:self.user.players points:self.viewModel.model.points];
}

- (NSArray *)formatLineup {
    NSArray *players = self.user.players;

    __block NSInteger i = 0;
    [players bk_each:^(Player *player) {
        player.fieldIndex = @(i++);
    }];

    if (self.viewModel.model.template.formation != nil) {
        return [Lineup withPlayers:players formation:self.viewModel.model.template.formation];
    } else {
        return [Lineup withPlayers:players formation:@[@2,@3,@2]];
    }
}

- (void)profileButtonPressed:(UIButton *)profileButton {
//    ProfileTableViewController *profileTableViewController = [[ProfileTableViewController alloc] initWithProfileId:self.user.objectId];
//    [self.navigationController presentViewController:profileTableViewController animated:YES completion:nil];
    [self onTapUser:nil];
}

- (BOOL)userIsMe {
    return [self.user.objectId isEqualToString:self.myUserId];
}

@end
