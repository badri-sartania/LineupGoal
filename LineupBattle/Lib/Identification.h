//
// Created by Anders Hansen on 26/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Identification : NSObject
+ (NSString *)deviceVendorId;
+ (NSString *)apnDeviceToken;
+ (NSString *)userId;
+ (NSString *)generateUUID;
+ (NSString *)authenticationToken;
+ (NSString *)sanitizeUUID:(NSString *)UUID;

+ (BOOL)isAPNDisabled;
+ (BOOL)APNDialogShown;

+ (BOOL)hasSetUserName;
+ (void)setUserNameAsSet;
@end