//
//  LeagueTableViewController.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 03/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultTableView.h"


@interface LeagueTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray *groupings;
@property(nonatomic, strong) NSArray *positionTypes;
@property(nonatomic, strong) DefaultTableView *tableView;

- (NSArray *)extractGroupingsForTeam:(NSString *)teamObjectId competitions:(NSArray *)competitions;
@end
