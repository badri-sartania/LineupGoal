//
//  RewardDetailViewController.h
//  GoalFury
//
//  Created by Alexandru on 4/11/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopItem.h"

@interface RewardDetailViewController : UIViewController<UIScrollViewDelegate>

- (id)initWithShopItem:(ShopItem *)item;

@end
