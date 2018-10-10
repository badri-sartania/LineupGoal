//
//  LeaderboardViewController.m
//  GoalFury
//
//  Created by Kevin Li on 5/3/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LineupBattleResource.h"
#import "YLMoment.h"
#import "UIColor+LineupBattle.h"
#import "Utils.h"
#import "Leaderboard.h"
#import "DefaultLabel.h"
#import "User.h"
#import "Identification.h"
#import "LeaderboardContentViewController.h"
#import "DefaultNavigationController.h"

@interface LeaderboardViewController ()
@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) NSArray *sections;
@property(nonatomic, strong) NSArray *leaderboardData;
@property(nonatomic, strong) NSMutableArray *monthlyTableData;
@property(nonatomic, strong) DefaultLabel *labelXiContent;
@property(nonatomic, strong) DefaultLabel *labelPositionContent;
@property(nonatomic, strong) DefaultLabel *labelLineupContent;
@end

static NSInteger navigationBarHeight = 64;
static NSInteger totalPointsButtonTag = 100;
static NSInteger bestLineupButtonTag = 101;
static NSInteger ultimateXiButtonTag = 102;

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sections = @[
                 @"Seasonal",
                 @"Monthly"
                 ];
    
    [self setupNavigationBar];
    self.leaderboardData = [[NSArray alloc] init];
    self.monthlyTableData = [NSMutableArray arrayWithArray:@[@{
                                                                 @"title":@"TOTAL POINTS",
                                                                 @"position": @"0"
                                                                 },
                                                             @{
                                                                 @"title":@"BEST LINEUP",
                                                                 @"position": @"0"
                                                                 },
                                                             ]];
    [self setupContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadLeaderboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLeaderboard {
    YLMoment *moment = [YLMoment now];
    [LineupBattleResource leaderboardsForMonth:[moment format:@"yyyyMM"] success:^(NSArray<Leaderboard *> *leaderboards) {
//    [LineupBattleResource leaderboardsForMonth:@"201804" success:^(NSArray<Leaderboard *> *leaderboards) {
        NSLog(@"data received");
        self.leaderboardData = leaderboards;
        [self updateCells];
    } failure:^(NSError *error) {
        NSLog(@"failed to receive data.");
    }];
}

- (void)setupNavigationBar {
    // Setup navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    [navTitle setText:@"LEADERBOARD"];
    navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
    }];
}

