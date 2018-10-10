//
//
// Created by Anders Borre Hansen on 23/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import "Player.h"
#import "ImageUrlGenerator.h"
#import "HexColors.h"


@implementation Player

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectId" : @"_id",
        @"name" : @"name",
        @"position" : @"position",
        @"fullName" : @"fullName",
        @"photoToken" : @"photoToken",
        @"nationality" : @"nationality",
        @"fieldIndex": @"fieldIndex",
        @"teams" : @"teams",
        @"matches" : @"matches",
        @"trophies" : @"trophies",
        @"career" : @"career",
        @"stats" : @"stats",
        @"dob" : @"dob",
        @"team" : @"team",
        @"lineupStatus": @"lineupStatus",
        @"captain": @"captain"
    };
}

+ (NSValueTransformer *)dobJSONTransformer {
    return [self.class dateTransformer];
}

// Matches is a special kind that only holds simplified matches
+ (NSValueTransformer *)matchesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        return obj;
    } reverseBlock:^id(id obj, BOOL *success, NSError *__autoreleasing *error) {
        return obj;
    }];
}

+ (Player *)initEmptyWithPosition:(NSString *)position {
    return [Player dictionaryTransformer:@{
       @"position": position,
       @"name": position
    }];
}

+ (id)initWithId:(NSString *)ID {
    return [Player dictionaryTransformer:@{
                                           @"_id": ID
                                           }];
}

+ (NSString *)positionName:(NSString *)position {
    NSDictionary *positions = @{
        @"gk": @"Goalkeeper",
        @"df": @"Defender",
        @"mf": @"Midfielder",
        @"fw": @"Forward"
    };

    return positions[position];
}

- (NSString *)positionName {
    return [Player positionName:self.position];
}

- (UIImage *)lineupStatusImage {
    if ([self.lineupStatus isEqualToString:@"on-field"]) return [UIImage imageNamed:@"lineupStatusCheck"];
    if ([self.lineupStatus isEqualToString:@"not-playing"]) return [UIImage imageNamed:@"lineupStatusNotPlaying"];
    if ([self.lineupStatus isEqualToString:@"substitute"]) return [UIImage imageNamed:@"lineupStatusSubstitude"];
    
    return nil;
}

- (NSString *)photoImageUrlString:(NSString *)size {
    if (!self.photoToken) return nil;
    return [ImageUrlGenerator playerPhotoImageUrlStringBySize:size photoToken:[self.photoToken stringValue] objectId:self.objectId];
}

- (UIColor *)lineupStatusColor {
    if ([self.lineupStatus isEqualToString:@"on-field"]) return [UIColor hx_colorWithHexString:@"1d952b"];
    if ([self.lineupStatus isEqualToString:@"not-playing"]) return [UIColor hx_colorWithHexString:@"e74c3c"];
    if ([self.lineupStatus isEqualToString:@"substitute"]) return [UIColor hx_colorWithHexString:@"f1c40f"];

    return [UIColor hx_colorWithHexString:@"1d952b"];
}

@end
