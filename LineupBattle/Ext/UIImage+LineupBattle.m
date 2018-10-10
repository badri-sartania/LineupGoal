//
// Created by Anders Hansen on 31/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "UIImage+LineupBattle.h"


@implementation UIImage (LineupBattle)

// From http://blog.ioscodesnippet.com/post/9247898208/creating-a-placeholder-uiimage-dynamically-with-color
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)imageBlackAndWhite {
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];

    CIImage *output = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity", @1.0F, @"inputColor", [[CIColor alloc] initWithColor:[UIColor whiteColor]], nil].outputImage;

    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];

    CGImageRelease(cgiimage);

    return newImage;
}

@end
