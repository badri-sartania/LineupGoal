//
// Created by Anders Borre Hansen on 29/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "UIColor+Lineupbattle.h"
#import "HexColors.h"


@implementation UIColor (Lineupbattle)

#pragma mark - New colors
+ (UIColor *)primaryColor {
    return [UIColor hx_colorWithHexString:@"#34495E"];
}

+ (UIColor *)primaryTextColor {
    return [UIColor hx_colorWithHexString:@"#2C3E50"];
}

+ (UIColor *)secondaryTextColor {
    return [UIColor hx_colorWithHexString:@"#95A5A6"];
}

+ (UIColor *)lightBorderColor {
    return [UIColor hx_colorWithHexString:@"#ECF0F1"];
}

+ (UIColor *)lightBackgroundColor {
    return [UIColor hx_colorWithHexString:@"#FAFAFA"];
}

+ (UIColor *)championsLeagueColor {
    return [UIColor hx_colorWithHexString:@"#2ECC71"];
}

+ (UIColor *)championsLeagueQualificationColor {
    return [UIColor hx_colorWithHexString:@"#F3CC32"];
}

+ (UIColor *)europaLeagueColor {
    return [UIColor hx_colorWithHexString:@"#3498DB"];
}

+ (UIColor *)relegationColor {
    return [UIColor hx_colorWithHexString:@"#E74C3C"];
}

#pragma mark - Old colors
+ (UIColor *)actionColor {
	return [UIColor hx_colorWithHexString:@"#0D9F67"];
}

+ (UIColor *)tabColor {
//    return [UIColor hx_colorWithHexString:@"#9934495E"];
    return [UIColor hx_colorWithHexString:@"#95A5A6"];
}

+ (UIColor *)highlightColor {
//    return [UIColor hx_colorWithHexString:@"#bef3c4"];
    return [UIColor hx_colorWithHexString:@"#BDC3C7"];
}

+ (UIColor *)greyBackgroundColor {
    return [UIColor hx_colorWithHexString:@"#F2F2F2"];
}

+ (UIColor *)darkGrayTextColor {
	return [UIColor hx_colorWithHexString:@"727272"];
}

+ (UIColor *)labelColor {
    return [UIColor hx_colorWithHexString:@"373533"];
}

+ (UIColor *)grayIconColor {
    return [UIColor hx_colorWithHexString:@"#A9A9A9"];
}
@end
