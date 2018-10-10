//
// Created by Anders Hansen on 16/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//


#import "Team.h"
#import "Configuration.h"
#import "ImageUrlGenerator.h"


@implementation Team

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectId": @"_id",
        @"name": @"name",
        @"shortName": @"shortName",
        @"country": @"country",
        @"competitions": @"competitions",
        @"players": @"players",
        @"matches": @"matches",
        @"logoToken": @"logoToken",
        @"form": @"form",
        @"coach": @"coach",
        @"years": @"years",
        @"active": @"active",
        @"position": @"position",
        @"prevPosition": @"prevPosition",
        @"points": @"points",
        @"mp": @"mp",
        @"goals": @"goals",
    };
}

- (NSString *)logoUrl {
    NSString *clubBasePath = [[Configuration instance] clubAssetsBaseUrl];
    return [ImageUrlGenerator urlGeneratorWithBaseUrl:clubBasePath token:[self.logoToken stringValue] objId:self.objectId size:@"60" ext:@".png"];
}

- (NSString *)logoThumbUrl {
    NSString *clubBasePath = [[Configuration instance] clubAssetsBaseUrl];
    return [ImageUrlGenerator urlGeneratorWithBaseUrl:clubBasePath token:[self.logoToken stringValue] objId:self.objectId size:@"30" ext:@".png"];
}

- (NSString *)yearString {
    if ([self.years isKindOfClass:[NSArray class]]) {
        if (self.years.count == 1) {
            return [self.years[0] stringValue];
        } else if (self.years.count == 2) {
            return [NSString stringWithFormat:@"%@ - %@", self.years[0], self.years[1]];
        }
    }

    return @"";
}

@end
