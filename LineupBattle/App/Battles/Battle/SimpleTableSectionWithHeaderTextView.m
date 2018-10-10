//
// Created by Anders Borre Hansen on 12/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "SimpleTableSectionWithHeaderTextView.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"


@implementation SimpleTableSectionWithHeaderTextView

- (instancetype)initWithFrame:(CGRect)rect text:(NSString *)text {
    self = [super initWithFrame:rect];
    if (self) {
        DefaultLabel *label = [DefaultLabel initWithText:text];
        label.textColor = [UIColor darkGrayTextColor];

        [self addSubview:label];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-13.f);
        }];
    }

    return self;
}


@end
