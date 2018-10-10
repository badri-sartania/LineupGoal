//
// Created by Anders Borre Hansen on 18/11/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "HTTP+RAC.h"
#import "Battle.h"
#import "BattleHelper.h"
#import "Identification.h"
#import "Date.h"
#import "HTTPHelper.h"


@implementation HTTP (RAC)

- (RACSignal *)get:(NSString *)path {
    return [self get:path query:nil];
}

- (RACSignal *)get:(NSString *)path query:(NSDictionary *)query {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPRequestOperation *request = [self get:path params:query success:^(id o) {
            [subscriber sendNext:o];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];

        @weakify(request);
        return [RACDisposable disposableWithBlock:^{
            @strongify(request);
            [request cancel];
        }];
    }];
}

- (RACSignal *)put:(NSString *)path body:(id)body {
    return [self put:path query:nil body:body];
}

- (RACSignal *)put:(NSString *)path query:(NSDictionary *)query body:(id)body {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPRequestOperation *request = [self put:path params:query body:body
            success:^(id o) {
                [subscriber sendNext:o];
                [subscriber sendCompleted];
            }
            failure:^(NSError *error) {
                [subscriber sendError:error];
            }
        ];

        @weakify(request);
        return [RACDisposable disposableWithBlock:^{
            @strongify(request);
            [request cancel];
        }];
    }];
}

- (RACSignal *)post:(NSString *)path body:(id)body {
    return [self post:path query:nil body:body];
}

- (RACSignal *)post:(NSString *)path query:(NSDictionary *)query body:(id)body {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPRequestOperation *request = [self post:path params:query body:body
            success:^(id o) {
                [subscriber sendNext:o];
                [subscriber sendCompleted];
            }
            failure:^(NSError *error) {
                [subscriber sendError:error];
            }
        ];

        @weakify(request);
        return [RACDisposable disposableWithBlock:^{
            @strongify(request);
            [request cancel];
        }];
    }];
}

- (RACSignal *)fetchMatchesByRange:(NSString *)startDateString endDateString:(NSString *)endDateString {
    NSDictionary *params = @{
        @"start"    : startDateString,
        @"end"      : endDateString,
        @"timezone" : Date.timezone
    };

    return [self get:@"/matches" query:params];
}

- (RACSignal *)fetchLeagueCountByDayByRange:(NSString *)startDateString endDateString:(NSString *)endDateString {
    NSDictionary *params = @{
        @"start"    : startDateString,
        @"end"      : endDateString,
        @"timezone" : Date.timezone
    };

    return [self get:@"/competitions/count" query:params];
}

- (RACDisposable *)fetchConfiguration:(void (^)(RACTuple *tuple))nextBlock {
    return [[self get:@"/config"] subscribeNext:nextBlock];
}

- (RACSignal *)updateUser:(User *)user {
    NSMutableDictionary * dict =  [[NSMutableDictionary alloc] init];
    if (user.name){
        dict[@"name"] = user.name;
    }
    if (user.email){
        dict[@"email"] = user.email;
    }
    
    return [[HTTP instance] put:@"/me" body:dict];
}

- (RACSignal *)updateFacebookOnServerWithToken:(FBSDKAccessToken *)token {
    return [[HTTP instance] put:@"/me" body:@{
            @"facebook" : @{
                @"id" : token.userID ?: [NSNull null],
                @"token" : token.tokenString ?: [NSNull null],
                @"tokenExpireDate" : [Date dateToISO8601String:token.expirationDate] ?: [NSNull null],
                @"tokenRefreshDate" : [Date dateToISO8601String:token.refreshDate] ?: [NSNull null]
            }
    }];
}

- (RACSignal *)lobbySignal {
    return [[[[[HTTP instance] get:@"/battles/lobby"] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]] map:^id (NSDictionary *dic) {

        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        userDic[@"_id"] = [Identification userId];

        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userDic error:NULL];

        return @{
            @"user": user
        };
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)battlesSignal {
    return [[[[[HTTP instance] get:@"/battles"] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]] map:^id (NSDictionary *dic) {
        NSArray *battleTemplates = [MTLJSONAdapter modelsOfClass:[BattleTemplate class] fromJSONArray:dic[@"templates"] error:NULL];
        NSArray *activeBattleTemplates = [MTLJSONAdapter modelsOfClass:[Battle class] fromJSONArray:[dic objectForKey:@"active"] error:NULL];
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithDictionary:dic[@"user"]];
        userDic[@"_id"] = [Identification userId];
        
        return @{
            @"templates": [BattleHelper sortBattleTemplatesByStartDateIntoSections:battleTemplates],
            @"active": activeBattleTemplates,
            @"user": [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userDic error:NULL]
        };
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

@end
