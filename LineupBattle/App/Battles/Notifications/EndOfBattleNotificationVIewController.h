//
// Created by Anders Borre Hansen on 26/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlurFullscreenViewController.h"


@interface EndOfBattleNotificationVIewController : BlurFullscreenViewController
- (id)initWithName:(NSString *)string kickOff:(NSDate *)off placement:(NSInteger)placement creditWon:(NSInteger)won xpGained:(NSInteger)gained;
@end
