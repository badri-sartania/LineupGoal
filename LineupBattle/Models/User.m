//
// Created by Anders Borre Hansen on 24/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "User.h"
#import "Player.h"
#import "Battle.h"
#import "LBMTLModel.h"
#import "Configuration.h"
#import "ImageUrlGenerator.h"


@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectId" : @"_id",
        @"name" : @"name",
        @"email" : @"email",
        @"country" : @"country",
        @"points" : @"points",
        @"current" : @"current",
        @"coins" : @"coins",
        @"wallet" : @"wallet",
        @"walletUpdatedAt": @"walletUpdatedAt",
        @"level" : @"level",
        @"xp" : @"xp",
        @"xpToNextLevel" : @"xpToNextLevel",
        @"won" : @"won",
        @"biggestWin" : @"biggestWin",
        @"win" : @"win",
        @"won" : @"won",
        @"pos" : @"pos",
        @"battles" : @"battles",
        @"players" : @"players",
        @"photoToken": @"photoToken",
        @"bestLineup": @"bestLineup",
        @"bestMonth": @"bestMonth",
        @"ultimateXI_points" : @"ultimateXI_points"
    };
}

+ (NSValueTransformer *)walletUpdatedAtJSONTransformer {
    return [self.class dateTransformer];
}

// Helpers
- (NSInteger)xpProgressionInPercentage {
    return (NSInteger)(([self.xp doubleValue] / [self.nextLevelXP integerValue])*100);
}

- (NSNumber *)nextLevelXP {
    return @([self.xp integerValue] + [self.xpToNextLevel integerValue]);
}

- (NSString *)profileImagePath:(NSInteger)size {
    if (!self.photoToken) return nil;
    return [ImageUrlGenerator urlGeneratorWithBaseUrl:[Configuration instance].usersAssetsBaseUrl token:[self.photoToken stringValue] objId:self.objectId size:[@(size) stringValue] ext:@".jpg"];
}

@end
