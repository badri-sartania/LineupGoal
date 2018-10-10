//
// Created by Anders Borre Hansen on 27/08/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "EmptyStateView.h"
#import "HexColors.h"

@implementation EmptyStateView

- (id)init {
    self = [super init];
    if (self) {
        self.headline = [DefaultLabel initWithSystemFontSize:20 color:[UIColor hx_colorWithHexString:@"999999"]];
        self.headline.textAlignment = NSTextAlignmentCenter;
        self.desc = [DefaultLabel init];
        self.desc.textAlignment = NSTextAlignmentCenter;
        self.desc.textColor = [UIColor hx_colorWithHexString:@"999999"];
        self.desc.numberOfLines = 0;

        [self addSubview:self.headline];
        [self addSubview:self.desc];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [@[self.headline, self.desc] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self).offset(-self.frame.size.width/4);
    }];

    [self.headline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];

    [self.desc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headline.mas_bottom).offset(10);
    }];

    [super layoutSubviews];
}

- (void)showEmptyStateScreen:(NSString *)headline description:(NSString *)desc {
    self.headline.text = headline;
    self.desc.text = desc;
    self.hidden = NO;
}

- (void)showEmptyStateScreen:(NSString *)headline {
    [self showEmptyStateScreen:headline description:@""];
}

- (void)hideEmptyStateScreen {
    self.hidden = YES;
}

@end