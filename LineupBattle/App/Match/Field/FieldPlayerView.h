//
// Created by Anders Hansen on 10/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "FieldItemView.h"

@interface FieldPlayerView : FieldItemView
- (instancetype)initWithPlayer:(Player *)player;
+ (instancetype)initWithPlayer:(Player *)player;

@property(nonatomic, strong) Player *player;
@end