//
// Created by Anders Borre Hansen on 17/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BattleNotificationControl) {
    BattleNotificationControlAllMatches,
    BattleNotificationControlLineupMatches,
    BattleNotificationControlNoMatches
};

@interface APNHelper : NSObject
+ (void)doubleConfirmationWithTitle:(NSString *)title message:(NSString *)message accepted:(void (^)())success;

+ (void)doubleConfirmationWithTitle:(NSString *)title message:(NSString *)message accepted:(void (^)())success declined:(void (^)())declined;

+ (void)showBattleNotificationControlsFor:(id)sself type:(void (^) (BattleNotificationControl))state title:(NSString *)title message:(NSString *)message;
@end
