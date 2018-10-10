//
// Created by Anders Hansen on 15/06/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "EventFooterView.h"
#import "HexColors.h"

@implementation EventFooterView

- (instancetype)init {
    self = [super init];

    if (self) {
        [self addSubviews];
        [self defineLayout];
    }

    return self;
}

- (void)addSubviews {
    self.imageView = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"flute_gray"]];
    self.titleLabel = [DefaultLabel init];
    self.titleLabel.textColor = [UIColor hx_colorWithHexString:@"97a7a7"];

    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}

- (void)defineLayout {
    [@[self.titleLabel, self.imageView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
    }];
}

@end
