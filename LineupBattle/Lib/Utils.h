//
// Created by Anders Hansen on 27/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


+ (NSString *)platform;

+ (NSString *)appVersion;

+ (BOOL)APNAlertsEnabled;

+ (UIUserNotificationType)remoteNotificationLevel;

+ (void)registerForAPN;

+ (NSDictionary *)sanitizeDictionary:(NSDictionary *)dictionary;

+ (CGFloat)screenHeight;

+ (CGFloat)screenWidth;

+ (NSString *)imageWithScreenWidthNamed:(NSString *)imageName;

+ (void)showConnectionErrorNotification;

+ (void)hideConnectionErrorNotification;

+ (NSString *)stringInMainBundleForKey:(NSString *)key;
@end
