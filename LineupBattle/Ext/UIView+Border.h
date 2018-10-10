//
// Created by Anders Hansen on 23/06/14.
// Copyright (c) 2014 e-conomic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Border)

- (CALayer *)addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset;
- (CALayer *)addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset;
- (CALayer *)addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset;
- (CALayer *)addLeftIndentedBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset;

// View border using constraints to stick to view along the bottom of a cell
- (UIView *)bottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset;
- (UIView *)topBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset;
@end