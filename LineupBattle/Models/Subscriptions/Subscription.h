//
// Created by Anders Hansen on 20/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscription : NSObject

// all
@property (nonatomic, strong) NSNumber *lineup;
@property (nonatomic, strong) NSNumber *goals;
@property (nonatomic, strong) NSNumber *redCards;
@property (nonatomic, strong) NSNumber *ft;

// match and team
@property (nonatomic, strong) NSNumber *reminder;
@property (nonatomic, strong) NSNumber *kickOff;
@property (nonatomic, strong) NSNumber *ht;

// player
@property (nonatomic, strong) NSNumber *bench;
@property (nonatomic, strong) NSNumber *assists;
@property (nonatomic, strong) NSNumber *substitutions;

+ (NSArray *)types;
+ (instancetype)initWithDictionary:(NSDictionary *)data;

- (void)updateData:(NSDictionary *)data;

- (NSUInteger)toBitMask;
- (NSInteger)count;
@end
