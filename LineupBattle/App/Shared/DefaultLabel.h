//
// Created by Anders Borre Hansen on 28/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface DefaultLabel : UILabel
+ (DefaultLabel *)init;
+ (DefaultLabel *)initWithNanumFontSize:(CGFloat)size color:(UIColor *)color;
+ (DefaultLabel *)initWithSystemFontSize:(CGFloat)size;
+ (DefaultLabel *)initWithSystemFontSize:(CGFloat)size color:(UIColor *)color;
+ (DefaultLabel *)initWithLightSystemFontSize:(CGFloat)size;
+ (DefaultLabel *)initWithLightSystemFontSize:(CGFloat)size color:(UIColor *)color;
+ (DefaultLabel *)initWithMediumSystemFontSize:(CGFloat)size;
+ (DefaultLabel *)initWithMediumSystemFontSize:(CGFloat)size color:(UIColor *)color;
+ (DefaultLabel *)initWithBoldSystemFontSize:(CGFloat)size;
+ (DefaultLabel *)initWithBoldSystemFontSize:(CGFloat)size color:(UIColor *)color;
+ (DefaultLabel *)initWithCondensedBoldSystemFontSize:(CGFloat)size;
+ (DefaultLabel *)initWithCondensedBoldSystemFontSize:(CGFloat)size color:(UIColor *)color;
+ (DefaultLabel *)initWithText:(NSString *)text;
+ (DefaultLabel *)initWithColor:(UIColor *)color;
+ (DefaultLabel *)initWithAlignment:(NSTextAlignment)alignment;
+ (DefaultLabel *)initWithCenterText:(NSString *)text;
+ (DefaultLabel *)initWithSystemFontSize:(CGFloat)size weight:(CGFloat)weight;
+ (DefaultLabel *)initWithFont:(NSString *)fontName size:(CGFloat)size color:(UIColor *)color;

- (void)systemFontSize:(CGFloat)size color:(UIColor *)color;
- (void)boldSystemFontSize:(CGFloat)size color:(UIColor *)color;
@end
