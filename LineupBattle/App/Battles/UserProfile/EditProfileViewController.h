//
// Created by Anders Borre Hansen on 09/07/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginButton.h>
#import "User.h"
#import "EditProfileTableViewCell.h"


@interface EditProfileViewController : UIViewController <FBSDKLoginButtonDelegate, UITableViewDataSource, UITableViewDelegate, EditProfileTableViewCellDelegate>
@property (nonatomic, strong) UITextField *textField;
- (instancetype)initWithUser:(User *)user;
@end
