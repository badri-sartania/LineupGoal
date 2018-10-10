//
// Created by Anders Hansen on 11/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"
#import "Competition.h"
#import "Subscription.h"
#import "ViewModelWithSubscriptions.h"

@interface MatchViewModel : ViewModelWithSubscriptions
@property(nonatomic, strong) Match *model;
@property(nonatomic, strong) NSArray *events;

- (void)disposeFetch;
- (void)disposeAutoFetch;

- (instancetype)initWithMatch:(Match *)match;
- (RACSignal *)fetchMatchDetailsSignal;
- (void)setupMatchDetailsFetchAtInterval:(NSInteger)interval;
- (void)submitSubscription;
- (NSArray *)formatedHomeLineup;
- (NSArray *)formatedAwayLineup;
@end
