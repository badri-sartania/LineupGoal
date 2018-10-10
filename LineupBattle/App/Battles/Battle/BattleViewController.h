//
// Created by Anders Borre Hansen on 16/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleViewModel.h"
#import "MenuButton.h"
#import "DefaultTableViewDelegate.h"
#import "InviteFriendsTableViewController.h"

@class MenuButtonWithBadge;


@interface BattleViewController : UIViewController <MenuButtonDelegate, UITableViewDataSource, UITableViewDelegate, DefaultTableViewDelegate, InviteFriendsTableViewControllerDelegate>
@property (strong, nonatomic) NSString *openMethod;
- (id)initWithViewModel:(BattleViewModel *)viewModel;
@end
