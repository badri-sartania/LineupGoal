//
// Created by Anders Borre Hansen on 28/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "Match.h"
#import "Event.h"
#import "Date.h"
#import "Utils.h"
#import "NSArray+Reverse.h"
#import "EventCalculator.h"


@implementation Match

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    dictionaryValue = [@{
        @"status" : @"fixture",
    } mtl_dictionaryByAddingEntriesFromDictionary:dictionaryValue];

    self = [super initWithDictionary:dictionaryValue error:error];

    _dateString = [Date getRequestDateFormat:self.kickOff];

    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectId" : @"_id",
        @"home" : @"home",
        @"away" : @"away",
        @"status" : @"status",
        @"period" : @"period",
        @"periodStr": @"period",
        @"clockObj" : @"clock",
        @"grouping": @"grouping",
        @"competition" : @"competition",
        @"events": @"events",
        @"kickOff" : @"kickOff",
        @"dateString": @"dateString",
        @"h2h" : @"h2h",
        @"venue" : @"venue",
        @"referee" : @"referee",
        @"subscription" : @"subscription",
        @"homeLineup": @"home.lineup",
        @"awayLineup": @"away.lineup",
        @"homeSubstitutes": @"home.substitutes",
        @"awaySubstitutes": @"away.substitutes",
        @"homeFormation": @"home.formation",
        @"awayFormation": @"away.formation",
        @"homeStanding": @"home.score",
        @"awayStanding": @"away.score",
        @"homeRedCards": @"home.redCards",
        @"awayRedCards": @"away.redCards",
        @"homeLastGoalObj": @"home.lastGoal",
        @"awayLastGoalObj": @"away.lastGoal"
    };
}

+ (NSValueTransformer *)h2hJSONTransformer {
    return [self.class matchesJSONTransformer];
}

+ (NSValueTransformer *)kickOffJSONTransformer {
    return [self.class dateTransformer];
}

+ (NSValueTransformer *)homeJSONTransformer {
    return [self.class teamJSONTransformer];
}

+ (NSValueTransformer *)awayJSONTransformer {
    return [self.class teamJSONTransformer];
}

+ (NSValueTransformer *)homeSubstitutesJSONTransformer {
    return [self.class playersJSONTransformer];
}

+ (NSValueTransformer *)awaySubstitutesJSONTransformer {
    return [self.class playersJSONTransformer];
}

+ (NSValueTransformer *)homeLineupJSONTransformer {
    return [self.class playersJSONTransformer];
}

+ (NSValueTransformer *)awayLineupJSONTransformer {
    return [self.class playersJSONTransformer];
}

+ (NSValueTransformer *)periodJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *period, BOOL *success, NSError *__autoreleasing *error) {
        return @([Match parsePeriod:period]);
    } reverseBlock:^id(MatchSubscription *subscription, BOOL *success, NSError *__autoreleasing *error) {
        return subscription;
    }];
}

+ (NSValueTransformer *)subscriptionJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dic, BOOL *success, NSError *__autoreleasing *error) {
        MatchSubscription *subscription = [[MatchSubscription alloc] init];
        [subscription updateData:dic];

        return subscription;
    } reverseBlock:^id(MatchSubscription *subscription, BOOL *success, NSError *__autoreleasing *error) {
        return subscription;
    }];
}

+ (NSValueTransformer *)eventsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Event class]];
}

+ (NSInteger)parsePeriod:(NSString *)period {
    if ([period  isEqualToString:@"1h"]) return MatchPeriodFirstHalf;
    if ([period isEqualToString:@"ht"]) return MatchPeriodHalfTime;
    if ([period isEqualToString:@"2h"]) return MatchPeriodSecondHalf;
    if ([period isEqualToString:@"e1"]) return MatchPeriodExtraTime1;
    if ([period isEqualToString:@"eht"]) return MatchPeriodExtraTime1;
    if ([period isEqualToString:@"e2"]) return MatchPeriodExtraTime2;
    if ([period isEqualToString:@"ps"]) return MatchPeriodPenaltyShootout;
    if ([period isEqualToString:@"ft"]) return MatchPeriodFullTime;

    return MatchPeriodNotStarted;
}

#pragma mark - Processing
- (NSArray *)processedEvents {
    EventCalculator *eventCalculator = [[EventCalculator alloc] initWithMatch:self];
    return [eventCalculator processEventsAndCalculateScore];
}

- (NSString *)processStatus:(id)status {
    if (status == nil) return @"fixture";
    return status;
}

- (NSInteger)kickOffDiff {
    double timeDiff = [[NSDate date] timeIntervalSinceDate:self.kickOff];
    double seconds  = round(timeDiff);

    return (NSInteger)round(seconds / 60.0f);
}

- (NSNumber *)clock {
    return [self calculateClock:self.clockObj];
}

- (NSNumber *)homeLastGoal {
    return [self calculateClock:self.home.lastGoal];
}

- (NSNumber *)awayLastGoal {
    return [self calculateClock:self.away.lastGoal];
}

- (NSNumber *)calculateClock:(NSDictionary *)clockObj {
    NSInteger clock = [clockObj[@"minutes"] integerValue];

    return self.isPlaying ? @(clock) : nil;
}


#pragma mark - BOOLS
- (BOOL)isNotStartedYet {
    return [self.status isEqualToString:@"fixture"];
}

- (BOOL)hasFinished {
    return [self.status isEqualToString:@"played"];
}

- (BOOL)isPlaying {
    return [self.status isEqualToString:@"playing"];
}

- (BOOL)isFirstHalf {
    return [self.period integerValue] == MatchPeriodFirstHalf;
}

- (BOOL)isSecondHalf {
    return [self.period integerValue] == MatchPeriodSecondHalf;
}

- (BOOL)isHalftime {
    return [self.period integerValue] == MatchPeriodHalfTime;
}

- (BOOL)hasNewHomeGoal {
    NSInteger lastGoalClock = [self.homeLastGoal integerValue];
    NSInteger clock = [self.clock integerValue];

    if (clock && lastGoalClock) {
        return (clock - lastGoalClock)  < 5;
    }

    return NO;
}

- (BOOL)hasNewAwayGoal {
    if (self.clock && self.awayLastGoal) {
        return ([self.clock integerValue] - [self.awayLastGoal integerValue] < 5);
    }

    return NO;
}

- (BOOL)hasNewGoal {
    return [self hasNewHomeGoal] || [self hasNewAwayGoal];
}

#pragma mark - Decorators
- (NSString *)infoText {
    if (self.isNotStartedYet) {
        return [self kickOffTime];
    } else if (self.isHalftime) {
        return @"HT";
    } else if (self.hasFinished) {
        return @"FT";
    } else if (self.isPlaying) {
        if (self.clockObj[@"overtime"]) {
            return [NSString stringWithFormat:@"%@+%@\'", [self clock], self.clockObj[@"overtime"]];
        } else {
            return [NSString stringWithFormat:@"%@\'", [self clock]];
        }
    }

    return self.status;
}

- (NSString *)kickOffTime {
    return [[YLMoment momentWithDate:self.kickOff] format:@"HH:mm"];
}

- (NSString *)weekDay {
//    NSArray *weekdays = @[
//                          @"Sunday",
//                          @"Monday",
//                          @"Tuesday",
//                          @"Wednesday",
//                          @"Thursday",
//                          @"Friday",
//                          @"Saturday"
//                          ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    return [dateFormatter stringFromDate:self.kickOff];
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.home.name, self.away.name];
}
@end
