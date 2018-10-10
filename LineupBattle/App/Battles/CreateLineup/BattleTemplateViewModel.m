//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "BattleTemplateViewModel.h"
#import "HTTP.h"
#import "MatchesHelper.h"
#import "Lineup.h"
#import "Match.h"
#import "HTTP+RAC.h"
#import "NSMutableArray+Flatten.h"


@implementation BattleTemplateViewModel

- (instancetype)initWithEmptyLineupAndBattleTemplateId:(NSString *)battleTemplateId {
    self = [super init];

    if (self) {
        self.lineup = [[Lineup alloc] initWithEmptyFormat];
        [self setupFetch:battleTemplateId];
    }

    return self;
}

- (instancetype)initWithBattle:(Battle *)battle {
    self = [super init];

    if (self) {
        self.lineup = [[Lineup alloc] initWithPlayers:battle.currentUserPlayersWithFieldIndex formation:@[@2, @3, @3]];
        self.battle = battle;
        [self setupFetch:battle.template.objectId];
    }

    return self;
}

#pragma mark - Fetching
- (void)setupFetch:(NSString *)battleTemplateId {
    @weakify(self);

    self.loadGameTemplateCommand = [[RACCommand alloc] initWithSignalBlock:^(id value) {
        @strongify(self);
        return [[self fetchFromServerSignal:battleTemplateId] logError];
    }];

    [[[[self.loadGameTemplateCommand.executionSignals switchToLatest] map:^id (id value) {
        BattleTemplate *gameTemplate = [MTLJSONAdapter modelOfClass:BattleTemplate.class fromJSONDictionary:value error:nil];
        NSArray *matchesSortedByDateAndGrouped = [MatchesHelper sortedByDateAndGroupedByLeague:gameTemplate.matches];

        NSArray *matchesInOrder = [[[matchesSortedByDateAndGrouped bk_map:^id(NSDictionary *dic) {
            return dic[@"matches"];
        }] mutableCopy] flatten];

        NSMutableDictionary *teamDictionary = [[NSMutableDictionary alloc] init];
        [gameTemplate.teams bk_each:^(Team *team) {
            teamDictionary[team.objectId] = team;
        }];

        NSMutableArray *teamIdsInMatchOrder = [[NSMutableArray alloc] init];
        [matchesInOrder bk_each:^(Match *match) {
            if (match.home && match.home.objectId && match.away && match.away.objectId && teamDictionary[match.home.objectId] && teamDictionary[match.away.objectId]) {
                [teamIdsInMatchOrder addObject:teamDictionary[match.home.objectId]];
                [teamIdsInMatchOrder addObject:teamDictionary[match.away.objectId]];
            }
        }];

        return @{
            @"battleTemplate": gameTemplate,
            @"teamsInMatchOrder": teamIdsInMatchOrder,
            @"sortedCompetitions": [MatchesHelper sortedByDateAndGroupedByLeague:gameTemplate.matches],
            @"selectTeamStructure": [SelectTeamHelper selectPlayerDataStructure:gameTemplate.teams]
        };
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);
        self.teamsInMatchOrder = dic[@"teamsInMatchOrder"];
        self.competitions = dic[@"sortedCompetitions"];
        self.selectPlayerStructure = dic[@"selectTeamStructure"];
        self.model = dic[@"battleTemplate"];
    }];

    [[RACObserve(self, active) take:1] subscribeNext:^(id x) {
        @strongify(self);
        [self.loadGameTemplateCommand execute:nil];
    }];
}

- (RACSignal *)fetchFromServerSignal:(NSString *)battleTemplateId {
    return [[[HTTP instance] get:[NSString stringWithFormat:@"/battle-templates/%@", battleTemplateId]] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]];
}

#pragma mark - Submit team
- (RACSignal *)joinBattle {
    return [[HTTP instance] post:@"/battles/join" body:[self joinBodyWithTemplate:YES]];
}

- (RACSignal *)joinInvitedBattle {
    NSString *urlString = [NSString stringWithFormat:@"/battles/%@/join", self.battle.objectId];
    return [[HTTP instance] put:urlString body:[self joinBodyWithTemplate:NO]];
}

- (NSDictionary *)joinBodyWithTemplate:(BOOL)withTemplate {
    NSArray *playerIds = self.lineup.playerIds;

    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"players": playerIds,
        @"captain": self.lineup.captain.objectId ?: [NSNull null],
        @"inviteOnly": @(self.inviteOnly)
    }];

    if (withTemplate) body[@"template"] = self.model.objectId;
    if (self.userName) body[@"username"] = self.userName;

    return body;
}

#pragma mark - Update lineup
- (RACSignal *)updateBattleSignal {
    NSString *urlString = [NSString stringWithFormat:@"/battles/%@/lineup", self.battle.objectId];
    return [[HTTP instance] put:urlString body:[self joinBodyWithTemplate:NO]];
}

#pragma mark - Rules
- (BOOL)lessPlayersAllowedForTeam:(Team *)team {
    NSArray *players = [self.lineup players];

    NSInteger playerCountFromTeam = [players bk_select:^BOOL(Player *player) {
        return [player.team.objectId isEqualToString:team.objectId];
    }].count;

    return playerCountFromTeam < ([self.model.perTeam integerValue] ?: 2);
}

#pragma mark - Utils
- (NSArray *)teams {
    return self.model.teams;
}

@end
