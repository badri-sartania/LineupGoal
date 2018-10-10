//
// Created by Anders Borre Hansen on 17/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"
#import "MatchPageViewController.h"
#import "FieldView.h"

@interface LineupMatchViewController : UITableViewController <FieldViewDelegate, FieldViewDataSource>
@property(nonatomic, strong) NSDictionary *homeSubstitutes;
@property(nonatomic, strong) NSDictionary *awaySubstitutes;
@property(nonatomic, strong) NSArray *substitutes;

- (id)initWithViewModel:(MatchViewModel *)matchViewModel;
- (void)updateView;

@end
