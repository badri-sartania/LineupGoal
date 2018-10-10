//
// Created by Anders Borre Hansen on 26/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
// http://www.if-not-true-then-false.com/2010/php-1st-2nd-3rd-4th-5th-6th-php-add-ordinal-number-suffix/
//

#import "NSNumber+OrdinalSuffix.h"


@implementation NSNumber (OrdinalSuffix)

- (NSString *)ordinalNumberSuffixString {
    NSInteger integer = [self integerValue];
    NSString *ending;
    if (![@[@11, @12, @13] containsObject:@(integer % 100)]) {
        switch (integer % 10) {
            // Handle 1st, 2nd, 3rd
            case 1:
                ending = @"st";
                break;
            case 2:
                ending = @"nd";
                break;
            case 3:
                ending = @"rd";
                break;
            default:
                ending = @"th";
                break;
        }
    } else {
        ending = @"th";
    }

    return [NSString stringWithFormat:@"%@%@", self, ending];
}

@end