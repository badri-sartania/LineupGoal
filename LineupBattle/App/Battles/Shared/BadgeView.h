//
// Created by Anders Borre Hansen on 18/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultLabel.h"


@interface BadgeView : UIView

@property(nonatomic) float borderWidth;
@property(nonatomic, strong) UIColor *borderColor;
@property(nonatomic, strong) UIColor *color;
@property(nonatomic, strong) DefaultLabel *textLabel;
@property(nonatomic, strong) UIImageView *badgeImageView;
@property(nonatomic, strong) UIColor *badgeBackgroundColor;

- (instancetype)initWithColor:(UIColor *)color;
- (instancetype)initWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
- (instancetype)initWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)setImage:(UIImage *)image;
@end
