//
// Created by Anders Hansen on 27/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Utils.h"
#include <sys/sysctl.h>
#import "UIScreen+Util.h"


@implementation Utils

+ (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *)appVersion {
    NSMutableArray *versionParts = [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."] mutableCopy];
    if ([versionParts count] == 2)
        [versionParts addObject:@"0"];
    [versionParts addObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];

    return [versionParts componentsJoinedByString:@"."];
}

+ (BOOL)APNAlertsEnabled {
    return [self remoteNotificationLevel] >= 4;
}

+ (UIUserNotificationType)remoteNotificationLevel {
    return [[UIApplication sharedApplication] currentUserNotificationSettings].types;
}

+ (void)registerForAPN {

    // Register for push notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"APNDialogShown"];
}

+ (NSDictionary *)sanitizeDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *mutableDictionary;
    if ([dictionary isMemberOfClass:[NSMutableDictionary class]])
        mutableDictionary = (NSMutableDictionary *) dictionary;
    else
        mutableDictionary = [dictionary mutableCopy];

    NSNull *null = [NSNull null];
    NSArray *keys = [mutableDictionary allKeys];
    for (id key in keys) {
        id val = mutableDictionary[key];
        if (val == null) // NSNull is a singleton so we can use the faster == instead of isKindOfClass:
            [mutableDictionary removeObjectForKey:key];
        else if ([val isKindOfClass:[NSDictionary class]])
            mutableDictionary[key] = [self sanitizeDictionary:val];
    }

    if ([dictionary isMemberOfClass:[NSMutableDictionary class]])
        return mutableDictionary;
    else
        return [[NSDictionary alloc] initWithDictionary:mutableDictionary];
}

+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (NSString *)imageWithScreenWidthNamed:(NSString *)imageName {
    return [NSString stringWithFormat:@"%@%.2f", imageName, [Utils screenWidth]];
}

// This call notifications observers in DefaultNavigationController
+ (void)showConnectionErrorNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoInternet" object:self userInfo:@{
        @"message": @"Network error: Check your connection"
    }];
}

+ (void)hideConnectionErrorNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InternetAvailable" object:self];
}

+ (NSString *)stringInMainBundleForKey:(NSString *)key {
	NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString* string = [infoDict objectForKey:key];
	
	return string;
}

@end
