//
// Created by Anders Hansen on 12/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "Crashlytics.h"
#import "PlayerViewController.h"
#import "Utils.h"
#import "ImageViewWithBadge.h"
#import "DefaultLabel.h"
#import "StatView.h"
#import "DefaultTableView.h"
#import "SimpleTableSectionView.h"
#import "PlayerSectionView.h"
#import "TeamViewController.h"
#import "MatchPlayerTableCell.h"
#import "MatchPageViewController.h"
#import "Spinner.h"
#import "CareerPlayerViewCell.h"
#import "TrophiesView.h"
#import "Date.h"
#import "DefaultImageViewCell.h"
#import "SimpleLocale.h"
#import "FlagView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"

@interface PlayerViewController ()
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ImageViewWithBadge *profileImageView;
@property (nonatomic, strong) DefaultLabel *name;
@property (nonatomic, strong) FlagView *flagView;
@property (nonatomic, strong) DefaultLabel *born;
@property (nonatomic, strong) DefaultLabel *league;
@property (nonatomic, strong) StatView *cardsStat;
@property (nonatomic, strong) StatView *assistsStat;
@property (nonatomic, strong) StatView *goalsStat;
@property (nonatomic, strong) StatView *matchesStat;
@property (nonatomic, strong) DefaultTableView *matchTableView;
@property (nonatomic, strong) DefaultTableView *teamTableView;
@property (nonatomic, strong) DefaultTableView *careerTableView;
@property (nonatomic, strong) Spinner *spinner;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TrophiesView *trophies;
@property (nonatomic, strong) PlayerSectionView *trophiesHeader;
@property (nonatomic, strong) PlayerSectionView *careerHeader;
@property (nonatomic, strong) UIView *sizingView;
@property (nonatomic, strong) UIView *contentView;
@end

enum {
    CareerTable = 1,
    LastMatchesTable,
    CurrentTeamTable
};

static NSInteger navigationBarHeight = 64;
static NSInteger profilePhotoSize = 80.0f;

@implementation PlayerViewController

+ (PlayerViewController *)initWithPlayer:(Player *)player {
    return [[PlayerViewController alloc] initWithViewModel:[[PlayerViewModel alloc] initWithPlayer:player]];
}

- (id)initWithViewModel:(PlayerViewModel *)viewModel {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;
        self.title = @"Player";
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.teamTableView deselectCellSelection];
    [self.matchTableView deselectCellSelection];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.viewModel fetchPlayerDetails:^{
        [self.spinner stopAnimating];
        [self reloadData];
    }];
    
    // Setup UIs
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    // Content view is necessary for scrollView to work with autolayout
    // Look for [self updateContentHeight] for the second part to see this working
    self.contentView = UIView.new;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];

    UIView *superview = self.contentView;
    UIImageView *imgPlayerBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_player_back"]];

    [superview addSubview:imgPlayerBg];
    [superview addSubview:self.profileImageView];
    [superview addSubview:self.name];
    [superview addSubview:self.flagView];
    [superview addSubview:self.born];
    [superview addSubview:self.league];
    [superview addSubview:self.matchesStat];
    [superview addSubview:self.goalsStat];
    [superview addSubview:self.assistsStat];
    [superview addSubview:self.cardsStat];
    [superview addSubview:self.teamTableView];
    [superview addSubview:self.matchTableView];
    [superview addSubview:self.careerTableView];
    [superview addSubview:self.trophies];

    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor primaryColor];
    [self.refreshControl addTarget:self action:@selector(refreshPlayer:) forControlEvents:UIControlEventValueChanged];
    [superview addSubview:self.refreshControl];

    // Spinner
    self.spinner = [Spinner initWithSuperView:self.view];
    [self.spinner startAnimating];
    [self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.goalsStat.mas_bottom).offset(20);
        make.size.equalTo(@30);
    }];
    
    // Profile image background : imgPlayerBg
    [imgPlayerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview);
        make.left.equalTo(superview);
        make.right.equalTo(superview);
        make.height.equalTo(@([Utils screenWidth] * 0.15));
    }];

    // Profile image
    [self.profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.top.equalTo(superview).offset(0);
        make.size.equalTo(@(profilePhotoSize));
    }];

    // Player information
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(superview);
       make.top.equalTo(self.profileImageView.mas_bottom).offset(10);
       make.width.equalTo(@320);
    }];

    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(self.name.mas_bottom).offset(4);
        make.centerX.equalTo(superview);
    }];

    [self.born mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.top.equalTo(self.flagView.mas_bottom).offset(4);
    }];

    [self.league mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.top.equalTo(self.born.mas_bottom).offset(30);
    }];

    // Stats
    [self.matchesStat mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(superview).offset(-105);
    }];

    [self.goalsStat mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(superview).offset(-35);
    }];

    [self.assistsStat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview).offset(35);
    }];

    [self.cardsStat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview).offset(105);
    }];

    [@[self.matchesStat, self.goalsStat, self.assistsStat, self.cardsStat] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@74);
        make.top.equalTo(self.league.mas_bottom).offset(15);
    }];

    // Tables
    [self.teamTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.matchesStat.mas_bottom);
       make.left.equalTo(superview);
       make.width.equalTo(superview);
    }];

    [self.matchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teamTableView.mas_bottom).offset(30);
        make.left.equalTo(superview);
        make.width.equalTo(superview);
    }];

    [self.careerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.matchTableView.mas_bottom);
        make.left.equalTo(superview);
        make.width.equalTo(superview);
        make.height.equalTo(@20);
    }];

    // Trophies
    self.trophiesHeader = [[PlayerSectionView alloc] initWithFrame:CGRectNull];
    self.trophiesHeader.bottomBorder.frame = CGRectMake(16, 18.0f, self.view.frame.size.width, 0.5f);
    [self.view addSubview:self.trophiesHeader];

    [self.trophiesHeader setSectionTitle:@"Championship Trophies"];
    [self.trophiesHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.careerTableView.mas_bottom).offset(20);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@10);
    }];

    [self.trophies mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trophiesHeader.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
    }];

    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
    self.sizingView = UIView.new;
    [self.scrollView addSubview:self.sizingView];
    [self updateContentHeight];
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

