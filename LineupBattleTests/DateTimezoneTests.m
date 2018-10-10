//
//  DateTests.m
//  Lineupbattle
//
//  Created by Anders Hansen on 13/06/14.
//  Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Date.h"
#define EXP_SHORTHAND
#import "Expecta.h"

@interface DateTimezoneTests : XCTestCase

@end

@implementation DateTimezoneTests

- (void)testTimezonePositive {
    expect([Date formatTimezone:1]).to.equal(@"+01:00");
    expect([Date formatTimezone:11]).to.equal(@"+11:00");
}

- (void)testTimezoneZero {
    expect([Date formatTimezone:0]).to.equal(@"00:00");
}

- (void)testTimezoneNegative {
    expect([Date formatTimezone:-2]).to.equal(@"-02:00");
    expect([Date formatTimezone:-12]).to.equal(@"-12:00");
}

@end
