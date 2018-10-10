//
// Created by Anders Borre Hansen on 21/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "XPBarView.h"
#import "UIColor+LineupBattle.h"


@implementation XPBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)setProcentage:(NSInteger)procentage {
    _procentage = procentage;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    _procentage = _procentage == 0 ? 2 : _procentage;

    CGFloat procentageInRect = (rect.size.width / 100) * _procentage;
    CGFloat height = 5.f;

    UIRectCorner allCorners  = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerBottomLeft;
    UIRectCorner onlyLeftCorners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    UIRectCorner procentageWithRound = procentageInRect == 100 ? allCorners : onlyLeftCorners;

    // Background
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.f, 0.f, rect.size.width, height) byRoundingCorners:allCorners cornerRadii:CGSizeMake(2.5, 2.5)];
    [rectangle2Path closePath];
    [[UIColor greyBackgroundColor] setFill];
    [rectangle2Path fill];

    //// Procentage overlay
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.f, 0.f, procentageInRect, height) byRoundingCorners:procentageWithRound cornerRadii:CGSizeMake(2.5, 2.5)];
    [rectanglePath closePath];
    [[UIColor actionColor] setFill];
    [rectanglePath fill];
}

@end
