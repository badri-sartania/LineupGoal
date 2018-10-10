//
// Created by Anders Borre Hansen on 26/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel/RVMViewModel.h>
#import "Battle.h"
#import "APNHelper.h"
#import "ChatHandler.h"


@interface BattleViewModel : RVMViewModel
@property(nonatomic, strong) Battle *model;
@property(nonatomic, strong) ChatHandler *chatHandler;

@property (nonatomic, strong) NSArray *sortedPlayers;

@property (nonatomic, strong) RACCommand *loadGameTemplateCommandWithoutErrorNotification;

- (instancetype)initWithModelDictionary:(NSDictionary *)modelDic;
- (instancetype)initWithBattleId:(NSString *)battleId;

+ (NSArray *)sortUsersByPoints:(NSArray *)users;

+ (NSArray *)sortedPlayersWithModel:(Battle *)battle;

- (RACSignal *)refreshDataSignal;

- (void)subscribeToAllMatches;
- (void)subscribeToLineupMatches;
- (void)handleSubscriptionChoice:(BattleNotificationControl)state;

- (NSString *)formationString;

- (NSInteger)leaderboardPositionOfUser:(User *)user;

- (RACSignal *)addInvites:(NSArray *)invites unInvite:(NSArray *)invite;
@end
