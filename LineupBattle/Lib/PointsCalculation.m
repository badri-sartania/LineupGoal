//
// Created by Anders Borre Hansen on 31/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "PointsCalculation.h"


@interface PointsCalculation ()
@property(nonatomic, strong) NSArray *pointsArray;
@end

@implementation PointsCalculation


+ (NSInteger)pointsForPlayers:(NSArray *)players points:(NSArray *)points {
    NSInteger pointsInt = [players bk_reduceInteger:0 withBlock:^NSInteger(NSInteger result, Player *player) {
        NSArray *pointsArray = [PointsCalculation pointsArrayForPlayerWithCaptainMultiplier:player points:points];
        NSInteger totalValueOfPoints = [PointsCalculation totalValueOfPoints:pointsArray];

        return result + totalValueOfPoints;
    }];

    return pointsInt;
}

+ (NSArray *)pointsArrayForPlayer:(Player *)player points:(NSArray *)points {
    NSArray *pointsForPlayer =[points bk_select:^BOOL(NSDictionary *pointDic) {
        return [pointDic[@"_id"] isEqualToString:player.objectId];
    }];

    return pointsForPlayer;
}

+ (NSArray *)pointsArrayForPlayerWithCaptainMultiplier:(Player *)player points:(NSArray *)points {
    NSArray *pointsForPlayer =[points bk_select:^BOOL(NSDictionary *pointDic) {
        return [pointDic[@"_id"] isEqualToString:player.objectId];
    }];

    NSArray *pointsForPlayerWithCaptain = [PointsCalculation applyCaptainPoints:pointsForPlayer players:@[player]];

    return pointsForPlayerWithCaptain;
}

+ (NSArray *)pointsArrayForPlayers:(NSArray *)players points:(NSArray *)points {
    NSArray *playerIds = [players bk_map:^id(Player *player) {
        return player.objectId;
    }];

    NSArray *pointsForPlayers = [points bk_select:^BOOL(NSDictionary *pointDic) {
        return [playerIds containsObject:pointDic[@"_id"]];
    }];

    return pointsForPlayers;
}

+ (NSArray *)pointsArrayForPlayersWithCaptainMultiplier:(NSArray *)players points:(NSArray *)points {
    NSArray *playerPoints = [PointsCalculation pointsArrayForPlayers:players points:points];
    NSArray *playerPointsWithCaptain = [PointsCalculation applyCaptainPoints:playerPoints players:players];

    return playerPointsWithCaptain;
}

+ (NSArray *)applyCaptainPoints:(NSArray *)playerPoints players:(NSArray *)players {
    __block NSArray *points = [playerPoints copy];

    // Go though players and double points if captain
    Player *captain = [players bk_match:^BOOL(Player *player) {
        return [player.captain boolValue];
    }];

    if (!captain) return points;

    points = [points bk_map:^id(NSDictionary *pointDic) {
        if ([pointDic[@"_id"] isEqualToString:captain.objectId]) {
            NSMutableDictionary *mutablePointDic = [pointDic mutableCopy];
            mutablePointDic[@"points"] = @([pointDic[@"points"] integerValue] * 2);
            mutablePointDic[@"captain"] = @YES;

            return mutablePointDic;
        }

        return pointDic;
    }];

    return points;
}

+ (NSInteger)totalValueOfPoints:(NSArray *)pointsArray {
    NSInteger points = [pointsArray bk_reduceInteger:0 withBlock:^NSInteger(NSInteger result, NSDictionary *dic) {
        if (!dic[@"points"]) return result;
        return result + [dic[@"points"] integerValue];
    }];

    return points;
}


+ (NSInteger)pointsForPlayer:(Player *)player points:(NSArray *)points {
    NSArray *pointsArray = [PointsCalculation pointsArrayForPlayer:player points:points];
    NSInteger pointsInt = [PointsCalculation totalValueOfPoints:pointsArray];

    return pointsInt;
}

@end
