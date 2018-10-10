//
// Created by Anders Borre Hansen on 24/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "LBMTLModel.h"


@interface User : LBMTLModel
@property(nonatomic, copy, readonly) NSString *objectId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy, readonly) NSString *country;
@property(nonatomic, copy, readonly) NSNumber *photoToken;
@property(nonatomic, strong, readonly) NSNumber *points;
@property(nonatomic, strong, readonly) NSNumber *current;
@property(nonatomic, strong, readonly) NSNumber *coins;
@property(nonatomic, strong, readonly) NSNumber *wallet;
@property(nonatomic, strong, readonly) NSDate *walletUpdatedAt;
@property(nonatomic, strong, readonly) NSNumber *level;
@property(nonatomic, strong, readonly) NSNumber *xp;
@property(nonatomic, strong, readonly) NSNumber *xpToNextLevel;
@property(nonatomic, strong, readonly) NSNumber *pos;
@property(nonatomic, strong, readonly) NSNumber *bestLineup;
@property(nonatomic, strong, readonly) NSNumber *bestMonth;
@property(nonatomic, strong, readonly) NSNumber *ultimateXI_points;

// Brag
@property(nonatomic, strong, readonly) NSNumber *won;
@property(nonatomic, strong, readonly) NSNumber *biggestWin;
@property(nonatomic, strong, readonly) NSNumber *win;


@property(nonatomic, strong, readonly) NSArray *battles;
@property(nonatomic, strong) NSArray *players;

// Added by Tom
@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy, readonly) NSString *notification;
@property(nonatomic, copy, readonly) NSString *subscription;

- (NSNumber *)nextLevelXP;

- (NSString *)profileImagePath:(NSInteger)size;

- (NSInteger)xpProgressionInPercentage;
@end
