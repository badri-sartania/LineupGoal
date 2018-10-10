//
// Created by Anders Borre Hansen on 01/09/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "SpinnerHelper.h"


@implementation SpinnerHelper

+ (JGProgressHUD *)JGProgressHUDLoadingSpinnerInView:(UIView *)view {
    return [SpinnerHelper JGProgressHUDSpinnerInView:view text:@"Loading"];
}

+ (JGProgressHUD *)JGProgressHUDSpinnerInView:(UIView *)view text:(NSString *)text {
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.textLabel.text = text;
    hud.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    [hud showInView:view];
    hud.layer.zPosition = 2;

    return hud;
}
@end