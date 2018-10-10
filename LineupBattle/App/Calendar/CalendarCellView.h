//
// Created by Anders Borre Hansen on 11/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YLMoment/YLMoment.h>

@interface CalendarCellView : UIView
@property (nonatomic, assign) NSNumber *offset;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL today;
@property (nonatomic, assign) NSNumber *competitionsCount;

+ (CGFloat)height;
+ (CGFloat)width;
@end
