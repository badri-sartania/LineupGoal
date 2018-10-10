//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "CoinDescriptionView.h"
#import "CoinView.h"
#import "DefaultLabel.h"


@implementation CoinDescriptionView {
    DefaultLabel *_descriptionLabel;
    CoinView *_coinView;
}

- (instancetype)initWithDescription:(NSString *)description coins:(NSInteger)coins {
    self = [super init];

    if (self) {
        _descriptionLabel =  [DefaultLabel initWithText:description];
        _coinView = [[CoinView alloc] initWithCoins:coins];

        [self addSubview:_descriptionLabel];
        [self addSubview:_coinView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat labelWidth = _descriptionLabel.intrinsicContentSize.width;

    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(@(labelWidth));
    }];

    [_coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_descriptionLabel.mas_right).offset(3.f);
    }];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_coinView);
    }];
    
    [super layoutSubviews];
}

- (void)setCoins:(NSInteger)coins {
    [_coinView setCoins:coins];
}

@end