//
// Created by Anders Borre Hansen on 24/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "LBMTLModel.h"


@interface Prize : LBMTLModel
@property(nonatomic, copy, readonly) NSString *prizeType;
@property(nonatomic, copy, readonly) NSString *bolts;
@property(nonatomic, copy, readonly) NSString *position;
@property(nonatomic, copy, readonly) NSString *link;
@property(nonatomic, strong, readonly) NSArray *images;

+ (id)customClassWithProperties:(NSDictionary *)properties;

@end
