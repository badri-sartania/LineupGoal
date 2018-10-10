//
// Created by Anders Borre Hansen on 21/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "Lineup.h"
#import "Player.h"
#import "NSMutableArray+Flatten.h"


@implementation Lineup

+(NSArray *)withPlayers:(NSArray *)players formation:(NSArray *)formation {
    if (players.count == 0) return @[];

    NSArray *playersWithFieldIndex = [Lineup playersWithFieldIndex:players];
    NSArray *sortedPlayers = [Lineup sortPlayersByFieldIndex:playersWithFieldIndex];

    __block NSMutableArray *lineup = [[NSMutableArray alloc] init];
    __block NSInteger formationArrayPosition = 0;
    __block NSInteger currentNumberOfPlayersAddedForPosition = 0;

    [sortedPlayers bk_each:^(Player *player) {
        // Safe guard - for some reason we have more players than there is room in the formation - just abort
        if (formationArrayPosition >= formation.count) return;

        // Add goalkeeper. Not part of formation
        if ([player.fieldIndex intValue] == 0) {
            [lineup addObject:[@[player] mutableCopy]];
            return;
        }

        // If lineup line do not exist create
        if (lineup.count-1 == formationArrayPosition) {
            [lineup addObject:[[NSMutableArray alloc] init]];
        }

        [lineup[lineup.count-1] addObject:player];

        NSInteger playersCountForPosition = [formation[(NSUInteger)formationArrayPosition] integerValue];
        currentNumberOfPlayersAddedForPosition++;

        if (currentNumberOfPlayersAddedForPosition == playersCountForPosition) {
            formationArrayPosition++;
            currentNumberOfPlayersAddedForPosition = 0;
        }
    }];

    return lineup;
}

+ (NSArray *)playersWithFieldIndex:(NSArray *)players {
    return [players bk_reject:^BOOL(Player *obj) {
        return !obj.fieldIndex;
    }];
}

+ (NSArray *)sortPlayersByFieldIndex:(NSArray *)players {
    // Sort player by fieldindex
    NSArray *sortedPlayers = [players sortedArrayUsingComparator:^NSComparisonResult(Player *a, Player *b) {
        if (!a.fieldIndex) return NSOrderedAscending;
        if (!b.fieldIndex) return NSOrderedDescending;
        return [a.fieldIndex compare:b.fieldIndex];
    }];

    return sortedPlayers;
}

+ (NSArray *)applyFieldIndexToLineup:(NSArray *)lineupArray {
    __block NSInteger i = 0;

    [lineupArray bk_each:^(Player *player) {
        if ([player isKindOfClass:[Player class]]) {
            player.fieldIndex = @(i++);
        }
    }];

    return lineupArray;
}

+ (NSMutableArray *)emptyLineup {
    return [[NSMutableArray alloc] initWithArray:@[
        [[NSMutableArray alloc] initWithArray:@[
            [Player initEmptyWithPosition:@"gk"]
        ]],
        [[NSMutableArray alloc] initWithArray:@[
            [Player initEmptyWithPosition:@"df"],
            [Player initEmptyWithPosition:@"df"]
        ]],
        [[NSMutableArray alloc] initWithArray:@[
            [Player initEmptyWithPosition:@"mf"],
            [Player initEmptyWithPosition:@"mf"],
            [Player initEmptyWithPosition:@"mf"]
        ]],
        [[NSMutableArray alloc] initWithArray:@[
            [Player initEmptyWithPosition:@"fw"],
            [Player initEmptyWithPosition:@"fw"]
        ]]
    ]];
}

#pragma mark - Init
- (id)initWithPlayers:(NSArray *)array formation:(NSArray *)formation {
    self = [super init];

    if (self) {
        self.lineup = [[Lineup withPlayers:array formation:formation] mutableCopy];
    }

    return self;
}

- (id)initWithEmptyFormat {
    self = [super init];

    if (self) {
        self.lineup = [Lineup emptyLineup];
    }

    return self;
}

#pragma setters
- (void)setLineupPlayerForIndexPath:(NSIndexPath *)indexPath player:(Player *)player {
    NSMutableArray *lineup = [self.lineup mutableCopy];
    [lineup[(NSUInteger)indexPath.section] replaceObjectAtIndex:(NSUInteger)indexPath.row withObject:player];
    [self setLineup:lineup];
}

- (void)setLineup:(NSArray *)lineup {
    _lineup = lineup;
    _lineupFlatten = [[lineup mutableCopy] flatten];
    _players = [self compilePlayers];
    _playerIds = [self compilePlayerIds];
    _captain = [self findCaptain];
}

- (NSArray *)compilePlayers {
    return [self.lineupFlatten bk_reject:^BOOL(Player *player) {
        return [player isKindOfClass:[NSNull class]] || !player.objectId;
    }];
}

- (NSArray *)compilePlayerIds {
    NSArray *playerIds = [self.players bk_map:^id(Player *player) {
        return player.objectId;
    }];

    return playerIds;
}

- (NSInteger)numberOfTeams {
    NSArray *teams = [self.players bk_reduce:[[NSMutableArray alloc] init] withBlock:^id (NSMutableArray *sum, Player *player) {
        NSString *teamId = player.team.objectId;
        if (![sum containsObject:teamId]) [sum addObject:teamId];
        return sum;
    }];

    return teams.count;
}

- (BOOL)valid {
    return self.players.count == self.lineupFlatten.count;
}

#pragma mark - Captain
- (void)setCaptain:(Player *)player {
    [self removeCaptainMarkerFromLineup];
    player.captain = @YES;
    _captain = player;
}

- (void)removeCaptainMarkerFromLineup {
    [self.players bk_each:^(Player *player) {
        player.captain = @NO;
    }];
}

- (Player *)findCaptain {
    return [self.players bk_match:^BOOL(Player *player) {
        return [player.captain boolValue];
    }];
}

- (BOOL)isCaptainInLineup {
    NSArray *lineupIds = self.playerIds;
    return [lineupIds containsObject:self.captain.objectId];
}

@end