//
// Created by Anders Hansen on 25/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Subscription.h"
#import "ViewModelWithSubscriptions.h"


@interface TeamViewModel : ViewModelWithSubscriptions
@property(nonatomic, strong) Team *team;

- (instancetype)initWithTeam:(Team *)team;

- (void)fetchDetailsCatchError:(BOOL)catchError success:(void (^)())successBlock;
@end
