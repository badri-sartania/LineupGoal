//
// Created by Anders Borre Hansen on 28/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import "LBMTLModel.h"


@interface League : LBMTLModel
- (NSInteger)numberOfMatches;
@property(nonatomic, strong, readonly) NSString *name;
@property(nonatomic, strong, readonly) NSString *country;
@property(nonatomic, strong, readonly) NSArray *matches;
@end
