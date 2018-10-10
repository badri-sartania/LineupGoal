//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultLabel.h"

typedef NS_ENUM(NSInteger, CoinDirection) {
    CoinDirectionLeft,
    CoinDirectionRight
};

@interface CoinView : UIView
@property(nonatomic, strong) UILabel *coinLabel;

- (instancetype)initWithCoins:(NSInteger)coins;
- (instancetype)initWithCoins:(NSInteger)coins direction:(CoinDirection)direction;
- (instancetype)initWithBigCoins:(NSInteger)coins direction:(CoinDirection)direction;
- (void)setCoins:(NSInteger)coins;
- (void)changeCoinImage:(UIImage *)coinImage;
@end
