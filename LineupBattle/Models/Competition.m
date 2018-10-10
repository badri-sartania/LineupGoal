//
// Created by Anders Hansen on 16/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Competition.h"
#import "ImageUrlGenerator.h"
#import "Configuration.h"

@implementation Competition

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectId" : @"_id",
        @"name" : @"name",
        @"country" : @"country",
        @"bannerToken" : @"bannerToken",
        @"players": @"players",
        @"groupings": @"groupings",
        @"table": @"table"
    };
}

+ (NSValueTransformer *)groupingsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Grouping class]];
}

+ (NSValueTransformer *)tableJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Grouping class]];
}

- (NSString *)banner {
    NSString *competitionBasePath = [[Configuration instance] competitionAssetsBaseUrl];
    return [ImageUrlGenerator urlGeneratorWithBaseUrl:competitionBasePath token:self.bannerToken objId:self.objectId size:@"320x107" ext:@".png"];
}

@end
