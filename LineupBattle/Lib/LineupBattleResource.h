//
//  LineupBattle.h
//  LineupBattle
//
//  Created by Anders Borre Hansen on 18/11/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

#import "Leaderboard.h"
#import "Prize.h"
#import "BattleTemplate.h"
#import "XipSlideDown.h"

@interface LineupBattleResource : NSObject
+ (void)leaderboardsForMonth:(NSString *)monthString success:(void (^)(NSArray<Leaderboard *> *leaderboards))success failure:(void (^)(NSError *))failure;
+ (void)bestLineupForMonth:(NSString *)monthString success:(void (^)(NSArray<Leaderboard *> *leaderboards))success failure:(void (^)(NSError *))failure;
+ (void)ultimateXiForSeason:(void (^)(NSArray<Leaderboard *> *leaderboards))success failure:(void (^)(NSError *))failure;
+ (void)pointPrizesForMonth:(NSString *)monthString success:(void (^)(NSArray* prizes))success failure:(void (^)(NSError *))failure;
+ (void)lineupPrizesForMonth:(NSString *)monthString success:(void (^)(NSArray* prizes))success failure:(void (^)(NSError *))failure;
+ (void)sendBattleTemplateSubscription:(NSString *)battleTemplateId reminder:(BOOL)reminder success:(void (^)())success failure:(void (^)(NSError *))failure;
@end
