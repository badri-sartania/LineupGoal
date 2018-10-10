//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultViewCell.h"
#import "DefaultLabel.h"
#import "PointsView.h"
#import "Prize.h"

@interface PrizeTableViewCell : DefaultViewCell
- (void)setUser:(NSDictionary *)prize position:(NSInteger)position;
@end
