//
// Created by Anders Hansen on 16/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "FadeView.h"


@implementation FadeView
- (void)layoutSubviews
{
    [super layoutSubviews];

    CALayer * maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;

    CGColorRef innerColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0].CGColor;
    CGColorRef outerColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1].CGColor;

    // first, define a horizontal gradient (left/right edges)
    CAGradientLayer* hMaskLayer = [CAGradientLayer layer];
    hMaskLayer.opacity = 1.0;
    hMaskLayer.colors = @[(__bridge id) outerColor, (__bridge id) innerColor, (__bridge id) innerColor, (__bridge id) outerColor];
    hMaskLayer.locations = @[@0.f, @0.2f, @0.8f, @1.f];
    hMaskLayer.startPoint = CGPointMake(0, 0.5);
    hMaskLayer.endPoint = CGPointMake(1.0, 0.5);
    hMaskLayer.bounds = self.bounds;
    hMaskLayer.anchorPoint = CGPointZero;

    CAGradientLayer* vMaskLayer = [CAGradientLayer layer];
    // without specifying startPoint and endPoint, we get a vertical gradient
    vMaskLayer.opacity = hMaskLayer.opacity;
    vMaskLayer.colors = hMaskLayer.colors;
    vMaskLayer.locations = hMaskLayer.locations;
    vMaskLayer.bounds = self.bounds;
    vMaskLayer.anchorPoint = CGPointZero;

    // you must add the masks to the root view, not the scrollView, otherwise
    //  the masks will move as the user scrolls!
    [self.layer addSublayer: hMaskLayer];
    //[self.layer addSublayer: vMaskLayer];
}

@end