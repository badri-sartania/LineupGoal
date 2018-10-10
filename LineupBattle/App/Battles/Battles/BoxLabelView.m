//
// Created by Anders Borre Hansen on 08/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "DefaultLabel.h"
#import "BoxLabelView.h"


@implementation BoxLabelView {
    DefaultLabel *_label;
    UIColor *_color;
    CGFloat _radius;
}

+ (instancetype)initWithText:(NSString *)text backgroundColor:(UIColor *)color borderRadius:(CGFloat)radius {
    return [[self alloc] initWithText:text backgroundColor:color borderRadius:radius];
}

- (instancetype)initWithText:(NSString *)text backgroundColor:(UIColor *)color borderRadius:(CGFloat)radius {
    self = [super init];
    if (self) {
        _label = [DefaultLabel initWithText:text];
        [_label boldSystemFontSize:12 color:[UIColor whiteColor]];
        _color = color;
        _radius = radius;
        self.backgroundColor = [UIColor clearColor];

        [self addSubview:_label];

        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }

    return self;
}

- (void)setText:(NSString *)text {
    _label.text = text;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRoundedRect:context rect:rect radius:_radius color:_color];
    [super drawRect:rect];
}

- (void) drawRoundedRect:(CGContextRef)c rect:(CGRect)rect radius:(CGFloat)corner_radius color:(UIColor *)color {
    // https://gist.github.com/digerata/500793
    CGFloat x_left = rect.origin.x;
    CGFloat x_left_center = rect.origin.x + corner_radius;
    CGFloat x_right_center = rect.origin.x + rect.size.width - corner_radius;
    CGFloat x_right = rect.origin.x + rect.size.width;

    CGFloat y_top = rect.origin.y;
    CGFloat y_top_center = rect.origin.y + corner_radius;
    CGFloat y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
    CGFloat y_bottom = rect.origin.y + rect.size.height;

    /* Begin! */
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, x_left, y_top_center);

    /* First corner */
    CGContextAddArcToPoint(c, x_left, y_top, x_left_center, y_top, corner_radius);
    CGContextAddLineToPoint(c, x_right_center, y_top);

    /* Second corner */
    CGContextAddArcToPoint(c, x_right, y_top, x_right, y_top_center, corner_radius);
    CGContextAddLineToPoint(c, x_right, y_bottom_center);

    /* Third corner */
    CGContextAddArcToPoint(c, x_right, y_bottom, x_right_center, y_bottom, corner_radius);
    CGContextAddLineToPoint(c, x_left_center, y_bottom);

    /* Fourth corner */
    CGContextAddArcToPoint(c, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
    CGContextAddLineToPoint(c, x_left, y_top_center);

    /* Done */
    CGContextClosePath(c);

    CGContextSetFillColorWithColor(c, color.CGColor);

    CGContextFillPath(c);
}



@end
