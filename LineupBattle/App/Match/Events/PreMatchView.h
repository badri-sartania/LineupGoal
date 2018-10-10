//
// Created by Anders Hansen on 07/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultTableView.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "MatchViewModel.h"


@interface PreMatchView : UIView <UITableViewDataSource, UITableViewDelegate>
//@property (nonatomic, strong) DefaultTableView *lastMatchesTable;
@property (nonatomic, strong) UIViewController *parentViewController;

- (id)initWithViewModel:(MatchViewModel *)model;
- (void)updateData;
@end
