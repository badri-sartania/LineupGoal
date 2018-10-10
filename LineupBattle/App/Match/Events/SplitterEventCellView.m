//
// Created by Anders Hansen on 19/06/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "SplitterEventCellView.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"


@implementation SplitterEventCellView
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat y = rect.size.height/2;
    CGFloat lineWidth = 1.5f;

    CGFloat rectStartX = 0;
    CGFloat rectEndX = rect.size.width;

//    CGFloat circleRadius = 17.5f;
//    CGFloat circleStartX = rect.size.width/2 - circleRadius;
//    CGFloat circleStartY = rect.size.height/2 - circleRadius;


    // Color Declarations
//    UIColor* color = [UIColor colorWithRed: 0.569f green: 0.651f blue: 0.655f alpha: 1.f];
    UIColor* color = [UIColor lightBorderColor];

    // Line
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(rectStartX, y)];
    [bezierPath addLineToPoint:CGPointMake(rectEndX, y)];
    [color setStroke];
    bezierPath.lineWidth = lineWidth;
    [bezierPath stroke];

    // Oval Drawing
//    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(circleStartX, circleStartY, circleRadius*2, circleRadius*2)];
//    [[UIColor whiteColor] setFill];
//    [ovalPath fill];
//    [color setStroke];
//    ovalPath.lineWidth = lineWidth;
//    [ovalPath stroke];
}

- (DefaultLabel *)splitterText {
    if (!_splitterText) {
        _splitterText = [DefaultLabel initWithBoldSystemFontSize:20 color:[UIColor primaryTextColor]];
        [_splitterText setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_splitterText];
        [_splitterText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@120);
        }];
        _splitterText.textAlignment = NSTextAlignmentCenter;
    }

    return _splitterText;
}

@end
