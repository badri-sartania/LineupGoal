//
// Created by Anders Borre Hansen on 18/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "ImageViewWithBadge.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"


@implementation ImageViewWithBadge

- (instancetype)initWithBadgeScale:(CGFloat)scale {
    self = [super init];
    if (self) {
        self.imageView = [[DefaultImageView alloc] init];
        [self setImageName:@"ic_profile_user"];
        [self addSubview:self.imageView];

        self.badgeView = [[BadgeView alloc] initWithColor:[UIColor actionColor]];
        [self addSubview:self.badgeView];

        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(28*scale));
            make.right.equalTo(self).offset(2);
            make.bottom.equalTo(self).offset(2);
        }];
    }

    return self;
}

- (void)setBadgeText:(NSString *)badgeString {
    if ([badgeString isEqualToString:@""]){
        self.badgeView.hidden = YES;
    } else {
        self.badgeView.textLabel.text = badgeString;
    }
}

- (void)setPosBadgeText:(NSString *)posString
                bgColor:(UIColor *)bgColor
       badgeBorderWidth:(CGFloat)borderWidth
       badgeBorderColor:(UIColor *)borderColor
              badgeSize:(NSUInteger)badgeSize
               textSize:(NSUInteger)badgeText {
    
    self.badgeView.hidden = YES;
    if (![posString isEqualToString:@""]){
        BadgeView *badge = [[BadgeView alloc] initWithColor:bgColor borderWidth:borderWidth borderColor:borderColor];
        badge.textLabel.font = [badge.textLabel.font fontWithSize:badgeText];
        badge.textLabel.text = posString;
        [self addSubview:badge];
        
        [badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(badgeSize));
            make.right.equalTo(self).offset(6);
            make.bottom.equalTo(self).offset(3);
        }];
    }
}

- (void)setImageName:(NSString *)string {
    if (string && ![string isEqualToString:@""]) {
        self.imageView.image = [UIImage imageNamed:string];
    }
}
@end
