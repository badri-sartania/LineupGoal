//
// Created by Thomas Watson on 16/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Lineupbattle)

- (BOOL)isToday;
- (BOOL)isInThePast;
- (BOOL)isInTheFuture;
- (BOOL)greaterThan:(NSDate *)date;
- (BOOL)lessThan:(NSDate *)date;
- (BOOL)isSameDayAs:(NSDate *)date;
- (NSInteger)numberOfDaysUntil:(NSDate *)date;

@end
