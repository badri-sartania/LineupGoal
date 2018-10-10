//
// Created by Anders Borre Hansen on 08/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BoxLabelView : UIView
- (instancetype)initWithText:(NSString *)text backgroundColor:(UIColor *)color borderRadius:(CGFloat)radius;

- (void)setText:(NSString *)text;

- (void)setColor:(UIColor *)color;

+ (instancetype)initWithText:(NSString *)text backgroundColor:(UIColor *)color borderRadius:(CGFloat)radius;
@end
