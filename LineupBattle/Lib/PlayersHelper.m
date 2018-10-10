//
// Created by Anders Borre Hansen on 21/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "PlayersHelper.h"
#import "Player.h"


@implementation PlayersHelper

+ (NSArray *)filterPlayers:(NSArray *)players byPosition:(NSString *)position {
    return [players bk_select:^BOOL(Player *player) {
        return [player.position isEqualToString:position];
    }];
}

+ (NSArray *)sortPlayers:(NSArray *)players {
    return [[[NSArray alloc] initWithArray:players] sortedArrayUsingComparator:^NSComparisonResult(Player *a, Player *b) {
        if (!a.stats[@"goals"] && !b.stats[@"goals"]) return NSOrderedAscending;
        if (a.stats[@"goals"] && !b.stats[@"goals"]) return NSOrderedAscending;
        if (b.stats[@"goals"] && !a.stats[@"goals"]) return NSOrderedDescending;

        NSComparisonResult result = [b.stats[@"goals"] compare:a.stats[@"goals"]];

        if (result == NSOrderedSame) {
            if (!a.stats[@"assists"] && !b.stats[@"assists"]) return NSOrderedAscending;
            if (a.stats[@"assists"] && !b.stats[@"assists"]) return NSOrderedAscending;
            if (b.stats[@"assists"] && !a.stats[@"assists"]) return NSOrderedDescending;
            result = [b.stats[@"assists"] compare:a.stats[@"assists"]];
        }

        if (result == NSOrderedSame) {
            if (!a.stats[@"mp"] && !b.stats[@"mp"]) return NSOrderedAscending;
            if (a.stats[@"mp"] && !b.stats[@"mp"]) return NSOrderedAscending;
            if (b.stats[@"mp"] && !a.stats[@"mp"]) return NSOrderedDescending;
            result = [b.stats[@"mp"] compare:a.stats[@"mp"]];
        }

        return result;
    }];
}

@end