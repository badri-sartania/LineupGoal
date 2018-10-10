//
// Created by Thomas Watson on 16/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "NSDate+Lineupbattle.h"


@implementation NSDate (Lineupbattle)

- (BOOL)isToday {
    return [self isSameDayAs:[NSDate date]];
}

- (BOOL)isInThePast {
    return [self lessThan:[NSDate date]];
}

- (BOOL)isInTheFuture {
    return [self greaterThan:[NSDate date]];
}

- (BOOL)greaterThan:(NSDate *)date {
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)lessThan:(NSDate *)date {
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)isSameDayAs:(NSDate *)date {
    if (!date) return NO;

    NSDateComponents *a = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *b = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];

    return [a day] == [b day] &&
        [a month] == [b month] &&
        [a year] == [b year] &&
        [a era] == [b era];
}

- (NSInteger)numberOfDaysUntil:(NSDate *)date {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:date options:0];
    return [components day];
}

@end
