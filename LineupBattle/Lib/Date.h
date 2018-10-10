//
//  Date.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 01/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YLMoment/YLMoment.h>

@interface Date : NSObject

+ (NSString *)getRequestDateFormat:(NSDate *)moment;
+ (NSString *)dateToISO8601String:(NSDate *)date;

+ (YLMoment *)stringToYLMoment:(NSString *)stringDate;

+ (NSDate *)stringToDate:(NSString *)stringDate;

+ (NSArray *)getCalendarData:(NSDate *)from to:(NSDate *)to;
+ (NSArray *)createDateArray:(NSDate *)fromDate to:(NSDate *)toDate;
+ (NSString *)timezone;

+ (NSString *)formatTimezone:(NSInteger)offset;

+ (NSInteger)ageByDate:(NSDate *)birthday;
@end
