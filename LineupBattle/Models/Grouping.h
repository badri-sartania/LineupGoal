//
// Created by Anders Hansen on 25/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "LBMTLModel.h"

@class Competition;


@interface Grouping : LBMTLModel
@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, copy, readonly) NSString *type;
@property(nonatomic, strong, readonly) NSArray *teams;
@property(nonatomic, strong, readonly) NSArray *positionTypes;
@property(nonatomic, strong) Competition *competition;

- (NSString *)colorByType:(NSNumber *)type;
@end
