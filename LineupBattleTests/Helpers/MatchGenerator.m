//
// Created by Anders Hansen on 15/06/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "MatchGenerator.h"
#import <BlocksKit/NSArray+BlocksKit.h>


@implementation MatchGenerator

- (id)initWithOptions:(NSDictionary *)options {
    self = [super init];
    if (self) {
       self.rawMatch = [[NSMutableDictionary alloc] initWithDictionary:options];

       if (!self.rawMatch[@"_id"]) {
           [self.rawMatch setObject: [NSString stringWithFormat:@"id_%D", arc4random() % 16] forKey:@"_id"];
       }
    }

    return self;
}

- (void)createEvents:(NSDictionary *)options {
    NSMutableDictionary *mOptions = [[NSMutableDictionary alloc] initWithDictionary:options];

    if (options[@"clock"]) {
        [mOptions setObject:[(NSArray *)mOptions[@"clock"] bk_map:^id(NSString *clock) {
            NSArray *parts = [clock componentsSeparatedByString:@"+"];

            if (parts.count == 1) {
                return @{
                    @"minutes": parts[0]
                };
            } else {
                return @{
                    @"minutes": parts[0],
                    @"overtime": parts[1]
                };
            }
        }] forKey:@"when"];
    }

    [self.rawMatch setObject:[self parseOptionIntoArrayWithObjects:mOptions] forKey:@"events"];
}

- (Match *)toMatch {
    return [Match dictionaryTransformer:self.rawMatch];
}

- (NSArray *)parseOptionIntoArrayWithObjects:(NSDictionary *)dictionary {
    NSMutableArray *array = [[NSMutableArray alloc] init];

    // This uses the assumption that each key has an array with same number of entries as other keys
    NSInteger count = ((NSArray *)dictionary[[dictionary allKeys][0]]).count;

    for (int i = 0; i < count; ++i) {
        NSMutableDictionary *object = [[NSMutableDictionary alloc] init];

        [[dictionary allKeys] bk_each:^(NSString *key) {
            [object setObject:dictionary[key][i] forKey:key];
        }];

        [array addObject:object];
    }

    return array;
}

@end
