//
// Created by Anders Borre Hansen on 18/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import "FBSDKLoginButtonHelper.h"
#import "HTTP.h"
#import "APNHelper.h"
#import "Utils.h"
#import "SCLAlertView.h"
#import "DefaultLabel.h"
#import "OAStackView.h"
#import "Mixpanel.h"
#import "HexColors.h"
#import "HTTP+RAC.h"


@implementation FBSDKLoginButtonHelper
+ (FBSDKLoginButton *)createButtonWithDelegate:(id)delegate {

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = delegate;
    loginButton.readPermissions = @[@"public_profile", @"user_friends", @"email"];

    return loginButton;
}

+ (void)registerFacebookLogin:(FBSDKLoginManagerLoginResult *)result success:(void (^)(void))success {
    [[[HTTP instance] updateFacebookOnServerWithToken:result.token] subscribeNext:^(id x) {
        [APNHelper doubleConfirmationWithTitle:@"Get notified when invited" message:@"I want to be notified when friends invites me to battles" accepted:^{
            [Utils registerForAPN];
            success();
        } declined:^{
            success();
        }];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSetUserName"];
        [FBSDKLoginButtonHelper trackLogin];
    } error:^(NSError *error) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
        alert.backgroundType = Shadow;

        NSInteger statusCode = [[error userInfo][AFNetworkingOperationFailingURLResponseErrorKey] statusCode];

        if (statusCode == 403) {
            [alert showError:@"Error" subTitle:@"Your Facebook account is associated with another user" closeButtonTitle:@"Okay" duration:0];
            [FBSDKLoginButtonHelper logout];
        } else {
            [alert addButton:@"Try again" actionBlock:^{
                [FBSDKLoginButtonHelper registerFacebookLogin:result success:^{}];
            }];
            [alert addButton:@"Cancel" actionBlock:^{
                [FBSDKLoginButtonHelper logout];
            }];
            [alert showError:@"Server error" subTitle:@"Try again later" closeButtonTitle:nil duration:0];
        }

    }];
}

+ (void)logout {
    [[FBSDKLoginManager new] logOut];
    [FBSDKLoginButtonHelper trackLogout];
}

+ (void)trackLogin {
    [[Mixpanel sharedInstance].people set:@"facebook" to:@(YES)];
}

+ (void)trackLogout {
    [[Mixpanel sharedInstance].people set:@"facebook" to:@(NO)];
}

+ (UITableViewCell *)loginWithFacebookViewCellWithTopText:(NSString *)topText withDelegate:(id)delegate {
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    UIView *hightlightView = [[UIView alloc] init];
    hightlightView.backgroundColor = [UIColor whiteColor];
    hightlightView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:hightlightView];

    DefaultLabel *topTextLabel = [DefaultLabel initWithText:topText];
    topTextLabel.font = [UIFont systemFontOfSize:14];
    topTextLabel.textColor = [UIColor hx_colorWithHexString:@"727272"];
    topTextLabel.numberOfLines = 2;
    topTextLabel.textAlignment = NSTextAlignmentCenter;

    FBSDKLoginButton *facebookButton = [FBSDKLoginButtonHelper createButtonWithDelegate:delegate];
    [cell addSubview:facebookButton];
    [facebookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([Utils screenWidth]/1.2f));
        make.height.equalTo(@(40));
    }];

    DefaultLabel *buttonText = [DefaultLabel initWithText:@"We will never post anything without your permission."];
    buttonText.textAlignment = NSTextAlignmentCenter;
    buttonText.font = [UIFont systemFontOfSize:11];
    [buttonText sizeToFit];
    buttonText.textColor = [UIColor hx_colorWithHexString:@"8c8c8c"];
    buttonText.numberOfLines = 2;

    OAStackView *stackView = [[OAStackView alloc] initWithArrangedSubviews:@[topTextLabel, facebookButton, buttonText]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.spacing = 12.f;
    stackView.axis = UILayoutConstraintAxisVertical;

    [cell addSubview:stackView];

    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell);
    }];

    return cell;
}

@end
