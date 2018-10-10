//
// Created by Anders Borre Hansen on 18/11/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTP.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import "Subscription.h"


@interface HTTP (RAC)

// Get
- (RACSignal *)get:(NSString *)path;
- (RACSignal *)get:(NSString *)path query:(NSDictionary *)query;
- (RACSignal *)put:(NSString *)path body:(id)body;
- (RACSignal *)put:(NSString *)path query:(NSDictionary *)query body:(id)body;
- (RACSignal *)post:(NSString *)path body:(id)body;
- (RACSignal *)post:(NSString *)path query:(NSDictionary *)query body:(NSDictionary *)body;
- (RACSignal *)fetchMatchesByRange:(NSString *)startDateString endDateString:(NSString *)endDateString;
- (RACSignal *)fetchLeagueCountByDayByRange:(NSString *)startDateString endDateString:(NSString *)endDateString;
- (RACSignal *)battlesSignal;
- (RACSignal *)lobbySignal;

// Set
- (RACDisposable *)fetchConfiguration:(void (^)(RACTuple *tuple))nextBlock;
- (RACSignal *)updateUser:(User *)user;
- (RACSignal *)updateFacebookOnServerWithToken:(FBSDKAccessToken *)token;

@end
