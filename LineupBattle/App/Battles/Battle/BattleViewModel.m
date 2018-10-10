//
// Created by Anders Borre Hansen on 26/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "BattleViewModel.h"
#import "HTTP.h"
#import "PointsCalculation.h"
#import "Array.h"
#import "Match.h"
#import "Utils.h"
#import "Identification.h"
#import "SimpleLocale.h"
#import "HTTP+RAC.h"


@interface BattleViewModel ()
@property(nonatomic, strong) RACCommand *loadGameTemplateCommand;
@property(nonatomic, copy) NSString *battleId;
@property(nonatomic, strong) RACDisposable *autoupdaterSignalDisposable;
@property(nonatomic, strong) NSArray *sortedUsers;
@end

@implementation BattleViewModel

- (instancetype)initWithModelDictionary:(NSDictionary *)modelDic {
    self = [super init];

    if (self) {
        self.battleId = modelDic[@"_id"];
        [self processData:modelDic];
        [self setupBattle];
    }

    return self;
}

- (instancetype)initWithBattleId:(NSString *)battleId {
    self = [super init];

    if (self) {
        self.battleId = battleId;
        [self setupBattle];
    }

    return self;
}

- (void)setupBattle {
    @weakify(self);

    // Fething commands
    self.loadGameTemplateCommand = [[RACCommand alloc] initWithSignalBlock:^(id value) {
        @strongify(self);
        return [[self getBattleSignal:self.battleId] logError];
    }];

    self.loadGameTemplateCommandWithoutErrorNotification = [[RACCommand alloc] initWithSignalBlock:^(id value) {
        @strongify(self);
        return [[self getBattleSignal:self.battleId] logError];
    }];

    // Command data responders
    [[self.loadGameTemplateCommand.executionSignals switchToLatest] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);
        [self processData:dic];
        [Utils hideConnectionErrorNotification];
    } error:^(NSError *error) {
        [Utils showConnectionErrorNotification];
    }];

    [[self.loadGameTemplateCommandWithoutErrorNotification.executionSignals switchToLatest] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);
        [self processData:dic];
    }];

    // Handle active state of view
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.loadGameTemplateCommand execute:nil];

        if (!self.autoupdaterSignalDisposable) {
            self.autoupdaterSignalDisposable = [[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
                @strongify(self);
                [self.loadGameTemplateCommandWithoutErrorNotification execute:nil];
            }];
        }
    }];
    
    [self.didBecomeInactiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.autoupdaterSignalDisposable dispose];
        self.autoupdaterSignalDisposable = nil;
    }];
}

#pragma mark - Data processing
- (void)processData:(NSDictionary *)data {
    self.model = [MTLJSONAdapter modelOfClass:[Battle class] fromJSONDictionary:data error:NULL];

    // Only start chat if user is in battle
    /*if (!self.chatHandler && self.model.currentUser) {
        self.chatHandler = [[ChatHandler alloc] initFirebaseWithId:self.model.chatToken ?: self.battleId];
    }

    if (self.chatHandler) {
        [self.chatHandler setUserDictionary:self.model.users];
        [self.chatHandler setCurrentUser:self.model.currentUser];
    }*/
}

#pragma mark - Reloading data
- (RACSignal *)refreshDataSignal {
   return [self.loadGameTemplateCommand execute:nil];
}

#pragma mark - Server
- (RACSignal *)getBattleSignal:(NSString *)battleId {
    return [self fetchFromServerSignal:battleId];
}

- (RACSignal *)fetchFromServerSignal:(NSString *)battleId {
    return [[HTTP instance] get:[NSString stringWithFormat:@"/battles/%@", battleId]];
}

#pragma mark - Data formatting
+ (NSArray *)sortUsersByPoints:(NSArray *)users {
    return [users sortedArrayUsingComparator:^NSComparisonResult(User *user1, User *user2) {
        return [user2.points compare:user1.points];
    }];
}

+ (NSArray *)sortedPlayersWithModel:(Battle *)battle {
    NSArray *players = [[battle.users bk_reduce:[[NSMutableDictionary alloc] init] withBlock:^id(NSMutableDictionary *players, User *user) {
        [user.players bk_each:^(Player *player) {
            players[player.objectId] = player;
        }];

        return players;
    }] allValues];

    [players bk_each:^(Player *player) {
        player.points = [PointsCalculation pointsForPlayer:player points:battle.points];
    }];

    return [Array sortArrayWithDictionaries:players key:@"points" assending:NO];
}

#pragma mark - subscriptions
- (void)subscribeToAllMatches {
    [self updateForMatchIds:[self.model.matches bk_map:^id (Match *match) {
        return match.objectId;
    }]];
}

- (void)subscribeToLineupMatches {
    NSArray *teamIds = [self.model.currentUser.players bk_map:^id(Player *player) {
        return player.team.objectId;
    }];

    NSArray *matchesInLineupIds = [[self.model.matches bk_select:^BOOL(Match *match) {
        return [teamIds containsObject:match.home.objectId] || [teamIds containsObject:match.away.objectId];
    }] bk_map:^id(Match *match) {
        return match.objectId;
    }];

    [self updateForMatchIds:matchesInLineupIds];
}

- (void)removeBattleSubscriptions {
    [self updateForMatchIds:nil];
}

- (void)updateForMatchIds:(NSArray *)matchIds {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    if (matchIds && matchIds.count > 0) {
        [params setDictionary:@{
            @"reminder": @YES,
            @"end": @YES,
            @"matches": matchIds
        }];
    } else {
        [params setDictionary:@{
            @"reminder": @NO,
            @"end": @NO
        }];
    }

    NSString *apnToken = [Identification apnDeviceToken];
    if (apnToken && ![apnToken isEqualToString:@""]) {
        params[@"token"] = apnToken;
    }

    if (self.model.objectId) {
        params[@"battleId"] = self.model.objectId;
    }

    [[[HTTP instance] put:[NSString stringWithFormat:@"/battles/%@/subscribe", self.model.objectId] body:params] subscribeNext:^(id x) {}];
}

- (void)handleSubscriptionChoice:(BattleNotificationControl)state {
    switch (state) {
        case BattleNotificationControlNoMatches:
            [self removeBattleSubscriptions];
            break;
        case BattleNotificationControlAllMatches: {
            [self subscribeToAllMatches];
            [self showAPNDialogIfNeeded:^{}];
            break;
        }
        case BattleNotificationControlLineupMatches: {
            [self subscribeToLineupMatches];
            [self showAPNDialogIfNeeded:^{}];
            break;
        }
        default:
            break;
    }
}

- (void)showAPNDialogIfNeeded:(void (^)())accepted {
    [APNHelper doubleConfirmationWithTitle:@"Improve your experience" message:[NSString stringWithFormat:@"To give you updates on %@ we need your permission", [SimpleLocale USAlternative:@"games" forString:@"matches"]] accepted:^{
        [Utils registerForAPN];
        accepted();
    }];
}

- (NSString *)formationString {
    return self.model.template.formation ? [self.model.template.formation componentsJoinedByString:@"-"] : @"";
}

- (NSInteger)leaderboardPositionOfUser:(User *)user {
    return [[BattleViewModel sortUsersByPoints:self.model.users] indexOfObject:user]+1;
}

#pragma mark - Invites
- (RACSignal *)addInvites:(NSArray *)invites unInvite:(NSArray *)invite {
    return [[HTTP instance] put:[NSString stringWithFormat:@"/battles/%@/invite", self.model.objectId] body:@{
            @"invite" : invites
    }];
}

@end
