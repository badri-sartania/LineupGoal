//
// Created by Anders Borre Hansen on 27/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CountryCodeFormat) {
    CountryCodeFormatFifa,
    CountryCodeFormatISO31661Alpha2,
    CountryCodeFormatISO31661Alpha3
};

@interface CountryCodeHelper : NSObject

+ (NSString *)isoAlpha2ToAlpha3:(NSString *)code;

+ (NSString *)fifaToIsoAlpha3:(NSString *)code;

+ (NSString *)isoAlpha2CodeToName:(NSString *)code;

+ (NSString *)isoAlpha3CodeToName:(NSString *)code;

+ (NSString *)fifaCodeToName:(NSString *)code;
@end
