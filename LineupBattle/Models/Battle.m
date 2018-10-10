//
// Created by Anders Borre Hansen on 24/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import <YLMoment/YLMoment.h>
#import "LBMTLModel.h"
#import "Battle.h"
#import "NSDate+LineupBattle.h"
#import "LBMTLModel.h"
#import "Player.h"


@implementation Battle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"objectId": @"_id",
        @"name": @"name",
        @"subscribed": @"subscribed",
        @"pot": @"pot",
        @"users": @"users",
        @"matches": @"matches",
        @"points": @"points",
        @"template": @"template",
        @"pos": @"pos",
        @"xp": @"xp",
        @"finished": @"finished",
        @"win": @"win",
        @"inviteOnly": @"inviteOnly",
        @"invitedBy": @"invitedBy",
        @"invited": @"invited",
        @"chatToken": @"chatToken"
    };
}

+ (NSValueTransformer *)invitedByJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)invitedJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[User class]];
}

- (NSString *)battleName {
    return self.name ?: self.template.name ?: @"";
}

#pragma mark - Current User
- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [self.users bk_match:^BOOL(User *user) {
            return [user.current boolValue];
        }];
    }

    return _currentUser;
}

- (NSArray *)currentUserPlayersWithFieldIndex {
    NSArray *players = self.currentUser.players;

    __block NSInteger i = 0;
    [players bk_each:^(Player *player) {
        player.fieldIndex = @(i++);
    }];

    return players;
}


- (BattleTemplateState)state {
    if (self.finished) {
        return BattleTemplateStateEnded;
    } else if ([self.template.startDate isInTheFuture]) {
        return BattleTemplateStateNotStarted;
    } else {
        return BattleTemplateStateOngoing;
    }
}

- (NSString *)stateString {
    switch ([self state]) {
        case BattleTemplateStateOngoing:
            return @"Live";
        case BattleTemplateStateEnded:
            return @"Ended";
        default: return [NSString stringWithFormat:@"Starts %@", [[YLMoment momentWithDate:self.template.startDate] fromNow]];
    }
}

// Helpers
- (BOOL)isFull {
    return self.invited.count + self.users.count >= [self.template.maxUsers integerValue];
}

@end
