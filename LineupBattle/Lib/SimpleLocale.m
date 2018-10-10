//
// Created by Anders Borre Hansen on 29/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "SimpleLocale.h"


@implementation SimpleLocale

+ (NSString *)USAlternative:(NSString *)usString forString:(NSString *)string {
    return [SimpleLocale isUS] ? usString : string;
}

+ (BOOL)isUS {
    return [[[NSLocale currentLocale] localeIdentifier] rangeOfString:@"_US"].location != NSNotFound;
}

@end
