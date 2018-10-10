//
// Created by Anders Borre Hansen on 28/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTPHelper : NSObject
+ (NSString *)applyQuery:(NSDictionary *)query toUrlString:(NSString *)url;

+ (NSDictionary *)applyAuthToDictionary:(NSDictionary *)query;

+ (RACScheduler *)backgroundScheduler;

+ (NSString *)userAgent;
@end