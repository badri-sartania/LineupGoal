//
//  MatchesTeamViewController.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 31/12/13.
//  Copyright (c) 2013 xip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamViewModel.h"
#import "DefaultTableViewDelegate.h"

@interface MatchesTeamViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DefaultTableViewDelegate>
@property(nonatomic, strong) TeamViewModel *viewModel;
@property(nonatomic, strong) NSArray *matches;

- (id)initWithViewModel:(TeamViewModel *)viewModel;

- (void)updateData;
@end
