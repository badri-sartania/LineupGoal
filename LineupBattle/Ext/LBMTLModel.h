//
// Created by Anders Borre Hansen on 27/07/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "Mantle.h"


@interface LBMTLModel : MTLModel <MTLJSONSerializing>
+ (NSValueTransformer *)teamsJSONTransformer;

+ (NSValueTransformer *)matchesJSONTransformer;

+ (NSValueTransformer *)playersJSONTransformer;

+ (NSValueTransformer *)usersJSONTransformer;

+ (NSValueTransformer *)dateTransformer;
+ (NSDateFormatter *)dateFormatter;
+ (NSValueTransformer *)playerJSONTransformer;

+ (NSValueTransformer *)competitionJSONTransformer;

+ (NSValueTransformer *)templateJSONTransformer;

+ (NSValueTransformer *)teamJSONTransformer;

+ (NSArray *)arrayTransformer:(NSArray *)array;
+ (instancetype)dictionaryTransformer:(NSDictionary *)dic;
@end
