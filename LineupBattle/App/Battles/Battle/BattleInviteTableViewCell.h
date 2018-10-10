//
// Created by Anders Borre Hansen on 20/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"


@interface BattleInviteTableViewCell : DefaultViewCell
- (void)markAsFull:(BOOL)full position:(NSInteger)position;
@end
