//
//  PrizeViewController.m
//  GoalFury
//
//  Created by Kevin Li on 7/4/18.
//  Copyright © 2018 GoalFury. All rights reserved.
//

#import "PrizeViewController.h"
#import "JGProgressHUD.h"
#import "UIColor+LineupBattle.h"
#import "Utils.h"
#import "PrizeTableViewCell.h"
#import "LineupBattleResource.h"

@interface PrizeViewController ()
@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) NSArray *tableData;
@property(nonatomic, strong) JGProgressHUD *HUD;
@end

static NSInteger navigationBarHeight = 64;

@implementation PrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupTableView];
    
    [self loadPrizeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithPrizeType:(NSString *)prizeType month:(NSString *)month
{
    self = [super init];
    if (self) {
        self.prizeType = prizeType;
        self.prizeMonth = month;
        // Initialize JG Loading HUD
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.HUD.textLabel.text = @"Loading";
        self.tableData = [[NSArray alloc] init];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
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
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    navTitle.textColor = [UIColor whiteColor];
    navTitle.text = @"PRIZES";
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(32);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@21);
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
    [navRightButton setImage:[UIImage imageNamed:@"ic_prize_info"]
               forState:UIControlStateNormal];
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
    
    UIView *bottomBorder = [[UIView alloc] init];
    bottomBorder.backgroundColor = [UIColor primaryTextColor];
    [self.navigationBar addSubview:bottomBorder];
    [bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navigationBar);
        make.height.equalTo(@0.5);
    }];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PrizeTableViewCell class] forCellReuseIdentifier:@"prizeTableViewCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)loadPrizeData {
    [self.HUD showInView:self.view];
    if ([self.prizeType isEqualToString:@"xi"]) {
        [LineupBattleResource pointPrizesForMonth:self.prizeMonth success:^(NSArray* prizes) {
            self.tableData = prizes;
            [self.tableView reloadData];
            [self.HUD dismissAnimated:YES];
        } failure:^(NSError *error) {
            [self.HUD dismissAnimated:YES];
        }];
    } else if ([self.prizeType isEqualToString:@"point"]) {
        [LineupBattleResource pointPrizesForMonth:self.prizeMonth success:^(NSArray* prizes) {
            self.tableData = prizes;
            [self.tableView reloadData];
            [self.HUD dismissAnimated:YES];
        } failure:^(NSError *error) {
            [self.HUD dismissAnimated:YES];
        }];
    } else {
        [LineupBattleResource lineupPrizesForMonth:self.prizeMonth success:^(NSArray* prizes) {
            self.tableData = prizes;
            [self.tableView reloadData];
            [self.HUD dismissAnimated:YES];
        } failure:^(NSError *error) {
            [self.HUD dismissAnimated:YES];
        }];
    }
}


- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prizePressed {
    NSLog(@"Prize button pressed");
}

#pragma mark - TableView DataSource and Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils screenWidth] * 100 / 360 + 26.f + 52;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *prize = [self.tableData objectAtIndex:indexPath.row];
    PrizeTableViewCell *cell = (PrizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"prizeTableViewCell" forIndexPath:indexPath];
    [cell setUser:prize position:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
