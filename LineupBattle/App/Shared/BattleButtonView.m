//
// Created by Anders Borre Hansen on 14/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <CustomBadge/CustomBadge.h>
#import "BattleButtonView.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"
#import "UIView+Border.h"
#import "HexColors.h"


@interface BattleButtonView ()
@property(nonatomic, strong) CustomBadge *inviteBadge;
@end

@implementation BattleButtonView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];

        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
        [arrowImageView setContentMode:UIViewContentModeScaleAspectFit];
        DefaultLabel *label = [DefaultLabel initWithText:title];
        label.font = [UIFont systemFontOfSize:17];
        label.numberOfLines = 0;

        label.textColor = [UIColor actionColor];

        self.inviteBadge = [CustomBadge customBadgeWithString:@"0"];
        self.inviteBadge.hidden = YES;

        [self addSubview:imageView];
        [self addSubview:label];
        [self addSubview:arrowImageView];
        [self addSubview:self.inviteBadge];

        [@[imageView, label, arrowImageView, self.inviteBadge] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.size.equalTo(@38);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(15);
        }];

        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.size.equalTo(@22);
        }];

        [self.inviteBadge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-30);
            make.size.equalTo(@20);
        }];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [self addBottomBorderWithColor:[UIColor hx_colorWithHexString:@"#D8D8D8"] width:1.f offset:0];
}

- (void)setInviteBadgeCount:(NSUInteger)count {
    self.inviteBadge.hidden = count == 0;
    [self.inviteBadge setBadgeText:[@(count) stringValue]];
}

@end
