//
//  LineupBattle.m
//  LineupBattle
//
//  Created by Anders Borre Hansen on 18/11/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

#import "LineupBattleResource.h"
#import "HTTP.h"
#import "Identification.h"


@implementation LineupBattleResource
+ (void)leaderboardsForMonth:(NSString *)monthString success:(void (^)(NSArray<Leaderboard *> *leaderboards))success failure:(void (^)(NSError *))failure {

    NSDictionary *params = @{
        @"month": monthString,
        @"auth": @"test-test"
    };

    [HTTP.instance get:@"battles/leaderboards/month" params:params success:^(NSArray *arr) {
        success([Leaderboard arrayTransformer:arr]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)bestLineupForMonth:(NSString *)monthString success:(void (^)(NSArray<Leaderboard *> *leaderboards))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *params = @{
                             @"month": monthString,
                             @"auth": @"test-test"
                             };
    
    [HTTP.instance get:@"battles/leaderboard/best_lineup_monthly" params:params success:^(NSArray *arr) {
        success([Leaderboard arrayTransformer:arr]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)ultimateXiForSeason:(void (^)(NSArray<Leaderboard *> *leaderboards))success failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{
                             @"auth": @"test-test"
                             };
    
    [HTTP.instance get:@"battles/leaderboard/ultimate_xi" params:params success:^(NSArray *arr) {
        success([Leaderboard arrayTransformer:arr]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)pointPrizesForMonth:(NSString *)monthString success:(void (^)(NSArray* prizes))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *params = @{
                             @"auth": @"test-test",
//                             @"month": monthString	
                             };
    
    [HTTP.instance get:@"prizes/leaderboard/total_points_monthly" params:params success:^(NSArray *arr) {
        success(arr);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)lineupPrizesForMonth:(NSString *)monthString success:(void (^)(NSArray* prizes))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *params = @{
                             @"auth": @"test-test",
//                             @"month": monthString
                             };
    
    [HTTP.instance get:@"prizes/leaderboard/best_lineup_monthly" params:params success:^(NSArray *arr) {
        success(arr);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)sendBattleTemplateSubscription:(NSString *)battleTemplateId reminder:(BOOL)reminder success:(void (^)())success failure:(void (^)(NSError *))failure {

    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"reminder": @(reminder),
    }];

    NSString *apnToken = [Identification apnDeviceToken];
    if (apnToken) {
        body[@"token"] = apnToken;
    }

    NSString *url = [NSString stringWithFormat:@"battle-templates/%@/subscribe", battleTemplateId];
    [HTTP.instance put:url params:nil body:body success:^(NSArray *arr) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
