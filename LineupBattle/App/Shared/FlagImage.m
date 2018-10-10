//
// Created by Anders Borre Hansen on 27/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "FlagImage.h"
#import "CountryCodeHelper.h"


@implementation FlagImage

+ (UIImage *)flagWithCode:(NSString *)code countryCodeFormat:(CountryCodeFormat)countryCodeFormat {
    NSString *countryCode = code;

    if (!countryCode) [FlagImage imageWithFallback:@"UNK"];

    // Country should be ISO alpha 3
    switch (countryCodeFormat) {
        case CountryCodeFormatFifa:
            countryCode = [CountryCodeHelper fifaToIsoAlpha3:code];
            break;
        case CountryCodeFormatISO31661Alpha2:
            countryCode = [CountryCodeHelper isoAlpha2ToAlpha3:code];
            break;
        default: break;
    }

    return [FlagImage imageWithFallback:countryCode];
}

+ (UIImage *)imageWithFallback:(NSString *)code {
    if ([code isEqualToString:@""]) code = @"UNK";
    return [UIImage imageNamed:code];
}
@end
