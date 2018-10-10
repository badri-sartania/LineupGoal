//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "CoinView.h"
#import "DefaultLabel.h"
#import "StyleKit.h"
#import "StyleKitView.h"
#import "HexColors.h"



@implementation CoinView {
//    StyleKitView *_coinStyleKitView;
    UIImageView *_coinImageView;
}

- (instancetype)initWithCoins:(NSInteger)coins {
    return [self initWithCoins:coins direction:CoinDirectionRight];
}

- (instancetype)initWithCoins:(NSInteger)coins direction:(CoinDirection)direction {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _coinImageView = [[UIImageView alloc] init];
        [_coinImageView setImage:[UIImage imageNamed:@"ic_bolt"]];
        
//        _coinStyleKitView = [[StyleKitView alloc] initWithStyleKitBlock:^(CGRect rect) {
//            [StyleKit drawCreditWithFrame:rect];
//        }];

        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _coinLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];

        [self setCoins:coins];

        [self addSubview:_coinImageView];
        [self addSubview:_coinLabel];

        if (direction == CoinDirectionRight) {
            [_coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self);
                make.width.equalTo(@8.8);
                make.height.equalTo(@13.2);
            }];

            [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_coinImageView.mas_right).offset(3);
            }];

            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_coinLabel);
            }];
        } else {
            [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self);
            }];
            [_coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(_coinLabel.mas_left).offset(-3);
                make.width.equalTo(@8.8);
                make.height.equalTo(@13.2);
//                make.size.equalTo(self.mas_height);
            }];

            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_coinImageView);
            }];
        }

    }

    return self;
}

- (instancetype)initWithBigCoins:(NSInteger)coins direction:(CoinDirection)direction {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _coinImageView = [[UIImageView alloc] init];
        [_coinImageView setImage:[UIImage imageNamed:@"ic_bolt_big"]];
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0f];
        _coinLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];
        
        [self setCoins:coins];
        
        [self addSubview:_coinImageView];
        [self addSubview:_coinLabel];
        
        if (direction == CoinDirectionRight) {
            [_coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self);
                make.width.equalTo(@17);
                make.height.equalTo(@24);
            }];
            
            [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_coinImageView.mas_right).offset(3);
            }];
            
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_coinLabel);
            }];
        } else {
            [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self);
            }];
            [_coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(_coinLabel.mas_left).offset(-3);
                make.width.equalTo(@17);
                make.height.equalTo(@24);
            }];
            
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_coinImageView);
            }];
        }
        
    }
    
    return self;
}

- (void)setCoins:(NSInteger)coins {
    _coinLabel.text = [NSString localizedStringWithFormat:@"%@", @(coins)];
}

- (void)changeCoinImage:(UIImage *)coinImage {
    if (coinImage != nil)
        [_coinImageView setImage:coinImage];
}

@end
