//
// Created by Anders Borre Hansen on 27/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "CountryCodeHelper.h"


@implementation CountryCodeHelper

+ (NSString *)isoAlpha2ToAlpha3:(NSString *)code {
    return [self codeToValue:code fromFileName:@"alpha2ToAlpha3"];
}

+ (NSString *)fifaToIsoAlpha3:(NSString *)code {
    return [self codeToValue:code fromFileName:@"fifaToAlpha3"];
}

+ (NSString *)isoAlpha2CodeToName:(NSString *)code {
    NSString  *isoAlpha3Name = [CountryCodeHelper isoAlpha2ToAlpha3:code];
    return [CountryCodeHelper isoAlpha3CodeToName:isoAlpha3Name];
}

+ (NSString *)isoAlpha3CodeToName:(NSString *)code {
    return [CountryCodeHelper codeToValue:code fromFileName:@"alpha3ToName"];
}

+ (NSString *)fifaCodeToName:(NSString *)code {
    return [self codeToValue:code fromFileName:@"fifaToName"];
}

+ (NSString *)codeToValue:(NSString *)code fromFileName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];

    NSString *value = dictionary[code];

    if (!value) value = @"";

    return value;
}

@end
