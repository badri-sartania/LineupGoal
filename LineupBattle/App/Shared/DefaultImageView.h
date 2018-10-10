//
// Created by Anders Hansen on 13/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DefaultImageView : UIImageView
- (void)circleWithBorder:(UIColor *)color diameter:(CGFloat)diameter;

- (void)circleWithBorder:(UIColor *)color diameter:(CGFloat)diameter borderWidth:(CGFloat)borderWidth;

- (void)loadImageWithUrlString:(NSString *)urlString placeholder:(NSString *)placeholder;

- (void)loadImageWithUrlString:(NSString *)urlString placeholder:(NSString *)placeholder success:(void (^)())success failure:(void (^)())failure;
@end