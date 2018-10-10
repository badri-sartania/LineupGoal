//
// Created by Anders Hansen on 24/04/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "DefaultMASViewCell.h"
#import "Team.h"


@interface CareerPlayerViewCell : DefaultMASViewCell
- (void)setData:(Team *)team;
@end