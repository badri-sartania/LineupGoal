//
// Created by Anders Hansen on 15/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "TableTeamViewController.h"
#import "Competition.h"
#import "Grouping.h"

@implementation TableTeamViewController

- initWithViewModel:(TeamViewModel *)viewModel {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;

        [self updateData];
    }

    return self;
}

- (void)updateData {
    NSArray *competitions = self.viewModel.team.competitions;

    if (!competitions) return;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *groupings = [self extractGroupingsForTeam:self.viewModel.team.objectId competitions:competitions];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.groupings = groupings;
            [self.tableView reloadData];
        });
    });
}

@end