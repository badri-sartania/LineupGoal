//
// Created by Anders Borre Hansen on 01/09/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JGProgressHUD/JGProgressHUD.h>


@interface SpinnerHelper : NSObject
+ (JGProgressHUD *)JGProgressHUDLoadingSpinnerInView:(UIView *)view;
+ (JGProgressHUD *)JGProgressHUDSpinnerInView:(UIView *)view text:(NSString *)text;
@end