#pragma mark - Actions
- (void)reloadData {
    Player *player = self.viewModel.player;

    if (!player) return;
    
    self.name.text = player.fullName ?: player.name;
    if (player.dob) {
        self.born.text = [NSString stringWithFormat:@"%@ (age %ld)", [[YLMoment momentWithDate:player.dob] format:@"dd MMM yyyy"], (long) [Date ageByDate:player.dob]];
    }

    [self.profileImageView setPosBadgeText:[player.position uppercaseString]
                                   bgColor:[UIColor hx_colorWithHexString:@"2C3E50"]
                          badgeBorderWidth:3.0f
                          badgeBorderColor:[UIColor whiteColor]
                                 badgeSize:33.f
                                  textSize:12.0f];
    
    [self.profileImageView.imageView loadImageWithUrlString:[player photoImageUrlString:@"80"] placeholder:@"playerPlaceholder"];
    [self.flagView setFifaCountryCode:player.nationality];
    self.flagView.countryLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 17];

    NSDictionary *stats = player.stats;
    self.league.text = [NSString stringWithFormat:@"%@ %@", stats[@"competition"] ? stats[@"competition"] : @"", stats[@"season"] ? stats[@"season"] : @"2017/2018"];
    [self.matchesStat setStat:[stats[@"mp"] stringValue] imageName:@"flute" description:@"MATCHES"];
    [self.goalsStat setStat:[stats[@"goals"] stringValue] imageName:@"football" description:@"GOALS"];
    [self.assistsStat setStat:[stats[@"assists"] stringValue] imageName:@"shoe" description:@"ASSISTS"];
    NSString *cards = [NSString stringWithFormat:@"%@/%@", [stats[@"yellowCards"] stringValue] ? [stats[@"yellowCards"] stringValue] : @"", [stats[@"redCards"] stringValue] ? [stats[@"redCards"] stringValue] : @""];
    [self.cardsStat setStat:cards imageName:@"cards" description:@"CARDS"];

    self.matches = player.matches;
    [self.matchTableView reloadData];

    if (self.matches.count > 0) {
        CGFloat height = 44.f;
        height *= self.matches.count;

        [self.matchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height + 30));
        }];
    }

    self.career = player.career;
    self.teams = [self.career bk_select:^BOOL(Team *team) {
        return team.active;
    }];
    if (self.teams.count > 0) {
        [self.teamTableView reloadData];
        [self.teamTableView setTableHeightBasedOnScrollView];
    }
    [self.careerTableView reloadData];
    [self.careerTableView setTableHeightBasedOnScrollView];

    if (player.trophies.count > 0) {
        [self.trophies setData:player.trophies];
        self.trophiesHeader.hidden = NO;
        [self updateContentHeight];
    } else {
        self.trophiesHeader.hidden = YES;
    }
}

