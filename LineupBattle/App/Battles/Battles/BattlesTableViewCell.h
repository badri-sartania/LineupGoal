//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "BattleTemplate.h"

@protocol BattlesTableViewCellDelegate;

@interface BattlesTableViewCell : DefaultViewCell
@property (nonatomic, weak) id <BattlesTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setData:(BattleTemplate *)battleTemplate :(int)index;
- (void)setReminderStatus:(BOOL)reminder;
- (void)setAsJoined:(BOOL)joined;
- (void)setDemoAt:(int)index;
@end

@protocol BattlesTableViewCellDelegate
- (void)buttonWasPressed:(BattlesTableViewCell *)battlesTableViewCell;
@end
