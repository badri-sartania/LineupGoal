//
// Created by Anders Hansen on 25/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "LBMTLModel.h"

@interface ShopItem : LBMTLModel
@property(nonatomic, copy, readonly) NSString *image;
@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, copy, readonly) NSString *price;
@property(nonatomic, copy, readonly) NSString *amount;
@property(nonatomic, strong, readonly) NSArray *boltPrice;
@end
