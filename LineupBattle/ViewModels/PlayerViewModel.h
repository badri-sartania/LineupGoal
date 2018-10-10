//
// Created by Anders Hansen on 12/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "ViewModelWithSubscriptions.h"
#import <YLMoment/YLMoment.h>


@interface PlayerViewModel : ViewModelWithSubscriptions
@property(nonatomic, strong) Player *player;

- (id)initWithPlayer:(Player *)player;
- (void)fetchPlayerDetails:(void (^)(void))callbackBlock;
@end
