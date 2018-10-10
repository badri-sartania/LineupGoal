//
// Created by Anders Hansen on 22/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <objc/runtime.h>
#import "AbstractViewModel.h"


@implementation AbstractViewModel
- (NSString *)classNameAsString {
    return [NSString stringWithUTF8String:class_getName([self class])];
}
@end