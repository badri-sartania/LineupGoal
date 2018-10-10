//
// Created by Anders Hansen on 21/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

@interface UIScreen (Util)
+ (BOOL)retinaScreen2x;

+ (BOOL)retinaScreen3x;
@end

static BOOL isRetinaScreen2x = NO;
static BOOL didRetinaCheck2x = NO;
static BOOL isRetinaScreen3x = NO;
static BOOL didRetinaCheck3x = NO;