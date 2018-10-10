//
// Created by Anders Borre Hansen on 23/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "LBMTLModel.h"
#import "Team.h"
#import <UIKit/UIKit.h>

@interface Player : LBMTLModel 
@property(nonatomic, copy, readonly)   NSString *objectId;
@property(nonatomic, copy, readonly)   NSString *name;
@property(nonatomic, copy, readonly)   NSString *position;
@property(nonatomic, copy, readonly)   NSString *fullName;
@property(nonatomic, copy, readonly)   NSString *nationality;
@property(nonatomic, copy, readonly)   NSString *lineupStatus;
@property(nonatomic, strong, readonly) NSNumber *shirt;
@property(nonatomic, strong, readonly) NSNumber *photoToken;
@property(nonatomic, strong, readonly) NSArray *teams;
@property(nonatomic, strong, readonly) NSArray *matches;
@property(nonatomic, strong, readonly) NSArray *trophies;
@property(nonatomic, strong, readonly) NSArray *career;
@property(nonatomic, strong, readonly) NSDictionary *stats;
@property(nonatomic, strong, readonly) NSDate *dob;

@property(nonatomic, strong) Team *team;
@property(nonatomic, strong) NSNumber *captain;
@property(nonatomic) NSInteger points;
@property(nonatomic, strong) NSNumber *fieldIndex;
@property(nonatomic, strong) NSArray *events;

+ (id)initEmptyWithPosition:(NSString *)position;
+ (Player *)initWithId:(NSString *)ID;

+ (NSString *)positionName:(NSString *)position;

- (NSString *)positionName;
- (NSString *)photoImageUrlString:(NSString *)size;

- (UIImage *)lineupStatusImage;

- (UIColor *)lineupStatusColor;
@end
