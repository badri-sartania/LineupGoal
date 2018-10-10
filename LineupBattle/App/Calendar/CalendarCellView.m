//
// Created by Anders Borre Hansen on 11/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "CalendarCellView.h"
#import "LeaguesIndicatorView.h"
#import "DefaultLabel.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"

@interface CalendarCellView ()
@property (strong, nonatomic) DefaultLabel* month;
@property (strong, nonatomic) DefaultLabel* day;
@property (strong, nonatomic) LeaguesIndicatorView *indicator;
@end

@implementation CalendarCellView

+ (CGFloat)height {
    static CGFloat height = 84.f;
    return height;
}

+ (CGFloat)width {
    static CGFloat width = 64.f;
    return width;
}

- (id)init {
    CGRect frame = CGRectMake(0.f, 0.f, [CalendarCellView width], [CalendarCellView height]);
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self addSubview:self.month];
        [self addSubview:self.day];

        CALayer *rightBorder = [CALayer layer];
        rightBorder.frame = CGRectMake([CalendarCellView width], 0.f, 0.5f, frame.size.height);
        rightBorder.backgroundColor = [UIColor hx_colorWithHexString:@"#96a5a6"].CGColor;
        [self.layer addSublayer:rightBorder];

        @weakify(self);
        [[RACObserve(self, competitionsCount) ignore:nil] subscribeNext:^(NSNumber *count) {
            @strongify(self);
            [self updateLeaguesIndicatorCount:count];
        }];
    }

    return self;
}

- (void)updateLeaguesIndicatorCount:(NSNumber *)count {
    if (!self.indicator) {
        NSUInteger intCount = (NSUInteger)[count integerValue];
        if (intCount == 0) return;
        static CGFloat const margin = 7.f;
        CGRect frame = CGRectMake(margin, 59.f, self.bounds.size.width - margin * 2.f, 20.f);
        self.indicator = [[LeaguesIndicatorView alloc] initWithCompetitionCount:intCount andFrame:frame];
        [self addSubview:self.indicator];
    } else {
        [self.indicator updateCompetitionCount:(NSUInteger)[count integerValue]];
    }
}

- (void)setCompetitionsCount:(NSNumber *)competitionsCount {
    if (competitionsCount && [_competitionsCount isEqualToNumber:competitionsCount]) return;
    _competitionsCount = competitionsCount ?: @(0);
}

- (void)setDate:(NSDate *)date {
    _date = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    dateFormatter.dateFormat = @"E";
    self.month.text = [[dateFormatter stringFromDate:date] capitalizedString];

    dateFormatter.dateFormat = @"dd";
    self.day.text = [[dateFormatter stringFromDate:date] capitalizedString];

    NSDateComponents *refDate = [[NSCalendar currentCalendar] components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSDateComponents *today   = [[NSCalendar currentCalendar] components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    self.today = [today day] == [refDate day] && [today month] == [refDate month] && [today year] == [refDate year] && [today era] == [refDate era];

    // Update styling to transform to/from a "today" cell
    self.month.font = self.today ? [UIFont boldSystemFontOfSize:12] : [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    self.day.font = self.today ? [UIFont boldSystemFontOfSize:22] : [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    self.month.textColor = self.today ? [UIColor actionColor] : [UIColor darkGrayColor];
}

#pragma mark - Views

- (DefaultLabel *)month {
    if (!_month) {
        _month = [DefaultLabel init];
        _month.frame = CGRectMake(0, 15, self.bounds.size.width, 10);
        _month.textAlignment = NSTextAlignmentCenter;
    }

    return _month;
}

- (DefaultLabel *)day {
    if (!_day) {
        _day = [DefaultLabel initWithColor:[UIColor actionColor]];
        _day.frame = CGRectMake(0, 30, self.bounds.size.width, 20);
        _day.textAlignment = NSTextAlignmentCenter;
    }

    return _day;
}

@end
