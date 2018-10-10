//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <ReactiveViewModel/RVMViewModel.h>
#import "BattleTemplate.h"
#import "Team.h"
#import "Battle.h"
#import "User.h"
#import "Player.h"
#import "Lineup.h"


@interface BattleTemplateViewModel : RVMViewModel
@property(nonatomic, strong, readwrite) RACCommand *loadGameTemplateCommand;
@property(nonatomic, strong, readwrite) BattleTemplate *model;
@property(nonatomic, strong) Lineup *lineup;
@property(nonatomic, strong) NSArray *competitions;
@property(nonatomic, strong) Battle *battle;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) User *invitedBy;
@property(nonatomic) BOOL inviteOnly;
@property(nonatomic, strong) NSDictionary *selectPlayerStructure;
@property(nonatomic, strong) NSArray *teamsInMatchOrder;

- (instancetype)initWithEmptyLineupAndBattleTemplateId:(NSString *)battleTemplateId;
- (instancetype)initWithBattle:(Battle *)battle;

- (RACSignal *)joinBattle;
- (RACSignal *)joinInvitedBattle;
- (RACSignal *)updateBattleSignal;

- (BOOL)lessPlayersAllowedForTeam:(Team *)team;
- (NSArray *)teams;

@end
