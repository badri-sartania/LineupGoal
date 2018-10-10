//
// Created by Anders Borre Hansen on 06/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Match.h"
#import "AbstractPageViewController.h"
#import "FixedSizePageViewController.h"
#import "MatchViewModel.h"
#import "DefaultSubscriptionViewController.h"

@interface MatchPageViewController : FixedSizePageViewController <TTSliddingPageDelegate>
@property(nonatomic, strong) MatchViewModel *viewModel;

- (id)initWithMatch:(Match *)match;
- (DefaultSubscriptionViewController *)wrapInSubscriptionViewController;
@end
