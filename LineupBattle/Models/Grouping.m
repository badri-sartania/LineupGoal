//
// Created by Anders Hansen on 25/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "Grouping.h"
#import "Competition.h"


@implementation Grouping

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"teams" : @"teams",
        @"competition" : @"competition",
        @"name" : @"name",
        @"type" : @"type",
        @"positionTypes" : @"positionTypes"
    };
}

- (NSString *)colorByType:(NSNumber *)type {
    if (type) {
        NSDictionary *positionType = [self.positionTypes bk_match:^BOOL(NSDictionary *position) {
            return [position[@"id"] integerValue] == [type integerValue];
        }];

        return [NSString stringWithFormat:@"#%@", positionType[@"rgb"]];
    }

    return nil;
}

@end