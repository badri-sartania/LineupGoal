//
// Created by Anders Hansen on 16/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "LBMTLModel.h"
#import "Grouping.h"


@interface Competition : LBMTLModel
@property(nonatomic, strong) NSString *objectId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSString *banner;
@property(nonatomic, strong) NSString *bannerToken;
@property(nonatomic, strong) NSNumber *sortOrder;
@property(nonatomic, strong) NSArray *groupings;
@property(nonatomic, strong) NSArray *matches;
@property(nonatomic, strong) NSArray *players;
@property(nonatomic, strong) Grouping *table;
@property(assign) BOOL popular;
@end