//
// Created by Anders Hansen on 15/06/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"

@interface MatchGenerator : NSObject
@property(nonatomic, strong) NSMutableDictionary *rawMatch;

- (id)initWithOptions:(NSDictionary *)options;

- (void)createEvents:(NSDictionary *)options;

- (Match *)toMatch;

- (NSArray *)parseOptionIntoArrayWithObjects:(NSDictionary *)dictionary;
@end