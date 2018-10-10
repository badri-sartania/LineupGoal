//
// Created by Thomas Watson on 05/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Spinner.h"
#import "Utils.h"


@implementation Spinner

+ (id)initWithDefaultPositionAndWithSuperView:(UIView *)view {
    return [[self alloc] initWithDefaultPositionAndWithSuperView:view];
}

+ (id)initWithSuperView:(UIView *)view {
    return [[self alloc] initWithSuperView:view];
}

- (id)initWithDefaultPositionAndWithSuperView:(UIView *)view {
   self = [self initWithSuperView:view];

   if (self) {
       CGFloat screenWidth = [Utils screenWidth];
       CGFloat size = 20.f;
       self.frame = CGRectMake((screenWidth/2.f)-(size/2.f), 100.f, size, size);
   }

   return self;
}

- (id)initWithSuperView:(UIView *)view {
   self = [super initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

   if (self) {
       [view addSubview:self];
   }

   return self;
}

@end