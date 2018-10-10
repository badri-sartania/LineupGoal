//
// Created by Anders Borre Hansen on 24/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "Prize.h"

@implementation Prize

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"images" : @"images",
        @"prizeType" : @"prizeType",
        @"bolts" : @"bolts",
        @"position" : @"position",
        @"link" : @"link",
    };
}

+ (id)customClassWithProperties:(NSDictionary *)properties {
    return [[self alloc] initWithProperties:properties];
}

- (id)initWithProperties:(NSDictionary *)properties {
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

+ (NSValueTransformer *)totalJSONTransformer {
    return LBMTLModel.usersJSONTransformer;
}

+ (NSValueTransformer *)lineupJSONTransformer {
    return LBMTLModel.usersJSONTransformer;
}

@end
