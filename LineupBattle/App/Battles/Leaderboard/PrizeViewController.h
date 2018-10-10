//
//  PrizeViewController.h
//  GoalFury
//
//  Created by Kevin Li on 7/4/18.
//  Copyright © 2018 GoalFury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrizeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *prizeType;
@property (nonatomic, strong) NSString *prizeMonth;
- (id)initWithPrizeType:(NSString *)prizeType month:(NSString *)month;
@end
