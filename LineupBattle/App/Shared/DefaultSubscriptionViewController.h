//
// Created by Anders Hansen on 19/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XipSlideDown.h"
#import "MatchViewModel.h"

@interface DefaultSubscriptionViewController : XipSlideDown <XipSlideDownVCDelegate>

- (id)initWithViewModel:(ViewModelWithSubscriptions *)viewModel mainViewController:(UIViewController *)mainController;

- (void)updateBellIcon:(Subscription *)subscription;
@end
