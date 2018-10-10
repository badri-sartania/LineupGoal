//
// Created by Anders Borre Hansen on 29/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldView.h"
#import "User.h"
#import "Battle.h"
#import "CreateLineupViewController.h"
#import "BattleViewModel.h"
#import "ProfileImageWithBadgeView.h"


@interface UserLineupTableViewController : UIViewController <FieldViewDataSource, FieldViewDelegate, CreateLineupViewControllerDelegate, ProfileImageButtonDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
- (instancetype)initUser:(User *)user viewModel:(BattleViewModel *)viewModel;
@end
