//
// Created by Anders Borre Hansen on 26/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "NewLevelNotificationViewController.h"
#import "SCLButton.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "Utils.h"
#import "HexColors.h"

static NSString *_level;

@implementation NewLevelNotificationViewController

- (instancetype)initWithLevel:(NSInteger)level {
    self = [super init];
    if (self) {
        _level = [@(level) stringValue];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    DefaultImageView *arrowImageView = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"level_up_arrow_up"]];
    [self.view addSubview:arrowImageView];

    DefaultLabel *levelUpLabel = [DefaultLabel initWithText:@"LEVEL UP"];
    [levelUpLabel boldSystemFontSize:38 color:[UIColor hx_colorWithHexString:@"E2EC00"]];
    [self.view addSubview:levelUpLabel];

    DefaultLabel *reputationLabel = [DefaultLabel initWithText:@"Your reputation is growing"];
    [reputationLabel systemFontSize:20 color:[UIColor whiteColor]];
    [self.view addSubview:reputationLabel];

    DefaultImageView *levelImageView = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"level_up_stars"]];
    [self.view addSubview:levelImageView];

    DefaultLabel *levelLabel = [DefaultLabel initWithText:_level];
    [levelLabel boldSystemFontSize:80 color:[UIColor whiteColor]];
    levelLabel.adjustsFontSizeToFitWidth = YES;
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.view addSubview:levelLabel];

    DefaultLabel *newLevelLabel = [DefaultLabel initWithText:@"New level"];
    [newLevelLabel systemFontSize:18 color:[UIColor whiteColor]];
    [self.view addSubview:newLevelLabel];

    SCLButton *button = [[SCLButton alloc] init];
    [button setDefaultBackgroundColor:[UIColor hx_colorWithHexString:@"00a42d"]];
    [button setTitle:@"Sweet!" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    button.tintColor = [UIColor hx_colorWithHexString:@"f3be25"];
    [self.view addSubview:button];

    [@[arrowImageView, levelImageView, levelUpLabel, reputationLabel, levelLabel, newLevelLabel, button] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    }];

    [levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(40);
    }];

    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(levelUpLabel.mas_top).offset(-8);
    }];

    [levelUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(reputationLabel.mas_top).offset(-2);
    }];

    [reputationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(levelImageView.mas_top).offset(-26);
    }];

    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(levelImageView).offset(17);
        make.width.equalTo(@70);
    }];

    [newLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelImageView.mas_bottom).offset(5);
    }];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLevelLabel.mas_bottom).offset(30);
        make.height.equalTo(@42);
        make.width.equalTo(@142);
    }];
}

@end
