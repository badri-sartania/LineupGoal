//
// Created by Anders Borre Hansen on 19/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "BattleViewModel.h"
#import <FBSDKLoginKit/FBSDKLoginButton.h>

@protocol InviteFriendsTableViewControllerDelegate;


@interface InviteFriendsTableViewController : UITableViewController <FBSDKLoginButtonDelegate>
@property (nonatomic, weak) id <InviteFriendsTableViewControllerDelegate> delegate;

- (id)initWithBattleViewModel:(BattleViewModel *)viewModel;

- (void)showInviteError;
@end

@protocol InviteFriendsTableViewControllerDelegate
- (void)friendsSelected:(InviteFriendsTableViewController *)controller;
@end
