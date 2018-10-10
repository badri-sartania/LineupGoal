//
// Created by Anders Hansen on 21/06/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "CenterTextCellView.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"

@implementation CenterTextCellView

- (id)init {
    self = [super init];
    if (self) {
        self.centerTextLabel = [DefaultLabel initWithBoldSystemFontSize:20 color:[UIColor primaryTextColor]];

        [self addSubview:self.centerTextLabel];

        [self.centerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.center.equalTo(self);
        }];
    }

    return self;
}


@end
