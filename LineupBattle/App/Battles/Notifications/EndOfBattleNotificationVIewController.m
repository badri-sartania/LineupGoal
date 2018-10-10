//
// Created by Anders Borre Hansen on 26/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "EndOfBattleNotificationVIewController.h"
#import "SCLButton.h"
#import <YLMoment/YLMoment.h>
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "Utils.h"
#import "CoinView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"


@implementation EndOfBattleNotificationVIewController {
    NSString *_name;
    NSDate *_kickOff;
    NSInteger _placement;
    NSInteger _creditWon;
    NSInteger _gainedXp;
}


- (id)initWithName:(NSString *)name kickOff:(NSDate *)kickOff placement:(NSInteger)placement creditWon:(NSInteger)won xpGained:(NSInteger)gained {
    self = [super init];

    if (self) {
        _name = name;
        _kickOff = kickOff;
        _placement = placement;
        _creditWon = won;
        _gainedXp = gained;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    DefaultImageView *swordImageView = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"congrats_fight"]];
    [self.view addSubview:swordImageView];

    DefaultLabel *nameLabel = [DefaultLabel initWithText:[_name capitalizedString]];
    [nameLabel boldSystemFontSize:29 color:[UIColor actionColor]];
    [self.view addSubview:nameLabel];

    DefaultLabel *kickOffLabel = [DefaultLabel initWithText:[[YLMoment momentWithDate:_kickOff] fromNow]];
    [kickOffLabel systemFontSize:16 color:[UIColor whiteColor]];
    [self.view addSubview:kickOffLabel];

    DefaultLabel *placementLabel = [DefaultLabel init];
    placementLabel.textColor = [UIColor hx_colorWithHexString:@"#e7e41c"];
    placementLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightLight];
    NSString *placementText = [NSString stringWithFormat:@"%lird place", (long)_placement];
    NSMutableAttributedString *placeAttriText = [[NSMutableAttributedString alloc] initWithString:placementText];
    [placeAttriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 weight:UIFontWeightBold] range:[placementText rangeOfString:[NSString stringWithFormat:@"%lird",(long)_placement]]];
    placementLabel.attributedText = placeAttriText;
    [self.view addSubview:placementLabel];

    CoinView *creditView = [[CoinView alloc] initWithCoins:_creditWon];
    creditView.coinLabel.font = [UIFont systemFontOfSize:38 weight:UIFontWeightHeavy];
    [self.view addSubview:creditView];

    DefaultLabel *xpLabel = [DefaultLabel init];
    xpLabel.textColor = [UIColor whiteColor];
    xpLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBlack];
    NSString *xpText = [NSString stringWithFormat:@"XP %li", (long)_gainedXp];
    NSMutableAttributedString *xpAttriText = [[NSMutableAttributedString alloc] initWithString:xpText];
    [xpAttriText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:26] range:NSMakeRange(0, 2)];
    [xpAttriText addAttribute:NSForegroundColorAttributeName value:[UIColor actionColor] range:NSMakeRange(0, 2)];
    xpLabel.attributedText = xpAttriText;
    [self.view addSubview:xpLabel];

    SCLButton *button = [[SCLButton alloc] init];
    [button setDefaultBackgroundColor:[UIColor hx_colorWithHexString:@"00a42d"]];
    [button setTitle:@"Got It" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    button.tintColor = [UIColor hx_colorWithHexString:@"f3be25"];
    [self.view addSubview:button];

    DefaultLabel *winningLabel = [DefaultLabel initWithText:@"Your winnings are added to your profile"];
    [winningLabel systemFontSize:12 color:[UIColor whiteColor]];
    [self.view addSubview:winningLabel];


    [@[swordImageView, nameLabel, kickOffLabel, placementLabel, creditView, xpLabel, button, winningLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    }];


    [placementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
    }];

    // Top
    [swordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nameLabel.mas_top).offset(-14);
    }];

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(kickOffLabel.mas_top).offset(-1);
    }];

    [kickOffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(placementLabel.mas_top).offset(-34);
    }];

    // Bottom
    [creditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placementLabel.mas_bottom).offset(12);
        make.height.equalTo(@35);
    }];

    [xpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(creditView.mas_bottom).offset(10);
    }];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xpLabel.mas_bottom).offset(42);
        make.height.equalTo(@42);
        make.width.equalTo(@142);
    }];

    [winningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(13);

    }];
}
@end