- (void)setupContentView {
    [self.view setBackgroundColor:[UIColor lightBorderColor]];
    
    // Month Setup Season Section
    UIView *seasonSection = [[UIView alloc] init];
    seasonSection.backgroundColor = [UIColor primaryColor];
    [self.view addSubview:seasonSection];
    [seasonSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.height.equalTo(@26);
    }];
    DefaultLabel *lbSeason = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor whiteColor]];
    [seasonSection addSubview:lbSeason];
    [lbSeason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(seasonSection);
        make.left.equalTo(@10);
    }];
    [lbSeason setText:@"SEASON"];
    UIView *xiCell = [[UIView alloc] init];
    [xiCell setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:xiCell];
    [xiCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(seasonSection.mas_bottom);
        make.height.equalTo(@84);
    }];
    UIView *xiWrapper = [[UIView alloc] init];
    [xiCell addSubview:xiWrapper];
    [xiWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(xiCell);
        make.width.equalTo(@84);
    }];
    UIImageView *trophy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_trophy2"]];
    [xiWrapper addSubview:trophy];
    [trophy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(xiWrapper);
    }];
    DefaultLabel *labelXi = [DefaultLabel initWithCondensedBoldSystemFontSize:15 color:[UIColor primaryTextColor]];
    [labelXi setText:@"ULTIMATE XI"];
    [xiCell addSubview:labelXi];
    [labelXi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xiWrapper.mas_right).offset(2);
        make.top.equalTo(@23);
    }];
    DefaultLabel *labelPosition = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [labelPosition setText:@"Position: "];
    [xiCell addSubview:labelPosition];
    [labelPosition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xiWrapper.mas_right).offset(2);
        make.top.equalTo(labelXi.mas_bottom).offset(4);
    }];
    self.labelXiContent = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [xiCell addSubview:self.labelXiContent];
    [self.labelXiContent setText:@" N/A "];
    [self.labelXiContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPosition.mas_right);
        make.centerY.equalTo(labelPosition);
    }];
    UIImageView *icArrowRight0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_gray_arrow_right"]];
    [xiCell addSubview:icArrowRight0];
    [icArrowRight0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(xiCell);
        make.width.equalTo(@9);
        make.height.equalTo(@14);
        make.right.equalTo(xiCell).offset(-6);
    }];
    UIButton *button = [[UIButton alloc] init];
    [xiCell addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(xiCell);
    }];
    [button setTag:ultimateXiButtonTag];
    [button addTarget:self action:@selector(onLeaderboard:) forControlEvents:UIControlEventTouchUpInside];
    
    // Month Setup Section
    UIView *monthSection = [[UIView alloc] init];
    monthSection.backgroundColor = [UIColor primaryColor];
    [self.view addSubview:monthSection];
    [monthSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(xiCell.mas_bottom);
        make.height.equalTo(@26);
    }];
    DefaultLabel *lbMonth = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor whiteColor]];
    [monthSection addSubview:lbMonth];
    [lbMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(monthSection);
        make.left.equalTo(@10);
    }];
    [lbMonth setText:@"MONTHLY"];
    
    // Setup TotalPoints
    UIView *totalPointCell = [[UIView alloc] init];
    [totalPointCell setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:totalPointCell];
    [totalPointCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(monthSection.mas_bottom);
        make.height.equalTo(@84);
    }];
    UIView *trophyWrapper1 = [[UIView alloc] init];
    [totalPointCell addSubview:trophyWrapper1];
    [trophyWrapper1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(totalPointCell);
        make.width.equalTo(@84);
    }];
    UIImageView *trophy1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_trophy"]];
    [trophyWrapper1 addSubview:trophy1];
    [trophy1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(trophyWrapper1);
    }];
    DefaultLabel *labelTotalPoint = [DefaultLabel initWithCondensedBoldSystemFontSize:15 color:[UIColor primaryTextColor]];
    [labelTotalPoint setText:@"TOTAL POINTS"];
    [totalPointCell addSubview:labelTotalPoint];
    [labelTotalPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trophyWrapper1.mas_right).offset(2);
        make.top.equalTo(@23);
    }];
    DefaultLabel *labelPosition1 = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [labelPosition1 setText:@"Position: "];
    [totalPointCell addSubview:labelPosition1];
    [labelPosition1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trophyWrapper1.mas_right).offset(2);
        make.top.equalTo(labelTotalPoint.mas_bottom).offset(4);
    }];
    self.labelPositionContent = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [totalPointCell addSubview:self.labelPositionContent];
    [self.labelPositionContent setText:@" N/A "];
    [self.labelPositionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPosition1.mas_right);
        make.centerY.equalTo(labelPosition1);
    }];
    UIImageView *icArrowRight1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_gray_arrow_right"]];
    [totalPointCell addSubview:icArrowRight1];
    [icArrowRight1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalPointCell);
        make.width.equalTo(@9);
        make.height.equalTo(@14);
        make.right.equalTo(totalPointCell).offset(-6);
    }];
    UIButton *button1 = [[UIButton alloc] init];
    [totalPointCell addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(totalPointCell);
    }];
    [button1 setTag:totalPointsButtonTag];
    [button1 addTarget:self action:@selector(onLeaderboard:) forControlEvents:UIControlEventTouchUpInside];
    
    // Setup BestLineup
    UIView *splitter = [[UIView alloc] init];
    [self.view addSubview: splitter];
    [splitter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(totalPointCell.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    splitter.backgroundColor = [UIColor highlightColor];
    
    UIView *bestLineupCell = [[UIView alloc] init];
    [bestLineupCell setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bestLineupCell];
    [bestLineupCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(splitter.mas_bottom);
        make.height.equalTo(@84);
    }];
    UIView *trophyWrapper2 = [[UIView alloc] init];
    [bestLineupCell addSubview:trophyWrapper2];
    [trophyWrapper2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bestLineupCell);
        make.width.equalTo(@84);
    }];
    UIImageView *trophy2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_trophy1"]];
    [trophyWrapper2 addSubview:trophy2];
    [trophy2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(trophyWrapper2);
    }];
    DefaultLabel *labelLineupPoint = [DefaultLabel initWithCondensedBoldSystemFontSize:15 color:[UIColor primaryTextColor]];
    [labelLineupPoint setText:@"BEST LINEUP"];
    [bestLineupCell addSubview:labelLineupPoint];
    [labelLineupPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trophyWrapper2.mas_right).offset(2);
        make.top.equalTo(@23);
    }];
    DefaultLabel *labelPosition2 = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [labelPosition2 setText:@"Position: "];
    [bestLineupCell addSubview:labelPosition2];
    [labelPosition2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trophyWrapper2.mas_right).offset(2);
        make.top.equalTo(labelLineupPoint.mas_bottom).offset(4);
    }];
    self.labelLineupContent = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [bestLineupCell addSubview:self.labelLineupContent];
    [self.labelLineupContent setText:@" N/A "];
    [self.labelLineupContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPosition2.mas_right);
        make.centerY.equalTo(labelPosition2);
    }];
    UIImageView *icArrowRight2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_gray_arrow_right"]];
    [bestLineupCell addSubview:icArrowRight2];
    [icArrowRight2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bestLineupCell);
        make.width.equalTo(@9);
        make.height.equalTo(@14);
        make.right.equalTo(bestLineupCell).offset(-6);
    }];
    
    UIButton *button2 = [[UIButton alloc] init];
    [bestLineupCell addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(bestLineupCell);
    }];
    [button2 setTag:bestLineupButtonTag];
    [button2 addTarget:self action:@selector(onLeaderboard:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateCells {
    Leaderboard *leaderboard = self.leaderboardData[0];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:YES];
    NSArray *sortedTotalArray = [leaderboard.total sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSArray *sortedLineupArray = [leaderboard.total sortedArrayUsingDescriptors:@[sortDescriptor]];
    for (int i = 0; i < sortedTotalArray.count; i++) {
        User *user = sortedTotalArray[i];
        if ([user.objectId isEqualToString:[Identification userId]]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterOrdinalStyle;
            self.labelPositionContent.text = [NSString stringWithFormat:@" %@ ", [numberFormatter stringFromNumber:@(i + 1)]];
            break;
        }
    }
    for (int i = 0; i < sortedLineupArray.count; i++) {
        User *user = sortedTotalArray[i];
        if ([user.objectId isEqualToString:[Identification userId]]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterOrdinalStyle;
            self.labelPositionContent.text = [NSString stringWithFormat:@" %@ ", [numberFormatter stringFromNumber:@(i + 1)]];
            break;
        }
    }
}

#pragma mark - Button Actions

- (void)onLeaderboard:(UIButton *)button {
    NSInteger tag = button.tag;
    if (tag == totalPointsButtonTag) {
        NSLog(@"Total Point Button pressed");
        LeaderboardContentViewController *leaderboardTableViewController = [[LeaderboardContentViewController alloc] initWithLeaderboardType:@"point"];
        DefaultNavigationController *defaultNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:leaderboardTableViewController];
        [self presentViewController:defaultNavigationController animated:YES completion:nil];
    }
    if (tag == bestLineupButtonTag) {
        NSLog(@"Best Lineup Button pressed");
        LeaderboardContentViewController *leaderboardTableViewController = [[LeaderboardContentViewController alloc] initWithLeaderboardType:@"lineup"];
        DefaultNavigationController *defaultNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:leaderboardTableViewController];
        [self presentViewController:defaultNavigationController animated:YES completion:nil];
    }
    if (tag == ultimateXiButtonTag) {
        NSLog(@"UltimateXI Button pressed");
        LeaderboardContentViewController *leaderboardTableViewController = [[LeaderboardContentViewController alloc] initWithLeaderboardType:@"xi"];
        DefaultNavigationController *defaultNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:leaderboardTableViewController];
        [self presentViewController:defaultNavigationController animated:YES completion:nil];
    }
}
@end
