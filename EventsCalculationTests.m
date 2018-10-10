//
//  EventsCalculationTests.m
//  Lineupbattle
//
//  Created by Anders Hansen on 15/06/14.
//  Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Match.h"
#import <Expecta/Expecta.h>
#import "Event.h"
#import "MatchGenerator.h"
#import "EventCalculator.h"

@interface EventsCalculationTests : XCTestCase

@end

@interface EventsCalculationTests ()
@property(nonatomic, strong) Match *match;
@end

@implementation EventsCalculationTests

#pragma mark - Halftime marker
- (void)testHalfTimeSplitterInsertedLastEventFirstHalf {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
       @"period": @"ht"
    }];

    [generator createEvents:@{
        @"clock": @[@"22", @"45+3"],
        @"type": @[@"goal", @"redcard"]
    }];

    Match *match = generator.toMatch;
    
    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;
    
    expect(events.count).to.equal(3);
    expect(((Event *)events[0]).type).to.equal(@"halftime");
}

- (void)testHalfTimeSplitterInsertedWithEventSecondHalf {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
            @"period" : @"2h"
    }];

    [generator createEvents:@{
        @"clock" : @[@"22", @"45+3", @"78"],
        @"type" : @[@"goal", @"redcard", @"penalty"]
    }];

    Match *match = generator.toMatch;

    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;
    
    expect(events.count).to.equal(4);
    expect(((Event *) events[1]).type).to.equal(@"halftime");
}

- (void)testHalfTimeSplitterNotInsertedWhenFirstHalf {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
        @"period" : @"1h"
    }];

    [generator createEvents:@{
        @"clock" : @[@"22", @"45+3"],
        @"type" : @[@"goal", @"redcard"]
    }];

    Match *match = generator.toMatch;

    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;
    
    expect(events.count).to.equal(2);
    expect(((Event *)events[0]).type).to.equal(@"redcard");
    expect(((Event *)events[1]).type).to.equal(@"goal");
}

- (void)testHalfTimeSplitterInsertedWhenNoEvents {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
        @"period": @"2h"
    }];

    [generator createEvents:@{
        @"clock" : @[@"67"],
        @"type" : @[@"goal"]
    }];

    Match *match = generator.toMatch;

    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;
    
    expect(events.count).to.equal(2);
    expect(((Event *)events[1]).type).to.equal(@"halftime");
}

#pragma mark - Extratime marker
- (void)testExtratime1SplitterIsInsertedWithEventInExtraTime {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
        @"period" : @"e1"
    }];

    [generator createEvents:@{
        @"clock" : @[@"105"],
        @"type" : @[@"goal"]
    }];

    Match *match = generator.toMatch;
    
    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;

    expect(events.count).to.equal(3);
    expect(((Event *) events[1]).type).to.equal(@"extratime1");
}

- (void)testExtratimeSplitterNotInsertedWhenStillSecondHalf {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
        @"period" : @"e1"
    }];

    [generator createEvents:@{
        @"clock" : @[@"91"],
        @"type" : @[@"goal"]
    }];

    Match *match = generator.toMatch;

    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;
    
    expect(events.count).to.equal(3);
    expect(((Event *)events[2]).type).to.equal(@"halftime");
}

- (void)testExtraSplitterInsertedWhenNoEventsUntilPenalty {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
        @"period": @"ps"
    }];

    [generator createEvents:@{
        @"clock" : @[@"120+3"],
        @"type" : @[@"ps-goal"]
    }];

    Match *match = generator.toMatch;

    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;
    
    expect(events.count).to.equal(4);
    expect(((Event *)events[3]).type).to.equal(@"halftime");
    expect(((Event *)events[2]).type).to.equal(@"extratime1");
    expect(((Event *)events[1]).type).to.equal(@"penaltyShootout");
    expect(((Event *)events[0]).type).to.equal(@"ps-goal");
}


#pragma mark - Penalty marker
- (void)testPenaltySplitterIsInsertedWithEventInExtraTime {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
            @"period" : @"e1"
    }];

    [generator createEvents:@{
            @"clock" : @[@"105"],
            @"type" : @[@"goal"]
    }];

    Match *match = generator.toMatch;

    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;
    
    expect(events.count).to.equal(3);
    expect(((Event *)events[0]).type).to.equal(@"goal");
    expect(((Event *)events[1]).type).to.equal(@"extratime1");
    expect(((Event *)events[2]).type).to.equal(@"halftime");
}

- (void)testOnlyHalftimeSplitterAfterFullTime {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
      @"period": @"ft"
    }];

    [generator createEvents:@{
        @"clock": @[@"22", @"45+3", @"90"],
        @"type": @[@"goal", @"redcard", @"goal"]
    }];

    Match *match = generator.toMatch;

    EventCalculator *eventCal = [[EventCalculator alloc] initWithMatch:match];
    NSArray *events = eventCal.processEventsAndCalculateScore;

    expect(events.count).to.equal(4);
    expect(((Event *)events[0]).type).to.equal(@"goal");
}

@end
