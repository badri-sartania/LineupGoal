//
// Created by Anders Borre Hansen on 28/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import "DefaultLabel.h"
#import "HexColors.h"


@implementation DefaultLabel

+ (DefaultLabel *)init {
    DefaultLabel *label = [[DefaultLabel alloc] init];
    return label;
}

+ (DefaultLabel *)initWithNanumFontSize:(CGFloat)size color:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"NanumPen" size:size];
    label.textColor = color;
    
    return label;
}

+ (DefaultLabel *)initWithSystemFontSize:(CGFloat)size {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:size];

    return label;
}

+ (DefaultLabel *)initWithSystemFontSize:(CGFloat)size color:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:size];
    label.textColor = color;

    return label;
}

+ (DefaultLabel *)initWithLightSystemFontSize:(CGFloat)size {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    
    return label;
}

+ (DefaultLabel *)initWithLightSystemFontSize:(CGFloat)size color:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    label.textColor = color;
    
    return label;
}

+ (DefaultLabel *)initWithMediumSystemFontSize:(CGFloat)size {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
    
    return label;
}

+ (DefaultLabel *)initWithMediumSystemFontSize:(CGFloat)size color:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
    label.textColor = color;
    
    return label;
}

+ (DefaultLabel *)initWithBoldSystemFontSize:(CGFloat)size {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];

    return label;
}

+ (DefaultLabel *)initWithBoldSystemFontSize:(CGFloat)size color:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
    label.textColor = color;

    return label;
}

+ (DefaultLabel *)initWithCondensedBoldSystemFontSize:(CGFloat)size {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
    
    return label;
}

+ (DefaultLabel *)initWithCondensedBoldSystemFontSize:(CGFloat)size color:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
    label.textColor = color;
    
    return label;
}

+ (DefaultLabel *)initWithText:(NSString *)text {
    DefaultLabel *label = [DefaultLabel init];
    label.text = text;

    return label;
}

+ (DefaultLabel *)initWithColor:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.textColor = color;

    return label;
}

+ (DefaultLabel *)initWithAlignment:(NSTextAlignment)alignment {
    DefaultLabel *label = [DefaultLabel init];
    label.textAlignment = alignment;

    return label;
}

+ (DefaultLabel *)initWithCenterText:(NSString *)text {
    DefaultLabel *label = [DefaultLabel init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;

    return label;
}

+ (DefaultLabel *)initWithSystemFontSize:(CGFloat)size weight:(CGFloat)weight {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont systemFontOfSize:size weight:weight];

    return label;
}

+ (DefaultLabel *)initWithFont:(NSString *)fontName size:(CGFloat)size color:(UIColor *)color {
    DefaultLabel *label = [DefaultLabel init];
    label.font = [UIFont fontWithName:fontName size:size];
    label.textColor = color;
    
    return label;
}

- (id)init {
    self = [super init];

    if (self) {
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.textColor = [UIColor hx_colorWithHexString:@"#373533"];
    }

    return self;
}

- (void)systemFontSize:(CGFloat)size color:(UIColor *)color {
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:size];
    self.textColor = color;
}

- (void)boldSystemFontSize:(CGFloat)size color:(UIColor *)color {
    self.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
    self.textColor = color;
}

@end
