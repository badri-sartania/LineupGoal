//
// Created by Anders Borre Hansen on 06/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Match.h"
#import "MatchPageViewController.h"
#import "EventMatchViewController.h"


@interface MatchTopView : UIView
@property (nonatomic, strong) MatchViewModel *viewModel;
@property (nonatomic, strong) UIViewController *viewController;

- (id)initWithViewModel:(MatchViewModel *)viewModel frame:(CGRect)frame;
- (void)updateViews;
@end
