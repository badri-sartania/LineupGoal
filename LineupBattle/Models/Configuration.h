//
// Created by Anders Hansen on 28/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Configuration : NSObject
@property (nonatomic, copy, readonly) NSString *apiBaseUrl;
@property (nonatomic, copy, readonly) NSString *playerAssetsBaseUrl;
@property (nonatomic, copy, readonly) NSString *clubAssetsBaseUrl;
@property (nonatomic, copy, readonly) NSString *competitionAssetsBaseUrl;
@property (nonatomic, copy, readonly) NSString *usersAssetsBaseUrl;

+ (Configuration *)instance;

+ (void)clearConfigurationIfAppUpdated;

- (void)updateConfiguration:(NSDictionary *)config;

@end