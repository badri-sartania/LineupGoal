//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "LBMTLModel.h"


@interface BattleTemplate : LBMTLModel
@property(nonatomic, copy, readonly) NSString *objectId;
@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, strong, readonly) NSDate *startDate;
@property(nonatomic, strong, readonly) NSDate *endDate;
@property(nonatomic, strong, readonly) NSArray *matches;
@property(nonatomic, strong, readonly) NSArray *teams;
@property(nonatomic, strong, readonly) NSArray *formation;
@property(nonatomic, copy, readonly) NSString *country;
@property(nonatomic, copy, readonly) NSString *groupingHeader;
@property(nonatomic, strong, readonly) NSNumber *perTeam;
@property(nonatomic, strong, readonly) NSNumber *entry;
@property(nonatomic, strong, readonly) NSNumber *maxUsers;
@property(nonatomic, strong, readonly) NSNumber *joined;
@property(nonatomic, strong) NSNumber *reminder;
@end
