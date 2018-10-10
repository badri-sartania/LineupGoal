//
// Created by Anders Hansen on 20/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Subscription.h"
#import <BlocksKit/NSArray+BlocksKit.h>

typedef enum {
    SubscriptionsReminder       = 1 << 0,
    SubscriptionsLineup         = 1 << 1,
    SubscriptionsKickOff        = 1 << 2,
    SubscriptionsGoals          = 1 << 3,
    SubscriptionsRedCards       = 1 << 4,
    SubscriptionsHalfTime       = 1 << 5,
    SubscriptionsFullTime       = 1 << 6,
    SubscriptionsBench          = 1 << 7,
    SubscriptionsAssists        = 1 << 8,
    SubscriptionsSubstitutions  = 1 << 9,
} Subscriptions;

@implementation Subscription

+ (NSArray *)types {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

+ (instancetype)initWithDictionary:(NSDictionary *)data {
    return [[self alloc] initWithDictionary:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {
        [self updateData:data];
    }

    return self;
}

- (void)updateData:(NSDictionary *)data {
    if (!data) return;

    @weakify(self);
    [[[self class] types] bk_each:^(NSString *key) {
        id obj = data[key];
        if (obj) {
            @strongify(self);
            [self setValue:obj forKey:key];
        }
    }];
}

- (NSUInteger)toBitMask {
    NSDictionary *bitmaskDefinition = @{
        @"reminder":        @(SubscriptionsReminder),
        @"lineup":          @(SubscriptionsLineup),
        @"kickOff":         @(SubscriptionsKickOff),
        @"goals":           @(SubscriptionsGoals),
        @"redCards":        @(SubscriptionsRedCards),
        @"ht":              @(SubscriptionsHalfTime),
        @"ft":              @(SubscriptionsFullTime),
        @"bench":           @(SubscriptionsBench),
        @"assists":         @(SubscriptionsAssists),
        @"substitutions":   @(SubscriptionsSubstitutions)
    };

    __block NSUInteger bitMask = 0;

    @weakify(self);
    [[self.class types] bk_each:^(NSString *typeName) {
        @strongify(self);
        BOOL selected = [[self valueForKey:typeName] boolValue];

        if (selected) bitMask += [bitmaskDefinition[typeName] integerValue];
    }];

    return bitMask;
}

- (NSInteger)count {
    return [[self.class types] bk_select:^BOOL(NSString *typeName) {
        return [[self valueForKey:typeName] boolValue];
    }].count;
}

@end
