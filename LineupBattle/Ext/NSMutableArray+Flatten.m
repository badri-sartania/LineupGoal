//
// Created by Anders Borre Hansen on 24/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "NSMutableArray+Flatten.h"


@implementation NSMutableArray (Flatten)

- (NSArray *)flatten {
    return [self valueForKeyPath: @"@unionOfArrays.self"];
}

@end