//
// Created by Anders Borre Hansen on 16/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"
#import "MatchViewModel.h"
#import "DefaultTableViewDelegate.h"
#import "Spinner.h"

@interface EventMatchViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, DefaultTableViewDelegate>

@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) Spinner *spinner;

- (id)initWithViewModel:(MatchViewModel *)matchViewModel;
- (void)updateView;
@end
