//
// Created by Anders Borre Hansen on 04/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "ImageWithCaptainBadgeView.h"


@implementation ImageWithCaptainBadgeView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageView = [[DefaultImageView alloc] init];
        [self addSubview:self.imageView];

        self.badgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_captain_placeholder"]];
        [self.badgeView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.badgeView];

        self.lineupStatusView = [[BadgeView alloc] initWithColor:[UIColor redColor] borderWidth:1.5f];
        [self.lineupStatusView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.lineupStatusView];
        self.lineupStatusView.hidden = YES;

        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@29);
            make.right.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(5);
        }];
        
        [self.lineupStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@20);
            make.left.equalTo(self).offset(-self.imageView.frame.size.width / 3);
            make.top.equalTo(self);
        }];
    }

    return self;
}

- (void)showBadge:(BOOL)showBadge {
    self.badgeView.hidden = !showBadge;
}

- (void)setCaptain: (BOOL)isCaptain {
    if (isCaptain) {
        [self.badgeView setImage:[UIImage imageNamed:@"ic_captain"]];
    } else {
        [self.badgeView setImage:[UIImage imageNamed:@"ic_captain_placeholder"]];
    }
}

- (void)showLineupStatusWithColor:(UIColor *)color image:(UIImage *)image {
    self.lineupStatusView.hidden = !color || !image;
    [self.lineupStatusView setBadgeBackgroundColor:color];
    [self.lineupStatusView setImage:image];
    
    // MARK-TEST
//    if (image == nil) {
//        self.lineupStatusView.hidden = NO;
//        [self.lineupStatusView setImage:[UIImage imageNamed:@"ic_in_lineup"]];
//    }
}

@end
