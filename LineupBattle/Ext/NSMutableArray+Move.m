//
// Created by Anders Borre Hansen on 23/09/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "NSMutableArray+Move.h"


@implementation NSMutableArray (Move)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = self[from];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
    }
}

@end