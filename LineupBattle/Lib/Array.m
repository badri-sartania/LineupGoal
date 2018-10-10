//
// Created by Anders Hansen on 31/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Array.h"
#import "YLMoment+Compare.h"


@implementation Array

+ (NSArray *)removeFromStart:(NSInteger)i from:(NSArray *)array {
    NSMutableArray *editableArray = [NSMutableArray arrayWithArray:array];
    NSArray *toRemove = [array subarrayWithRange:NSMakeRange(0,i)];
    [editableArray removeObjectsInArray:toRemove];
    return [NSArray arrayWithArray:editableArray];
}

+ (NSArray *)removeFromEnd:(NSInteger)i from:(NSArray *)array {
    NSMutableArray *editableArray = [NSMutableArray arrayWithArray:array];
    NSArray *toRemove = [array subarrayWithRange:NSMakeRange(array.count-i,20)];
    [editableArray removeObjectsInArray:toRemove];
    return [NSArray arrayWithArray:editableArray];
}

+ (NSArray *)sortArrayWithDictionaries:(NSArray *)array key:(NSString *)key assending:(BOOL)assending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:assending];
    return [array sortedArrayUsingDescriptors:@[sortDescriptor]];
}


@end