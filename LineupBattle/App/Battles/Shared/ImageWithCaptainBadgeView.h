//
// Created by Anders Borre Hansen on 04/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "DefaultImageView.h"
#import "BadgeView.h"


@interface ImageWithCaptainBadgeView : UIView
@property(nonatomic, strong) DefaultImageView *imageView;
@property(nonatomic, strong) UIImageView *badgeView;
@property(nonatomic, strong) BadgeView *lineupStatusView;

- (void)showBadge:(BOOL)showBadge;
- (void)setCaptain: (BOOL)isCaptain;
- (void)showLineupStatusWithColor:(UIColor *)color image:(UIImage *)image;
@end
