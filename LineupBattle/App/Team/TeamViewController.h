//
// Created by Anders Borre Hansen on 06/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractPageViewController.h"
#import "FixedSizePageViewController.h"
#import "TeamViewModel.h"

@interface TeamViewController : FixedSizePageViewController
@property(nonatomic, strong) TeamViewModel *viewModel;

- (id)initWithTeam:(Team *)team;
- (id)initWithViewModel:(TeamViewModel *)viewModel;
@end
