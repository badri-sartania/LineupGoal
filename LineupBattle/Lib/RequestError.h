//
// Created by Anders Hansen on 15/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestError : NSObject

- (id)initWithError:(NSError *)error;

- (UIImage *)image;

- (NSString *)text;
@end