//
// Created by Anders Borre Hansen on 24/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "BattleTemplate.h"
#import "LBMTLModel.h"


typedef NS_ENUM(NSInteger, BattleTemplateState) {
    BattleTemplateStateNotStarted,
    BattleTemplateStateOngoing,
    BattleTemplateStateEnded
};

@interface Battle : LBMTLModel
@property(nonatomic, copy, readonly) NSString *objectId;
@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, copy, readonly) NSString *chatToken;
@property(nonatomic, strong, readonly) NSNumber *pot;
@property(nonatomic, strong, readonly) NSArray *users;
@property(nonatomic, strong, readonly) NSArray *matches;
@property(nonatomic, strong, readonly) NSArray *points;
@property(nonatomic, strong, readonly) NSArray *invited;
@property(nonatomic, strong, readonly) BattleTemplate *template;
@property(nonatomic, strong, readonly) User *invitedBy;
@property(nonatomic, readonly) BOOL subscribed;
@property(nonatomic, readonly) BOOL inviteOnly;

// Profile specific
@property(nonatomic, strong, readonly) NSNumber *pos;
@property(nonatomic, strong, readonly) NSNumber *win;
@property(nonatomic, strong, readonly) NSNumber *xp;
@property(nonatomic, readonly) BOOL finished;

// Cache property
@property(nonatomic, strong) User *currentUser;

- (User *)currentUser;

- (NSArray *)currentUserPlayersWithFieldIndex;

- (enum BattleTemplateState)state;
- (NSString *)stateString;

- (BOOL)isFull;
@end
