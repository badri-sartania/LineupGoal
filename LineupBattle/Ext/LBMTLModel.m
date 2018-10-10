//
// Created by Anders Borre Hansen on 27/07/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "CLSLogging.h"
#import "LBMTLModel.h"
#import "Match.h"
#import "Player.h"
#import "User.h"
#import "Team.h"
#import "BattleTemplate.h"
#import "Competition.h"
#import "Battle.h"


@implementation LBMTLModel

// Convinient
+ (instancetype)dictionaryTransformer:(NSDictionary *)dic {
    NSError *error = nil;

    id test = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:dic error:&error];

    if (error) {
        CLS_LOG(@"%@", [error description]);
    }

    return test;
}

+ (NSArray *)arrayTransformer:(NSArray *)array {
    NSError *error = nil;
    NSArray *classa = [MTLJSONAdapter modelsOfClass:self.class fromJSONArray:array error:&error];

    if (error) {
        CLS_LOG(@"%@", [error description]);
    }


    return classa;
}

// Singular
+ (NSValueTransformer *)templateJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:BattleTemplate.class];
}

+ (NSValueTransformer *)teamJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Team.class];
}

+ (NSValueTransformer *)playerJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Player.class];
}

+ (NSValueTransformer *)competitionJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Competition.class];
}


// Array
+ (NSValueTransformer *)careerJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Team class]];
}

+ (NSValueTransformer *)teamsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Team class]];
}

+ (NSValueTransformer *)matchesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Match class]];
}

+ (NSValueTransformer *)battlesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Battle class]];
}

+ (NSValueTransformer *)playersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Player class]];
}

+ (NSValueTransformer *)usersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)competitionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Competition class]];
}


// Dates
+ (NSValueTransformer *)dateTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id (NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[[self class] dateFormatter] dateFromString:dateString];
    }                                           reverseBlock:^id (NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[[self class] dateFormatter] stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];

    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}


@end
