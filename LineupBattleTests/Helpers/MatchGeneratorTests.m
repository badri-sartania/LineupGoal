//
//  MatchGeneratorTests.m
//  Lineupbattle
//
//  Created by Anders Hansen on 15/06/14.
//  Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MatchGenerator.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Event.h"

@interface MatchGeneratorTests : XCTestCase

@end

@implementation MatchGeneratorTests

- (void)testIDAlwaysIsSet {
    Match *match = [[[MatchGenerator alloc] initWithOptions:nil] toMatch];
    expect(match.objectId).notTo.beNil();
}


#pragma mark - events
- (void)testEventsWithClock {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:nil];
    [generator createEvents:@{
       @"clock": @[@"22", @"45+3"]
    }];

    NSArray *events = [generator toMatch].events;

    expect(events.count).to.equal(2);

    Event *event1 = events[0];
    Event *event2 = events[1];

    expect([event1.time[@"minutes"] integerValue]).to.equal(22);
    expect([event2.time[@"overtime"] integerValue]).to.equal(3);
    expect([event2.time[@"minutes"] integerValue]).to.equal(45);
}

- (void)testOptionParsingIntoArrayOfObjects {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:nil];

    NSArray *array = [generator parseOptionIntoArrayWithObjects:@{
        @"alpha" : @[@"a", @"b", @"c"],
        @"numeric" : @[@1, @2, @3],
        @"object" : @[@{@"asd1" : @"dsa1"}, @{@"asd2" : @"dsa2"}, @{@"asd3" : @"dsa3"}]
    }];

    expect(array.count).to.equal(3);
    expect(array[0][@"alpha"]).to.equal(@"a");
    expect(array[0][@"numeric"]).to.equal(@1);
    expect(array[0][@"object"]).to.equal(@{@"asd1" : @"dsa1"});
}

#pragma mark - Data generator based on options

- (void)testWildCardMatchParametres {
    MatchGenerator *generator = [[MatchGenerator alloc] initWithOptions:@{
       @"period": @"2h"
    }];

    expect(generator.toMatch.period).to.equal(MatchPeriodSecondHalf
                                              );
}

@end
