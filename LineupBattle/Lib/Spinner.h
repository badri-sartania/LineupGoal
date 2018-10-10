//
// Created by Thomas Watson on 05/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Spinner : UIActivityIndicatorView
- (id)initWithSuperView:(UIView *)view;
+ (id)initWithSuperView:(UIView *)view;

- (id)initWithDefaultPositionAndWithSuperView:(UIView *)view;
+ (id)initWithDefaultPositionAndWithSuperView:(UIView *)view;
@end