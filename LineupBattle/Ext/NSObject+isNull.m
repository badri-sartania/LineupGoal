//
// Created by Anders Hansen on 11/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "NSObject+isNull.h"


@implementation NSArray (isNull)
- (BOOL)isNull {
    return self == (id)[NSNull null];
}
@end