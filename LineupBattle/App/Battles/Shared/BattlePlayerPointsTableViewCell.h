//
// Created by Anders Borre Hansen on 25/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "DefaultViewCell.h"


@interface BattlePlayerPointsTableViewCell : DefaultViewCell
- (void)setPlayer:(Player *)player placement:(NSInteger)placement;
@end

