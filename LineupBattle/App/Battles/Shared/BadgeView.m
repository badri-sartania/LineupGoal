//
// Created by Anders Borre Hansen on 18/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "BadgeView.h"
#import "UIColor+LineupBattle.h"


@implementation BadgeView

- (instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.color = color;
        self.backgroundColor = [UIColor clearColor];
        self.textLabel = [DefaultLabel initWithBoldSystemFontSize:8 color:[UIColor whiteColor]];
        self.badgeImageView = [[UIImageView alloc] init];
        self.borderWidth = 1.f;
        self.borderColor = [UIColor whiteColor];
        self.badgeBackgroundColor = color;
        [self addSubview:self.textLabel];
        [self addSubview:self.badgeImageView];
        [@[self.textLabel, self.badgeImageView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-0.25f);
            make.centerY.equalTo(self);
        }];
    }

    return self;
}

- (instancetype)initWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    self = [self initWithColor:color];
    
    if (self) {
        self.borderWidth = borderWidth;
    }
    
    return self;
}

- (instancetype)initWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    self = [self initWithColor:color];

    if (self) {
        self.borderWidth = borderWidth;
        self.borderColor = borderColor;
        self.badgeBackgroundColor = color;
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect borderRect = CGRectMake(self.borderWidth, self.borderWidth, rect.size.width-self.borderWidth*2, rect.size.height-self.borderWidth*2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.badgeBackgroundColor.CGColor);
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    self.badgeImageView.image = image;
}

@end
