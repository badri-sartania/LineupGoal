//
//  GamesTableViewController.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 16/12/14.
//  Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateLineupViewController.h"
#import "ProfileImageWithBadgeView.h"
#import "BattlesTableViewCell.h"

@interface BattlesTableViewController : UIViewController <CreateLineupViewControllerDelegate, ProfileImageButtonDelegate, BattlesTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *noBattlesView;
@property (nonatomic) BOOL noBattleTemplates;
@property (nonatomic, strong) UITableView *tableView;
@end
