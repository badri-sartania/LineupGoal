//
// Created by Anders Hansen on 26/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "NSArray+Reverse.h"


@implementation NSArray (Reverse)
- (NSArray *)reverse {
    return [[self reverseObjectEnumerator] allObjects];
}
@end