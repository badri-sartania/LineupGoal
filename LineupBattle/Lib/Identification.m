//
// Created by Anders Hansen on 26/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Identification.h"
#import "Utils.h"
#import "HTTP.h"


@implementation Identification

+ (NSString *)deviceVendorId {
  NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
  return [Identification sanitizeUUID:[oNSUUID UUIDString]];
}

+ (NSString *)apnDeviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"APNDeviceToken"];
}

+ (NSString *)userId {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

    if (userId != nil) {
        return userId;
    } else {
        userId = [Identification generateUUID];

        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        return userId;
    }
}

+ (NSString *)generateUUID {
    return [Identification sanitizeUUID:[[NSUUID UUID] UUIDString]];
}

+ (NSString *)authenticationToken {
//    return @"b50bd9a313e048e08b771c9ba2fce9ab-125288326c5e4d188516eed6b40e9835";
    return[NSString stringWithFormat:@"%@-%@", [Identification userId], [Identification deviceVendorId]];
}

+ (NSString *)sanitizeUUID:(NSString *)UUID {
    return [[UUID stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

#pragma mark - APN
+ (BOOL)isAPNDisabled {
    UIUserNotificationType apnState = [Utils remoteNotificationLevel];

    BOOL alertsAllowed = apnState >= 4;
    BOOL dialogShown = [Identification APNDialogShown];

    return dialogShown && !alertsAllowed;
}

+ (BOOL)APNDialogShown {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"APNDialogShown"];
}

#pragma mark - User Name
+ (BOOL)hasSetUserName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSetUserName"];
}

+ (void)setUserNameAsSet {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSetUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
