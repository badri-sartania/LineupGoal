//
// Created by Thomas Watson on 19/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "MatchSubscription.h"

@implementation MatchSubscription

+ (NSArray *)types {
    static NSArray *_types;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _types = @[
            @"reminder",
            @"lineup",
            @"kickOff",
            @"goals",
            @"redCards",
            @"ht",
            @"ft"
        ];
    });
    return _types;
}

@end
