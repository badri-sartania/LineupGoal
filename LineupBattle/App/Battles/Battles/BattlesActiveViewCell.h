//
// Created by Anders Borre Hansen on 11/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "Battle.h"

@interface BattlesActiveViewCell : DefaultViewCell
- (void)setData:(Battle *)battle;
@end
