//
// Created by Anders Hansen on 16/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "LBMTLModel.h"


@interface Team : LBMTLModel
@property(nonatomic, copy, readonly) NSString *objectId;
@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, copy, readonly) NSString *shortName;
@property(nonatomic, copy, readonly) NSString *country;
@property(nonatomic, strong, readonly) NSNumber *logoToken;
@property(nonatomic, strong, readonly) NSNumber *type;
@property(nonatomic, strong, readonly) NSArray *competitions;
@property(nonatomic, strong, readonly) NSArray *players;
@property(nonatomic, strong, readonly) NSArray *form;
@property(nonatomic, strong, readonly) NSArray *matches;
@property(nonatomic, strong, readonly) NSDictionary *lastGoal;
@property(nonatomic, strong, readonly) NSDictionary *coach;

// Stats
@property(nonatomic, strong, readonly) NSNumber *mp;
@property(nonatomic, strong, readonly) NSNumber *points;
@property(nonatomic, strong, readonly) NSDictionary *goals;
@property(nonatomic, strong, readonly) NSNumber *position;
@property(nonatomic, strong, readonly) NSNumber *prevPosition;

// Career
@property(nonatomic) BOOL active;
@property(nonatomic, strong) NSArray *years;

- (NSString *)logoUrl;

- (NSString *)logoThumbUrl;

- (NSString *)yearString;
@end
