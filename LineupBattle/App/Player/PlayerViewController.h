//
// Created by Anders Hansen on 12/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerViewModel.h"
#import "DefaultSubscriptionViewController.h"


@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) PlayerViewModel *viewModel;

@property(nonatomic, strong) NSArray *teams;

@property(nonatomic, strong) NSArray *matches;

@property(nonatomic, strong) NSArray *career;

+ (PlayerViewController *)initWithPlayer:(Player *)player;

- (id)initWithViewModel:(PlayerViewModel *)viewModel;
@end
