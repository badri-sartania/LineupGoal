//
// Created by Anders Borre Hansen on 17/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateLineupViewController.h"
#import <FBSDKLoginKit/FBSDKLoginButton.h>


@interface ChallengesTableViewController : UITableViewController <CreateLineupViewControllerDelegate, FBSDKLoginButtonDelegate>
@property(nonatomic, strong) NSArray *invites;
- (id)initWithInvites:(NSArray *)array;
@end