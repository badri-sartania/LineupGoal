//
//  LeaderboardContentViewController.m
//  GoalFury
//
//  Created by Kevin Li on 6/1/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import "LeaderboardContentViewController.h"
#import "HexColors.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"
#import <QuartzCore/QuartzCore.h>
#import "JGProgressHUD.h"
#import "LineupBattleResource.h"
#import "Identification.h"
#import "User.h"
#import "LeaderboardTableViewCell.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "FlagView.h"
#import <QuartzCore/QuartzCore.h>
#import "PrizeViewController.h"

@interface LeaderboardContentViewController ()

@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) UIView *contentTypeView;
@property(nonatomic, strong) UIView *bottomUserView;
@property(nonatomic, strong) UILabel *navTitle;
@property(nonatomic, strong) UILabel *navSubTitle;
@property(nonatomic, strong) NSString *contentType;     //  board(0) || friends(1)
@property(nonatomic, strong) UIButton *boardButton;
@property(nonatomic, strong) UIButton *friendButton;
@property(nonatomic, strong) NSDate *countDownDate;
@property(nonatomic, strong) JGProgressHUD *HUD;
@property(nonatomic, strong) NSDate *currentMonth;
@property(nonatomic, strong) Leaderboard *worldLeaderboard;
@property(nonatomic, strong) Leaderboard *friendLeaderboard;
@property(nonatomic, strong) NSArray *tableData;
@property(nonatomic, strong) DefaultImageView *prizeImage;
@end

static NSInteger navigationBarHeight = 77;
static NSInteger userCellHeight = 70;
static NSInteger TAG_ME_RANK = 1000;
static NSInteger TAG_ME_PHOTO = 1001;
static NSInteger TAG_ME_NAME = 1002;
static NSInteger TAG_ME_FLAG = 1003;
static NSInteger TAG_ME_COUNTRY = 1004;
static NSInteger TAG_ME_POINT = 1005;
static NSInteger TAG_ME_BOLT = 1006;
static NSInteger TAG_ME_BOLT_COUNT = 1007;

@implementation LeaderboardContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self setupContentTypeView];
    [self setupTableView];
    [self setupBottomMe];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateTimer:)
                                   userInfo:nil
                                    repeats:YES];
    
    [self loadLeaderboardDataWithMonth:self.currentMonth];
}
- (id)initWithLeaderboardType:(NSString *)leaderboardType
{
    self = [super init];
    if (self) {
        self.leaderboardType = leaderboardType;
        self.contentType = @"board";
        
        // Initialize JG Loading HUD
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.HUD.textLabel.text = @"Loading";
        
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:[NSDate date]]; // Get necessary date components
        [comps setDay:1];
        
        // Set current month
        self.currentMonth = [[NSCalendar currentCalendar] dateFromComponents:comps];
        NSLog(@"First day of this month - %@", self.currentMonth);
        
        // Set the Last day of month
        [comps setMonth:[comps month] + 1];
        self.countDownDate = [calendar dateFromComponents:comps];
        NSLog(@"The last day of month - %@", self.countDownDate);
        
        // Initialize Leaderboard data
        self.tableData = [[NSArray alloc] init];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
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
    if ([self.leaderboardType isEqualToString:@"xi"]) {
        [self.navTitle setText:@"ULTIMATE XI"];
    } else if ([self.leaderboardType isEqualToString:@"point"]) {
        [self.navTitle setText:@"TOTAL POINTS"];
    } else {
        [self.navTitle setText:@"BEST LINEUP"];
    }
    
    self.navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    self.navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:self.navTitle];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(32);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@21);
    }];
    
    self.navSubTitle = [[UILabel alloc] init];
    [self.navSubTitle setText:@"Ends in 00:00:00"];
    self.navSubTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    self.navSubTitle.textColor = [UIColor whiteColor];
    self.navSubTitle.alpha = 0.5;
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
    
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [navRightButton setTitle:@"Prizes" forState:UIControlStateNormal];
    [navRightButton setTitleColor:[UIColor championsLeagueColor] forState:UIControlStateNormal];
    navRightButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
    [navRightButton setContentMode:UIViewContentModeCenter];
    [navRightButton addTarget:self
                       action:@selector(prizePressed)
             forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navRightButton];
    [navRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationBar).offset(-10);
        make.top.equalTo(self.navigationBar).offset(20);
        make.width.equalTo(@50);
        make.height.equalTo(@44);
    }];
}

