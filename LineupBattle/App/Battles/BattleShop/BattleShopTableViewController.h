//
// Created by Anders Borre Hansen on 28/07/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateLineupViewController.h"
#import "BattlesTableViewCell.h"


@interface BattleShopTableViewController : UITableViewController <CreateLineupViewControllerDelegate, BattlesTableViewCellDelegate>

- (instancetype)initWithInviteOnly:(BOOL)inviteOnly;
@property(nonatomic) BOOL inviteOnly;
@end
