//
// Created by Anders Borre Hansen on 28/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import "League.h"
#import "Match.h"
#import <YLMoment/YLMoment.h>

@implementation League

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name" : @"name",
        @"country" : @"country",
        @"matches" : @"matches",
    };
}

- (NSInteger)numberOfMatches {
    return self.matches.count;
}
@end