- (void)setupContentTypeView {
    self.contentTypeView = [[UIView alloc] init];
    [self.view addSubview:self.contentTypeView];
    [self.contentTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    UIButton *prevIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9, 50)];
    [prevIcon setImage:[UIImage imageNamed:@"ic_gray_arrow_right"]
              forState:UIControlStateNormal];
    prevIcon.imageView.transform = CGAffineTransformMakeRotation(3.141592);
    [prevIcon setContentMode:UIViewContentModeCenter];
    [prevIcon addTarget:self action:@selector(onPrevPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentTypeView addSubview:prevIcon];
    [prevIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar).offset(8);
        make.centerY.equalTo(self.contentTypeView);
        make.width.equalTo(@9);
        make.height.equalTo(@14);
    }];
    
    UIButton *prevButton = [[UIButton alloc] init];
    [self.contentTypeView addSubview:prevButton];
    [prevButton setTitle:@"PREV" forState:UIControlStateNormal];
    prevButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    [prevButton setTitleColor:[UIColor highlightColor] forState:UIControlStateNormal];
    [prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prevIcon.mas_right);
        make.centerY.equalTo(self.contentTypeView);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    [prevButton addTarget:self action:@selector(onPrevPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9, 50)];
    [nextIcon setImage:[UIImage imageNamed:@"ic_gray_arrow_right"]
              forState:UIControlStateNormal];
    [nextIcon setContentMode:UIViewContentModeCenter];
    [nextIcon addTarget:self action:@selector(onNextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentTypeView addSubview:nextIcon];
    [nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationBar).offset(-8);
        make.centerY.equalTo(self.contentTypeView);
        make.width.equalTo(@9);
        make.height.equalTo(@50);
    }];
    
    UIButton *nextButton = [[UIButton alloc] init];
    [self.contentTypeView addSubview:nextButton];
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    [nextButton setTitleColor:[UIColor highlightColor] forState:UIControlStateNormal];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nextIcon.mas_left);
        make.centerY.equalTo(self.contentTypeView);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    [nextButton addTarget:self action:@selector(onNextPressed) forControlEvents:UIControlEventTouchUpInside];
    if ([self.leaderboardType isEqualToString:@"xi"]) {
        prevButton.hidden = YES;
        nextButton.hidden = YES;
        prevIcon.hidden = YES;
        nextIcon.hidden = YES;
    }
    
    self.boardButton = [[UIButton alloc] init];
    [self.contentTypeView addSubview:self.boardButton];
    [self.boardButton setTitle:@"BOARD" forState:UIControlStateNormal];
    [self.boardButton setTitleColor:[UIColor primaryColor] forState:UIControlStateNormal];
    self.boardButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    [self.boardButton addTarget:self action:@selector(onBoardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.boardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@94);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentTypeView);
        make.centerX.equalTo(self.contentTypeView).offset(-48);
    }];
    self.boardButton.backgroundColor = [UIColor whiteColor];
    self.boardButton.layer.borderWidth = 0.0f;
    self.boardButton.layer.cornerRadius = 15.0f;
    
    self.friendButton = [[UIButton alloc] init];
    [self.contentTypeView addSubview:self.friendButton];
    [self.friendButton setTitle:@"FRIENDS" forState:UIControlStateNormal];
    [self.friendButton setTitleColor:[UIColor primaryColor] forState:UIControlStateNormal];
    self.friendButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    [self.friendButton addTarget:self action:@selector(onFriendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@94);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentTypeView);
        make.centerX.equalTo(self.contentTypeView).offset(48);
    }];
    self.friendButton.backgroundColor = [UIColor whiteColor];
    self.friendButton.layer.borderWidth = 0.0f;
    self.friendButton.layer.cornerRadius = 15.0f;
    
    [self updateContentType:0];
}

