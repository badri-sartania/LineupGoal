//
//  RewardCollectionViewCell.h
//  GoalFury
//
//  Created by Alexandru on 4/11/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopItem.h"

@interface RewardCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ShopItem *shopItem;
-(id)initWithFrame:(CGRect)frame shopItem:(ShopItem *)item;
-(void)setupCellWithShopItem:(ShopItem *)item;

@end
