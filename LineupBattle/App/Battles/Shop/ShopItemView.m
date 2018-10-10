//
// Created by Anders Borre Hansen on 10/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "ShopItemView.h"
#import "DefaultLabel.h"
#import "CoinView.h"


@implementation ShopItemView

- (instancetype)initWithCoins:(NSInteger)coins image:(UIImage *)image imageXOffset:(NSInteger)offset {
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(offset);
            make.bottom.equalTo(self).offset(-95);
        }];

        CoinView *coinView = [[CoinView alloc] initWithCoins:coins];
        coinView.coinLabel.font = [UIFont boldSystemFontOfSize:18];

        [self addSubview:coinView];

        [coinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(30);
            make.height.equalTo(@22);
        }];
    }

    return self;
}

@end