- (void)setupBottomMe {
    User *user = [self getUserFromId:[Identification userId]];
    // User view
    self.bottomUserView = [[UIView alloc] init];
    [self.view addSubview:self.bottomUserView];
    
    [self.bottomUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(userCellHeight));
    }];
    
    DefaultLabel *labelRank = [DefaultLabel initWithBoldSystemFontSize:14 color:[UIColor secondaryTextColor]];
    [labelRank setTag:TAG_ME_RANK];
    [labelRank setTextAlignment:NSTextAlignmentCenter];
    [self.bottomUserView addSubview:labelRank];
    [labelRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomUserView).offset(3);
        make.centerY.equalTo(self.bottomUserView);
        make.width.equalTo(@40);
    }];
    
    DefaultImageView *imagePhoto = [[DefaultImageView alloc] init];
    [imagePhoto setTag:TAG_ME_PHOTO];
    [imagePhoto circleWithBorder:[UIColor whiteColor] diameter:44 borderWidth:0.0];
    [imagePhoto setImage:[UIImage imageNamed:@"playerPlaceholder"]];
    [self.bottomUserView addSubview:imagePhoto];
    [imagePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelRank.mas_right).offset(3);
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.bottomUserView);
    }];
    
    DefaultLabel *labelName = [DefaultLabel initWithMediumSystemFontSize:16 color:[UIColor primaryTextColor]];
    [labelName setTag:TAG_ME_NAME];
    [self.bottomUserView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imagePhoto.mas_right).offset(10);
        make.top.equalTo(imagePhoto.mas_top).offset(2);
    }];
    
    FlagView *imageFlag = [[FlagView alloc] initWithCountryCode:nil countryCodeFormat:CountryCodeFormatISO31661Alpha3];
    [imageFlag setTag:TAG_ME_FLAG];
//    [self.flagView setFifaCountryCode:player.nationality];
//    [imageFlag setImage:[UIImage imageNamed:@"flag_empty"]];
    [self.bottomUserView addSubview:imageFlag];
    [imageFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imagePhoto.mas_right).offset(10);
        make.bottom.equalTo(imagePhoto.mas_bottom).offset(-2);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    
    DefaultLabel *labelFlag = [DefaultLabel initWithSystemFontSize:14 color:[UIColor secondaryTextColor]];
    [labelFlag setTag:TAG_ME_COUNTRY];
    [self.bottomUserView addSubview:labelFlag];
    [labelFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageFlag);
        make.left.equalTo(imageFlag.mas_right).offset(6);
    }];
    
    DefaultLabel *labelPoint = [DefaultLabel initWithBoldSystemFontSize:16 color:[UIColor primaryTextColor]];
    [labelPoint setTag:TAG_ME_POINT];
    [self.bottomUserView addSubview:labelPoint];
    [labelPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelName);
        make.right.equalTo(self.bottomUserView).offset(-10);
    }];
    
    DefaultLabel *labelBolt = [DefaultLabel initWithSystemFontSize:14 color:[UIColor primaryTextColor]];
    [labelBolt setTag:TAG_ME_BOLT_COUNT];
    [self.bottomUserView addSubview:labelBolt];
    [labelBolt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomUserView).offset(-10);
        make.bottom.equalTo(labelFlag);
    }];
    
    DefaultImageView *imageBolt = [[DefaultImageView alloc] init];
    [imageBolt setTag:TAG_ME_BOLT];
    [imageBolt setImage:[UIImage imageNamed:@"ic_bolt"]];
    [self.bottomUserView addSubview:imageBolt];
    [imageBolt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelBolt);
        make.right.equalTo(labelBolt.mas_left).offset(-4);
        make.width.equalTo(@9);
    }];
    
    // drop shadow
    [self.bottomUserView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.bottomUserView.layer setShadowOpacity:0.6];
    [self.bottomUserView.layer setShadowRadius:7.0];
    [self.bottomUserView.layer setShadowOffset:CGSizeMake(0.0, -1.0)];
    self.bottomUserView.layer.masksToBounds = NO;
    self.bottomUserView.backgroundColor = [UIColor whiteColor];
    
    if (user == nil) [self.bottomUserView setHidden:YES];
}

