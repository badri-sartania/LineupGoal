//
// Created by Anders Borre Hansen on 28/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import <YLMoment/YLMoment.h>
#import "MatchSubscription.h"
#import "Team.h"
#import "Competition.h"
#import "LBMTLModel.h"

typedef NS_ENUM(NSInteger, MatchPeriod) {
    MatchPeriodNotStarted,
    MatchPeriodFirstHalf,
    MatchPeriodHalfTime,
    MatchPeriodSecondHalf,
    MatchPeriodExtraTime1,
    MatchPeriodExtraTime2,
    MatchPeriodPenaltyShootout,
    MatchPeriodFullTime
};

@interface Match : LBMTLModel
@property(nonatomic, copy, readonly)   NSString *objectId;
@property(nonatomic, copy, readonly)   NSString *homeName;
@property(nonatomic, copy, readonly)   NSString *awayName;
@property(nonatomic, copy, readonly)   NSString *status;
@property(nonatomic, copy, readonly)   NSString *dateString;
@property(nonatomic, copy, readonly)   NSString *country;
@property(nonatomic, copy, readonly)   NSString *venue;
@property(nonatomic, copy, readonly)   NSString *referee;
@property(nonatomic, copy, readonly)   NSString *periodStr;
@property(nonatomic, strong, readonly) NSNumber *period;
@property(nonatomic, strong, readonly) NSNumber *grouping;
@property(nonatomic, strong, readonly) NSArray *h2h;
@property(nonatomic, strong, readonly) NSArray *events;
@property(nonatomic, strong, readonly) NSDictionary *clockObj;
@property(nonatomic, strong, readonly) NSDate *kickOff;
@property(nonatomic, strong, readonly) Competition *competition;
@property(nonatomic, strong, readonly) MatchSubscription *subscription;
@property(nonatomic, strong, readonly) Team *home;
@property(nonatomic, strong, readonly) Team *away;

// From Teams to make sure there isn't any match data spillover
@property(nonatomic, strong, readonly) NSNumber *homeStanding;
@property(nonatomic, strong, readonly) NSNumber *awayStanding;
@property(nonatomic, strong, readonly) NSNumber *awayRedCards;
@property(nonatomic, strong, readonly) NSNumber *homeRedCards;
@property(nonatomic, strong, readonly) NSDictionary *homeLastGoalObj;
@property(nonatomic, strong, readonly) NSDictionary *awayLastGoalObj;
@property(nonatomic, strong, readonly) NSArray *homeLineup;
@property(nonatomic, strong, readonly) NSArray *awayLineup;
@property(nonatomic, strong, readonly) NSArray *homeFormation;
@property(nonatomic, strong, readonly) NSArray *awayFormation;
@property(nonatomic, strong, readonly) NSArray *homeSubstitutes;
@property(nonatomic, strong, readonly) NSArray *awaySubstitutes;

- (BOOL)isNotStartedYet;
- (BOOL)isPlaying;
- (BOOL)hasFinished;
- (NSString *)infoText;
- (NSNumber *)clock;

- (NSArray *)processedEvents;

- (NSInteger)kickOffDiff;
- (BOOL)hasNewHomeGoal;
- (BOOL)hasNewAwayGoal;
- (BOOL)hasNewGoal;
- (NSString *)kickOffTime;
- (NSString *)weekDay;

- (NSString *)name;
@end
