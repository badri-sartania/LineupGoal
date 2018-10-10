//
//  ProfileTableViewController.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 10/04/15.
//  Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
- (instancetype)initWithProfileId:(NSString *)profileId;
@end