- (void)updateBottomMe:(User *)me {
    if (me == nil) [self.bottomUserView setHidden:YES];
    else [self.bottomUserView setHidden:NO];
    
    DefaultLabel *labelRank = [self.bottomUserView viewWithTag:TAG_ME_RANK];
    [labelRank setText: [me.pos stringValue]];
    DefaultImageView *imagePhoto = [self.bottomUserView viewWithTag:TAG_ME_PHOTO];
    [imagePhoto loadImageWithUrlString:nil placeholder:@"playerPlaceholder"];
    DefaultLabel *labelName = [self.bottomUserView viewWithTag:TAG_ME_NAME];
    [labelName setText:me.name];
    FlagView *imageFlag = [self.bottomUserView viewWithTag:TAG_ME_FLAG];
    [imageFlag setISO2CountryCode:me.country];
    DefaultLabel *labelFlag = [self.bottomUserView viewWithTag:TAG_ME_COUNTRY];
    [labelFlag setText: me.country];
    DefaultLabel *labelPoint = [self.bottomUserView viewWithTag:TAG_ME_POINT];
    [labelPoint setText: [NSString stringWithFormat:@"%@p", [self.leaderboardType isEqualToString:@"xi"] ? [me.ultimateXI_points stringValue] : [me.points stringValue]]];
    DefaultLabel *labelBolt = [self.bottomUserView viewWithTag:TAG_ME_BOLT_COUNT];
    if (me.coins != nil)
        [labelBolt setText: [me.coins stringValue]];
    else labelBolt.text = @"0";
    DefaultImageView *imageBolt = [self.bottomUserView viewWithTag:TAG_ME_BOLT];
    imageBolt.hidden = false;
}

- (void)setupTableView {
    self.prizeImage = [[DefaultImageView alloc] init];
    [self.view addSubview:self.prizeImage];
    [self.prizeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(self.contentTypeView.mas_bottom);
        make.height.equalTo(@((self.view.frame.size.width - 10) * 0.278));
    }];
    CALayer * layer = [self.prizeImage layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    if ([self.leaderboardType isEqualToString:@"xi"]) {
        self.prizeImage.hidden = YES;
    }
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LeaderboardTableViewCell class] forCellReuseIdentifier:@"leaderboardTableViewCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        [self.leaderboardType isEqualToString:@"xi"] ? make.top.equalTo(self.contentTypeView.mas_bottom) : make.top.equalTo(self.prizeImage.mas_bottom).offset(8);
        make.bottom.equalTo(self.view).offset(-70);
    }];
}

- (id)getUserFromId:(NSString *)userId {
    for (int i = 0; i < self.tableData.count; i++) {
        User *user = [self.tableData objectAtIndex:i];
        if ([user.objectId isEqualToString:userId]) {
            return user;
        }
    }
    return nil;
}

- (void)updateContentType:(NSInteger) type {
    if (type == 0) {
        self.contentType = @"board";
        self.boardButton.backgroundColor = [UIColor primaryColor];
        [self.boardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.friendButton.backgroundColor = [UIColor whiteColor];
        [self.friendButton setTitleColor:[UIColor primaryColor] forState:UIControlStateNormal];
    } else if (type == 1) {
        self.contentType = @"friends";
        self.friendButton.backgroundColor = [UIColor primaryColor];
        [self.friendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.boardButton.backgroundColor = [UIColor whiteColor];
        [self.boardButton setTitleColor:[UIColor primaryColor] forState:UIControlStateNormal];
    }
}

- (void)updateTimer:(NSTimer *)timer {
    NSDateComponents *component = [self differenceInDaysWithDate:self.countDownDate];
    NSString *dayString = [NSString stringWithFormat:@"%@%d", component.day < 10 ? @"0" : @"", (int)component.day];
    NSString *hourString = [NSString stringWithFormat:@"%@%d", component.hour < 10 ? @"0" : @"", (int)component.hour];
    NSString *minuteString = [NSString stringWithFormat:@"%@%d", component.minute < 10 ? @"0" : @"", (int)component.minute];
    NSString *diffString = [NSString stringWithFormat:@"Ends in %@d %@h %@m", dayString, hourString, minuteString];
    [self.navSubTitle setText:diffString];
}

- (NSDateComponents *)differenceInDaysWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:[NSDate date] toDate:date options:NSCalendarMatchStrictly];
    return components;
}

