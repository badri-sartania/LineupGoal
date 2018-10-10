//
// Created by Anders Borre Hansen on 11/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "MenuButtonWithBadge.h"
#import "CustomBadge.h"


@interface MenuButtonWithBadge ()
@property(nonatomic, strong) CustomBadge *badge;
@end

@implementation MenuButtonWithBadge

- (instancetype)init {
    self = [super init];
    if (self) {
        self.badge = [CustomBadge customBadgeWithString:@"0"];
        self.badge.userInteractionEnabled = NO;
        [self addSubview:self.badge];
        [self.badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.size.equalTo(@20);
        }];
        self.badge.hidden = YES;
    }

    return self;
}

- (void)setBadgeCounter:(NSInteger)count {
    self.badge.hidden = count <= 0;
    [self.badge autoBadgeSizeWithString:[@(count) stringValue]];
}

@end