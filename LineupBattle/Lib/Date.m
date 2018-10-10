//
//  Date.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 01/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import "Date.h"
#import "NSDate+Lineupbattle.h"

@implementation Date

+ (NSString *)getRequestDateFormat:(NSDate *)date {
    if (!date) return nil;

    // Setup calendar
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *gregorianDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];

    // Setup formatter with timezone and locale so it can enforce gregorian calendar
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setCalendar:calendar];
    [format setLocale:[NSLocale systemLocale]];
    [format setTimeZone:[NSTimeZone systemTimeZone]];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:gregorianDate];

    return dateString;
}

+ (NSString *)dateToISO8601String:(NSDate *)date {
    if (!date) return nil;

    // Setup calendar
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *gregorianDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];

    // Setup formatter with timezone and locale so it can enforce gregorian calendar
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setCalendar:calendar];
    [format setLocale:[NSLocale systemLocale]];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z"];
    NSString *dateString = [format stringFromDate:gregorianDate];

    return dateString;
}

+ (YLMoment *)stringToYLMoment:(NSString *)stringDate {
    return [YLMoment momentWithDate:[Date stringToDate:stringDate]];
}

+ (NSDate *)stringToDate:(NSString *)stringDate {
    static NSDateFormatter *dateFormatter = nil;

    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
    }

    return [dateFormatter dateFromString:stringDate];
}

#pragma mark - Calendar Data Generation
+ (NSArray *)getCalendarData:(NSDate *)from to:(NSDate *)to {
    NSArray *dates = [[NSArray alloc] initWithArray:[Date createDateArray:from to:to]];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < dates.count; i++) {
        YLMoment *moment = [YLMoment momentWithDate:dates[i]];
        NSNumber *isToday = @([moment.date isToday]);
        [data addObject:@{@"date": moment, @"weekDay": [moment format:@"E"], @"day": [moment format:@"dd"], @"year": [moment format:@"MMMM yyyy"], @"today":isToday }];
    }
    return data;
}

+ (NSArray *)createDateArray:(NSDate *)fromDate to:(NSDate *)toDate {
    NSInteger numberOfDays = [fromDate numberOfDaysUntil:toDate];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:fromDate];

    for (NSUInteger i = 1; i < numberOfDays; i++) {
        [offset setDay:i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:fromDate options:0];
        [dates addObject:nextDay];
    }

    return dates;
};

+ (NSString *)timezone {
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;

    return [Date formatTimezone:timeZoneOffset];
}

+ (NSString *)formatTimezone:(NSInteger)offset {
    NSString *prepend;

    if (offset > 0) {
        if (offset < 10) {
            prepend = @"+0";
        } else {
            prepend = @"+";
        }
    } else if (offset < 0) {
        if (offset > -10) {
            offset = offset*-1;
            prepend = @"-0";
        } else {
            prepend = @"";
        }
    } else {
        prepend = @"0";
    }

    return [NSString stringWithFormat:@"%@%ld:00", prepend, (long)offset];
}

+ (NSInteger)ageByDate:(NSDate *)birthday {
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
            components:NSCalendarUnitYear
              fromDate:birthday
                toDate:now
               options:0];
    return [ageComponents year];
}

@end