- (void)loadLeaderboardDataWithMonth:(NSDate *)currentDate {
    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    NSString *strMonth = [NSString stringWithFormat:@"%d%@%d",(int)component.year, component.month < 10 ? @"0" : @"", (int)component.month];
    NSLog(@"Loading Leaderboard for %@", strMonth);
    [self.HUD showInView:self.view];
    if ([self.leaderboardType isEqualToString:@"xi"]) {
        [LineupBattleResource ultimateXiForSeason:^(NSArray<Leaderboard *> *leaderboards) {
            self.worldLeaderboard = leaderboards[0];
            self.friendLeaderboard = leaderboards[1];
            [self updateTableData];
            [self.HUD dismissAnimated:YES];
        } failure:^(NSError *error) {
            [self.HUD dismissAnimated:YES];
        }];
    } else if ([self.leaderboardType isEqualToString:@"point"]) {
        [LineupBattleResource leaderboardsForMonth:strMonth success:^(NSArray<Leaderboard *> *leaderboards) {
            self.worldLeaderboard = leaderboards[0];
            self.friendLeaderboard = leaderboards[1];
            [self updateTableData];
            [self.HUD dismissAnimated:YES];
        } failure:^(NSError *error) {
            [self.HUD dismissAnimated:YES];
        }];
    } else {
        [LineupBattleResource leaderboardsForMonth:strMonth success:^(NSArray<Leaderboard *> *leaderboards) {
            self.worldLeaderboard = leaderboards[0];
            self.friendLeaderboard = leaderboards[1];
            [self updateTableData];
            [self.HUD dismissAnimated:YES];
        } failure:^(NSError *error) {
            [self.HUD dismissAnimated:YES];
        }];
    }
    
}

- (void)updateTableData {
    NSArray *users;
    if ([self.contentType isEqualToString:@"board"]) {
        // Board - meaning global
        [self.prizeImage loadImageWithUrlString:self.worldLeaderboard.prize placeholder:@""];
        users = [self.leaderboardType isEqualToString:@"xi"] ? self.worldLeaderboard.users : self.worldLeaderboard.total;
//        if ([self.leaderboardType isEqualToString:@"point"])
//            users = self.worldLeaderboard.total;
//        else
//            users = self.worldLeaderboard.lineup;
    } else {
        // Friend
        [self.prizeImage loadImageWithUrlString:self.friendLeaderboard.prize placeholder:@""];
        users = [self.leaderboardType isEqualToString:@"xi"] ? self.friendLeaderboard.users : self.friendLeaderboard.total;
//        if ([self.leaderboardType isEqualToString:@"point"])
//            users = self.friendLeaderboard.total;
//        else
//            users = self.friendLeaderboard.lineup;
    }
    self.tableData = users;
    User *me = [self getUserFromId:[Identification userId]];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(me == nil ? 0 : -userCellHeight);
    }];
    
    [self updateBottomMe:me];
    [self.tableView reloadData];
}

#pragma mark - Button Actions

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prizePressed {
    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *strMonth = [NSString stringWithFormat:@"%d%@%d",(int)component.year, component.month < 10 ? @"0" : @"", (int)component.month];
    PrizeViewController *vc = [[PrizeViewController alloc] initWithPrizeType:self.leaderboardType month:strMonth];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPrevPressed {
    NSLog(@"Prev button pressed");
    NSDateComponents *thisMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *selectedMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self.currentMonth];
    if (selectedMonth.year < thisMonth.year && selectedMonth.month <= thisMonth.month) return;
    
    self.currentMonth = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:self.currentMonth options:0];
    [self loadLeaderboardDataWithMonth:self.currentMonth];
}

- (void)onNextPressed {
    NSLog(@"Next button pressed");
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *selectedMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self.currentMonth];
    if (selectedMonth.year < components.year || selectedMonth.month < components.month) {
        self.currentMonth = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self.currentMonth options:0];
        [self loadLeaderboardDataWithMonth:self.currentMonth];
    }
}

- (void)onBoardButtonPressed {
    [self updateContentType:0];
}

- (void)onFriendButtonPressed {
    [self updateContentType:1];
}

#pragma mark - TableView DataSource and Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.tableData objectAtIndex:indexPath.row];
    LeaderboardTableViewCell *cell = (LeaderboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leaderboardTableViewCell" forIndexPath:indexPath];
    [cell setUser:user position:indexPath.row type:self.leaderboardType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
