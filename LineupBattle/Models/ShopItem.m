//
// Created by Anders Hansen on 25/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "ShopItem.h"


@implementation ShopItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"image" : @"image",
        @"name" : @"name",
        @"price" : @"price",
        @"amount" : @"amount",
        @"boltPrice" : @"boltPrice",
    };
}
@end
