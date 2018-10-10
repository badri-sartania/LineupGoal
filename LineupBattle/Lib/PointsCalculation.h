//
// Created by Anders Borre Hansen on 31/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Player.h"

@interface PointsCalculation : NSObject

+ (NSArray *)pointsArrayForPlayer:(Player *)player points:(NSArray *)points;

+ (NSArray *)pointsArrayForPlayerWithCaptainMultiplier:(Player *)player points:(NSArray *)points;

+ (NSArray *)pointsArrayForPlayers:(NSArray *)players points:(NSArray *)points;

+ (NSArray *)pointsArrayForPlayersWithCaptainMultiplier:(NSArray *)players points:(NSArray *)points;

+ (NSArray *)applyCaptainPoints:(NSArray *)playerPoints players:(NSArray *)players;

+ (NSInteger)totalValueOfPoints:(NSArray *)pointsArray;

+ (NSInteger)pointsForPlayers:(NSArray *)players points:(NSArray *)points;

+ (NSInteger)pointsForPlayer:(Player *)player points:(NSArray *)points;

@end
