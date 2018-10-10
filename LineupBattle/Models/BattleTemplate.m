//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//


#import "LBMTLModel.h"
#import "BattleTemplate.h"


@implementation BattleTemplate

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    NSDictionary *defaults = @{
      @"maxUsers" : @(12)
    };

    dictionaryValue = [defaults mtl_dictionaryByAddingEntriesFromDictionary:dictionaryValue];
    return [super initWithDictionary:dictionaryValue error:error];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectId": @"_id",
        @"name": @"name",
        @"startDate": @"start",
        @"endDate": @"end",
        @"entry": @"entry",
        @"country": @"country",
        @"groupingHeader": @"groupingHeader",
        @"perTeam": @"perTeam",
        @"formation": @"formation",
        @"teams": @"teams",
        @"matches": @"matches",
        @"maxUsers": @"maxUsers",
        @"reminder": @"reminder",
        @"joined": @"joined"
    };
}

+ (NSValueTransformer *)startDateJSONTransformer {
    return [self.class dateTransformer];
}

+ (NSValueTransformer *)endDateJSONTransformer {
    return [self.class dateTransformer];
}

@end
