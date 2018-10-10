//
//  Leaderboard.m
//  LineupBattle
//
//  Created by Anders Borre Hansen on 01/12/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

#import "Leaderboard.h"

@implementation Leaderboard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name" : @"name",
        @"country" : @"country",
        @"total" : @"total",
        @"lineup" : @"lineup",
        @"prize" : @"prize",
        @"users" : @"users"
    };
}

+ (NSValueTransformer *)totalJSONTransformer {
    return LBMTLModel.usersJSONTransformer;
}

+ (NSValueTransformer *)lineupJSONTransformer {
    return LBMTLModel.usersJSONTransformer;
}

@end
