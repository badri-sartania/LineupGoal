//
// Created by Anders Borre Hansen on 18/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginButton.h>


@interface FBSDKLoginButtonHelper : NSObject
+ (FBSDKLoginButton *)createButtonWithDelegate:(id)delegate;

+ (void)registerFacebookLogin:(FBSDKLoginManagerLoginResult *)result success:(void (^)(void))success;

+ (void)logout;

+ (void)trackLogout;

+ (void)trackLogin;

+ (UITableViewCell *)loginWithFacebookViewCellWithTopText:(NSString *)topText withDelegate:(id)delegate;
@end