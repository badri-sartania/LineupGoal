//
// Created by Anders Hansen on 15/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "LeagueMatchViewController.h"
#import "Grouping.h"
#import "NSArray+BlocksKit.h"


@implementation LeagueMatchViewController

- (id)initWithViewModel:(MatchViewModel *)viewModel {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;
    }

    return self;
}

- (void)updateView {
    Competition *competition = self.viewModel.model.competition;

    if (!competition || !competition.table) return;

    Grouping *grouping = competition.table;
    grouping.competition = competition;

    self.groupings = @[competition.table];
    [self.tableView reloadData];
}

@end
