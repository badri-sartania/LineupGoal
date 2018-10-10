//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "DefaultViewCell.h"


@interface TeamTableCellView : DefaultViewCell
@property (nonatomic, strong) Player *player;
- (void)setupCell;
- (void)setData:(Player *)player;
- (void)setAsDisabled;
@end
