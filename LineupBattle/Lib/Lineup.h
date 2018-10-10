//
// Created by Anders Borre Hansen on 21/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "Player.h"


@interface Lineup : NSObject
@property(nonatomic, strong) NSArray *lineup;
@property(nonatomic, strong) NSArray *lineupFlatten;
@property(nonatomic, strong) Player *captain;
@property(nonatomic, strong) NSArray *playerIds;
@property(nonatomic, strong) NSArray *players;

+ (NSArray *)withPlayers:(NSArray *)players formation:(NSArray *)formation;

- (id)initWithPlayers:(NSArray *)array formation:(NSArray *)formation;

+ (NSArray *)playersWithFieldIndex:(NSArray *)players;

+ (NSArray *)sortPlayersByFieldIndex:(NSArray *)players;

+ (NSArray *)applyFieldIndexToLineup:(NSArray *)array;

- (id)initWithEmptyFormat;

- (void)setLineupPlayerForIndexPath:(NSIndexPath *)indexPath player:(Player *)player;

+ (NSMutableArray *)emptyLineup;

- (NSInteger)numberOfTeams;
- (BOOL)valid;
- (void)setCaptain:(Player *)player;
- (BOOL)isCaptainInLineup;

@end