// Will determine the height of contentView and insert into scrollView
- (void)updateContentHeight {
    [self.sizingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trophies.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)refreshPlayer:(id)refreshPlayer {
  [self.viewModel fetchPlayerDetails:^{
      [self.refreshControl endRefreshing];
      [self reloadData];
  }];
}

#pragma mark - Button Actions
- (void)goBack {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - TableView methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *labelText;
    NSString *lastText;

    switch (tableView.tag) {
        case CurrentTeamTable: {
            labelText = self.teams.count == 1 ? @"Current team" : @"Current teams";
            break;
        }

        case LastMatchesTable: {
            UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.matchTableView.frame.size.width, 30)];
            labelHeader.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            labelHeader.textAlignment = NSTextAlignmentCenter;
            labelHeader.textColor = [UIColor highlightColor];
            labelHeader.text = @"LAST 5 MATCHES";
            return labelHeader;
        };

        case CareerTable: {
            labelText = @"Senior Career";
            lastText = @"Years";
            break;
        }

        default: break;
    }

    PlayerSectionView *sectionView = [[PlayerSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    [sectionView setSectionTitle:labelText];
    [sectionView setSectionLastText:lastText];

    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == CareerTable && self.career.count == 0) return 0.f;
    return 30.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case CurrentTeamTable: {
            return self.teams.count;
        }

        case LastMatchesTable: {
            return self.matches.count;
        }

        case CareerTable: {
            NSInteger careerCount = self.career.count;

            [self.careerTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((30*careerCount)+34));
            }];

            return careerCount;
        }

        default: {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == CareerTable) return 30.0f;
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case CurrentTeamTable: {
            Team *team = self.teams[(NSUInteger)indexPath.row];

            // Only 2 or 3 cells are rendered so no need to reuse
            // I have tested that there is no reuse when you load the player view again
            DefaultImageViewCell *cell = [[DefaultImageViewCell alloc] init];

            cell.defaultLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
            cell.defaultLabel.text = team.name;
            [cell.defaultImage loadImageWithUrlString:team.logoThumbUrl placeholder:@"clubPlaceholder"];

            return cell;
        }

        case LastMatchesTable: {
            NSDictionary *match = self.matches[(NSUInteger)indexPath.row];
            MatchPlayerTableCell *cell = (MatchPlayerTableCell *)[tableView dequeueReusableCellWithIdentifier:@"matchCell" forIndexPath:indexPath];
            [cell setData:match withPlaceIndex:indexPath.row];
            return cell;
        }

        case CareerTable: {
            Team *team = self.career[(NSUInteger)indexPath.row];
            CareerPlayerViewCell *cell = (CareerPlayerViewCell *)[tableView dequeueReusableCellWithIdentifier:@"careerCell" forIndexPath:indexPath];
            [cell setData:team];
            return cell;
        }

        default: return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case CurrentTeamTable: {
            Team *careerTeam = self.teams[(NSUInteger)indexPath.row];

            Team *team = [Team dictionaryTransformer:@{
                @"_id": careerTeam.objectId,
                @"name": careerTeam.name ? careerTeam.name : [NSNull null],
                @"country": careerTeam.country ? careerTeam.country : [NSNull null]
            }];

            CLS_LOG(@"Team: %@", team.objectId);

            TeamViewController *subscriptionViewControllerWithTeamViewController = [[TeamViewController alloc] initWithTeam:team];
            [self.navigationController pushViewController:subscriptionViewControllerWithTeamViewController animated:YES];

            [[Mixpanel sharedInstance] track:@"Team" properties:@{
                @"id": team.objectId ?: [NSNull null],
                @"name": team.name ?: [NSNull null],
                @"origin": @"player"
            }];

            break;
        }

        case LastMatchesTable: {
            NSDictionary *matchData = self.matches[(NSUInteger)indexPath.row];

            Match *match = [Match dictionaryTransformer:@{
                @"_id": matchData[@"_id"]
            }];

            DefaultSubscriptionViewController *subscriptionControllerWithMatchViewController = [[[MatchPageViewController alloc] initWithMatch:match] wrapInSubscriptionViewController];
            [self.navigationController pushViewController:subscriptionControllerWithMatchViewController animated:YES];

            CLS_LOG(@"Match: %@", match.objectId);

            [[Mixpanel sharedInstance] track:@"Match" properties:@{
                @"id": match.objectId ?: [NSNull null],
                @"origin": @"player"
            }];

            break;
        }

        default: break;
    }
}

