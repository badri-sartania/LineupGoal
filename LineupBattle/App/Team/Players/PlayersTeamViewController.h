//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamViewModel.h"
#import "DefaultTableViewDelegate.h"


@interface PlayersTeamViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DefaultTableViewDelegate>
@property(nonatomic, strong) TeamViewModel *viewModel;

@property(nonatomic, strong) NSArray *players;

- (id)initWithViewModel:(TeamViewModel *)viewModel;

- (void)updateData;
@end