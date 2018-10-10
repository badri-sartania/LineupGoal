//
//  EventCalculator.m
//  LineupBattle
//
//  Created by Anders Hansen on 09/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

#import "EventCalculator.h"
#import "NSArray+Reverse.h"
#import "NSArray+BlocksKit.h"
#import "Match.h"
#import "Event.h"

@interface EventCalculator ()
@property(nonatomic, strong) Match *match;
@end

@implementation EventCalculator

- (instancetype)initWithMatch:(Match *)match {
    self = [super init];
    if (self) {
        self.match = match;
    }

    return self;
}

#pragma mark - Public
- (NSArray *)processEventsAndCalculateScore {
    // Calculate score
    NSArray *calculatedEvents = [self calculateEventScores:self.match.events];

    // Reverse data from server
    NSArray *reversedEvents = [calculatedEvents reverse];

    // Inject extra events like assists, halftime, fulltime, penalty start etc.
    NSArray *allEvents = [self injectExtraEvents:reversedEvents];

    return allEvents;
}

#pragma mark - Private
- (NSArray *)calculateEventScores:(NSArray *)events {
    __block NSDictionary *previousEventScore;

    return [events bk_map:^id(Event *event) {
        NSDictionary *score = [self calculateScoreAtEvent:event lastScore:previousEventScore];
        [event setScoreAtEvent:score];
        previousEventScore = event.score;
        return event;
    }];
}

- (NSArray *)injectExtraEvents:(NSArray *)events {
    NSMutableArray *allEvents = [[NSMutableArray alloc] init];
    __block BOOL halftimeInserted = NO;
    __block BOOL extratime1Inserted = NO;
    __block BOOL penaltyInserted = NO;
    __block BOOL extraTimeDetected = NO;

    NSInteger period = [self.match.period integerValue];
    
    if ([self.match hasFinished]) {
        Event *endEvent = [Event dictionaryTransformer:@{
                                                             @"type": @"fulltime"
                                                             }];
        
        [allEvents addObject:endEvent];
    }

    // Going from latest of earliest event
    [events bk_each:^(Event *event) {

        NSInteger minutes = [event.time[@"minutes"] integerValue];

        //
        // Events are in order from newest to oldest
        //
        // We look after the event that comes right after a shift from example extra time (et) to second half (2h)
        // and inserts the et splitter event before inserting the 2h event
        //

        if (minutes > 90) {
            extraTimeDetected = YES;
        }

        // Penalty
        if (!penaltyInserted && period == MatchPeriodPenaltyShootout && minutes <= 120 && !event.isPenaltyShootoutEvent) {
            Event *penaltyEvent = [Event dictionaryTransformer:@{
                @"type": @"penaltyShootout"
            }];

            [allEvents addObject:penaltyEvent];
            penaltyInserted = YES;
        }

        // Extratime 1
        if (!extratime1Inserted && period >= MatchPeriodExtraTime1 && minutes <= 90 && extraTimeDetected) {
            Event *extraTimeEvent = [Event dictionaryTransformer:@{
                @"type": @"extratime1"
            }];

            [allEvents addObject:extraTimeEvent];
            extratime1Inserted = YES;
        }

        // Halftime
        if (!halftimeInserted && period >= MatchPeriodHalfTime && minutes <= 45) {
            Event *halftimeEvent = [Event dictionaryTransformer:@{
                @"type": @"halftime"
            }];

            [allEvents addObject:halftimeEvent];
            halftimeInserted = YES;
        }

        [allEvents addObject:event];

        //
        // Assists
        //
        // The way we do assists is to duplicate the event and set it as assist event.
        //
        if (event.hasAssist) {
            Event *assistEvent = [event copy];
            assistEvent.isAssistEvent = YES;
            [allEvents addObject:assistEvent];
        }
    }];

    if (!penaltyInserted && period >= MatchPeriodPenaltyShootout && period < MatchPeriodFullTime) {
        Event *halftimeEvent = [Event dictionaryTransformer:@{
            @"type": @"penaltyShootout"
        }];

        [allEvents addObject:halftimeEvent];
    }

    if (!extratime1Inserted && period >= MatchPeriodExtraTime1 && period < MatchPeriodFullTime) {
        Event *halftimeEvent = [Event dictionaryTransformer:@{
           @"type": @"extratime1"
        }];

        [allEvents addObject:halftimeEvent];
    }

    if (!halftimeInserted && period >= MatchPeriodHalfTime) {
        Event *halftimeEvent = [Event dictionaryTransformer:@{
            @"type": @"halftime"
        }];

        [allEvents addObject:halftimeEvent];
    }

    return allEvents;
}

#pragma mark - Calculations
- (NSDictionary *)calculateScoreAtEvent:(Event *)event lastScore:(NSDictionary *)lastScore {
    if (!lastScore) {
        lastScore = @{@"home": @0, @"away": @0};
    }

    NSNumber *home = lastScore[@"home"];
    NSNumber *away = lastScore[@"away"];

    if (event.isGoal || event.isOwnGoal) {
        if(event.isHome) {
            home = @([lastScore[@"home"] integerValue] + 1);
        } else {
            away = @([lastScore[@"away"] integerValue] + 1);
        }
    }

    return @{@"home": home, @"away": away };
}
@end
