//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultViewCell.h"
#import "User.h"
#import "DefaultLabel.h"
#import "PointsView.h"


@interface LeaderboardTableViewCell : DefaultViewCell
- (void)setUser:(User *)user position:(NSInteger)position type:(NSString *)type;
@end
