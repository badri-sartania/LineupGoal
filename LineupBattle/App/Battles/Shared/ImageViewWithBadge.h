//
// Created by Anders Borre Hansen on 18/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "BadgeView.h"
#import "DefaultImageView.h"


@interface ImageViewWithBadge : UIView
@property (nonatomic, strong) DefaultImageView *imageView;
@property (nonatomic, strong) BadgeView *badgeView;
@property (nonatomic) CGFloat badgeScale;

- (instancetype)initWithBadgeScale:(CGFloat)scale;
- (void)setBadgeText:(NSString *)badgeString;
- (void)setImageName:(NSString *)string;
- (void)setPosBadgeText:(NSString *)posString
                bgColor:(UIColor *)bgColor
       badgeBorderWidth:(CGFloat)borderWidth
       badgeBorderColor:(UIColor *)borderColor
              badgeSize:(NSUInteger)badgeSize
               textSize:(NSUInteger)badgeText;
@end
