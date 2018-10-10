//
// Created by Anders Hansen on 29/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "Player.h"
#import "DefaultLabel.h"


@interface ImageTextViewCell : DefaultViewCell
@property (nonatomic, strong) DefaultLabel *playerName;
@property (nonatomic, strong) DefaultLabel *playerPosition;

- (void)setData:(Player *)player position:(NSInteger)position;
@end
