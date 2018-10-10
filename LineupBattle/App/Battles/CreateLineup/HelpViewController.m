//
// Created by Anders Borre Hansen on 25/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "HelpViewController.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"

@interface HelpViewController ()
@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) UIScrollView *scrollView;
@end

static NSInteger navigationBarHeight = 64;

@implementation HelpViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeInfoView)];
    }

    return self;
}

- (instancetype)initForCreateLineup {
    self = [self init];

    if (self) {
        self.infoPageType = BattleInfoPage;
        self.title = @"Lineup Info";
    }

    return self;
}

- (instancetype)initForBattle {
    self = [self init];

    if (self) {
        self.infoPageType = CreateLineupPage;
        self.title = @"Battle Info";
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES];
    [self setupNavigationBar];

    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];

    UIView *contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    if (self.infoPageType == BattleInfoPage) {
        [self setupBattleInfoPage:contentView];
    } else {
        [self setupLineupInfoPage:contentView];
    }

}

- (void)setupBattleInfoPage:(UIView *)parentView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"how2play"]];
    [self.scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(30);
        make.left.right.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView).offset(-30);
    }];
}

- (void)setupLineupInfoPage:(UIView *)parentView {
    NSString *topImageName;
    topImageName = [Utils imageWithScreenWidthNamed:@"how-to-play-topb"];
    UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:topImageName]];
    [self.scrollView addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(10);
        make.left.right.equalTo(self.scrollView);
    }];
    
    UIImageView *tableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[Utils imageWithScreenWidthNamed:@"how-to-play-table"]]];
    [self.scrollView addSubview:tableImageView];
    [tableImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).offset(40);
        make.left.right.equalTo(self.scrollView);
    }];
    
    [parentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableImageView.mas_bottom);
    }];
}

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
    [navTitle setText:self.title];
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
                  action:@selector(closeInfoView)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navButton];
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).offset(20);
        make.bottom.equalTo(self.navigationBar);
        make.width.equalTo(@54);
    }];
    
}

- (void)closeInfoView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
