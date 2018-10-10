//
// Created by Anders Borre Hansen on 17/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Team.h"
#import "FieldItemView.h"


@interface BattleFieldPlayerView : FieldItemView

@property(nonatomic, strong) Player *player;

- (instancetype)initWithPlayer:(Player *)player points:(NSInteger)points;

- (instancetype)initWithPlayer:(Player *)player;

- (void)setPointsLabelText:(NSInteger)points;

- (void)showCaptainBadge:(BOOL)isVisible;
@end

