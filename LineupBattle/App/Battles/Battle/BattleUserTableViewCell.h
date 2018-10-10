//
// Created by Anders Borre Hansen on 25/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//


#import "DefaultViewCell.h"
#import "User.h"
#import "Battle.h"
#import "DefaultLabel.h"

@interface BattleUserTableViewCell : DefaultViewCell
- (void)setUser:(User *)user points:(NSInteger)points placement:(NSInteger)placement battle:(Battle *)battle;
- (void)showCoinView:(BOOL) visible;
- (void)setupFriendRowAt:(NSInteger)friendIndex;
@end
