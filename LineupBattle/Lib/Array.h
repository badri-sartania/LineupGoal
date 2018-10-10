//
// Created by Anders Hansen on 31/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Array : NSObject


+ (NSArray *)removeFromStart:(NSInteger)i from:(NSArray *)array;
+ (NSArray *)removeFromEnd:(NSInteger)i from:(NSArray *)array;

+ (NSArray *)sortArrayWithDictionaries:(NSArray *)array key:(NSString *)key assending:(BOOL)assending;
@end