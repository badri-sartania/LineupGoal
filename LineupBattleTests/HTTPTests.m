//
//  HTTPTests.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 27/01/15.
//  Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#import "HTTPHelper.h"


@interface HTTPTests : XCTestCase

@end

@implementation HTTPTests


#pragma mark - ApplyQueryToUrl
- (void)testApplyQueryWithQuestionMark {
    NSString *url = @"/search?q=123";
    NSDictionary *query = @{
        @"test": @"abc"
    };

    expect([HTTPHelper applyQuery:query toUrlString:url]).to.equal(@"/search?q=123&test=abc");
}

- (void)testApplyQuery {
    NSString *url = @"/search";
    NSDictionary *query = @{
       @"test": @"abc"
    };

    expect([HTTPHelper applyQuery:query toUrlString:url]).to.equal(@"/search?test=abc");
}

- (void)testApplyQueryWithSpecialChars {
    NSString *url = @"/search";
    NSDictionary *query = @{
        @"test": @".=?"
    };

    expect([HTTPHelper applyQuery:query toUrlString:url]).to.equal(@"/search?test=.%3D%3F");
}

#pragma mark - queryWithAuth
- (void)testQueryWithAuth {
    NSDictionary *dic = @{
        @"abc": @"bca"
    };

    NSDictionary *result = [HTTPHelper applyAuthToDictionary:dic];

    expect(result.count).to.equal(2);
    expect(result[@"abc"]).to.equal(@"bca");
    expect(result[@"auth"]).toNot.beNil();
}

- (void)testQueryWithAuthAndShouldNotOverrideAuth {
    NSDictionary *dic = @{
      @"auth": @"alternative"
    };

    NSDictionary *result = [HTTPHelper applyAuthToDictionary:dic];

    expect(result.count).to.equal(1);
    expect(result[@"auth"]).to.equal(@"alternative");
}

@end
