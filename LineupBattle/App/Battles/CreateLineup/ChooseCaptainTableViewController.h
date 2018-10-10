//
// Created by Anders Borre Hansen on 04/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"


@protocol ChooseCaptainDelegate;

@interface ChooseCaptainTableViewController : UITableViewController
@property (nonatomic, weak) id <ChooseCaptainDelegate> delegate;
- (instancetype)initWithPlayers:(NSArray *)players;
@end

@protocol ChooseCaptainDelegate
- (void)captainSelected:(Player *)captain;
@end