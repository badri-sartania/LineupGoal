//
// Created by Anders Hansen on 15/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeagueTableViewController.h"
#import "MatchViewModel.h"


@interface LeagueMatchViewController : LeagueTableViewController
@property(nonatomic, strong) MatchViewModel *viewModel;

- (id)initWithViewModel:(MatchViewModel *)matchViewModel;

- (void)updateView;
@end