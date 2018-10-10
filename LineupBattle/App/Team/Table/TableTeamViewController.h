//
// Created by Anders Hansen on 15/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeagueTableViewController.h"
#import "TeamViewModel.h"

@interface TableTeamViewController : LeagueTableViewController
@property(nonatomic, strong) TeamViewModel *viewModel;

- (id)initWithViewModel:(TeamViewModel *)viewModel;

- (void)updateData;
@end