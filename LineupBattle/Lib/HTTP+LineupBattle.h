//
// Created by Anders Borre Hansen on 18/11/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTP.h"

@interface HTTP (LineupBattle)
- (void)sendAPNDeviceToken:(NSString *)token;
- (void)addBasicTeamSubscriptions:(NSArray *)array;
- (void)updateSubscription:(Subscription *)subscription forType:(NSString *)type withId:(NSString *)objectId;
@end