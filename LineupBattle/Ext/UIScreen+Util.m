//
// Created by Anders Hansen on 21/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "UIScreen+Util.h"

@implementation UIScreen (Util)
+ (BOOL)retinaScreen2x
{
    if (!didRetinaCheck2x) {
        isRetinaScreen2x = ([[self mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([self mainScreen].scale == 2.0));
        didRetinaCheck2x = YES;
    }
    return isRetinaScreen2x;
}

+ (BOOL)retinaScreen3x
{
    if (!didRetinaCheck3x) {
        isRetinaScreen3x = ([[self mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([self mainScreen].scale == 3.0));
        didRetinaCheck3x = YES;
    }
    return isRetinaScreen3x;
}
@end