#pragma mark - Views
- (UIScrollView *)scrollView {
   if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
   }

   return _scrollView;
}

- (ImageViewWithBadge *)profileImageView {
    if (!_profileImageView) {
        _profileImageView = [[ImageViewWithBadge alloc] initWithBadgeScale:1.08f];
        _profileImageView.imageView.image = [UIImage imageNamed:@"playerPlaceholder"];
        [_profileImageView.imageView circleWithBorder:[UIColor whiteColor] diameter:profilePhotoSize borderWidth:3.f];
    }

    return _profileImageView;
}

- (DefaultLabel *)name {
   if (!_name) {
       _name = [DefaultLabel initWithAlignment:NSTextAlignmentCenter];
       _name.numberOfLines = 0;
       _name.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
   }

   return _name;
}

- (FlagView *)flagView {
   if (!_flagView) {
       _flagView = [[FlagView alloc] initWithCountryCode:nil countryCodeFormat:CountryCodeFormatISO31661Alpha3];
   }

   return _flagView;
}

- (DefaultLabel *)born {
   if (!_born) {
       _born = [DefaultLabel init];
       _born.font = [UIFont fontWithName:@"HelveticaNeue" size: 13];
       _born.textColor = [UIColor primaryColor];
       _born.alpha = 0.6;
   }

   return _born;
}

- (DefaultLabel *)league {
   if (!_league) {
       _league = [DefaultLabel init];
       _league.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 13];
   }

   return _league;
}

- (StatView *)matchesStat {
   if (!_matchesStat) {
       _matchesStat = [[StatView alloc] init];
   }

   return _matchesStat;
}

- (StatView *)goalsStat {
   if (!_goalsStat) {
       _goalsStat = [[StatView alloc] init];
   }

   return _goalsStat;
}

- (StatView *)assistsStat {
   if (!_assistsStat) {
       _assistsStat = [[StatView alloc] init];
   }

   return _assistsStat;
}

- (StatView *)cardsStat {
   if (!_cardsStat) {
       _cardsStat = [[StatView alloc] init];
   }

   return _cardsStat;
}

- (DefaultTableView *)teamTableView {
    if (!_teamTableView) {
        _teamTableView = [[DefaultTableView alloc] initWithDelegate:self];
        _teamTableView.dataSource = self;
        _teamTableView.tag = CurrentTeamTable;
        [_teamTableView registerClass:[DefaultViewCell class] forCellReuseIdentifier:@"leagueCell"];
        _teamTableView.scrollEnabled = NO;
    }

    return _teamTableView;
}

- (DefaultTableView *)matchTableView {
    if (!_matchTableView) {
        _matchTableView = [[DefaultTableView alloc] initWithDelegate:self];
        _matchTableView.dataSource = self;
        _matchTableView.tag = LastMatchesTable;
        [_matchTableView registerClass:[MatchPlayerTableCell class] forCellReuseIdentifier:@"matchCell"];
        _matchTableView.scrollEnabled = NO;
    }

    return _matchTableView;
}

- (DefaultTableView *)careerTableView {
    if (!_careerTableView) {
        _careerTableView = [[DefaultTableView alloc] initWithDelegate:self];
        _careerTableView.dataSource = self;
        _careerTableView.tag = CareerTable;
        [_careerTableView registerClass:[CareerPlayerViewCell class] forCellReuseIdentifier:@"careerCell"];
        _careerTableView.scrollEnabled = NO;
    }

    return _careerTableView;
}

- (TrophiesView *)trophies {
    if (!_trophies) {
        _trophies = [[TrophiesView alloc] init];
    }

    return _trophies;
}

@end
