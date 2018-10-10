//
//  LeaderboardContentViewController.h
//  GoalFury
//
//  Created by Kevin Li on 6/1/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *leaderboardType;
- (id)initWithLeaderboardType:(NSString *)leaderboardType;
@end
