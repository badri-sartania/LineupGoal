//
// Created by Anders Borre Hansen on 26/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Match.h"
#import "DefaultViewCell.h"


@interface MatchCellView : DefaultViewCell
@property (strong, nonatomic) Match *match;
@property (strong, nonatomic) UILabel *matchInfo;
@property (strong, nonatomic) UILabel *matchHomeName;
@property (strong, nonatomic) UILabel *matchHomeStanding;
@property (strong, nonatomic) UILabel *matchAwayName;
@property (strong, nonatomic) UILabel *matchAwayStanding;
@property(nonatomic, strong) UIView *standingBackground;

- (void)setupMatch:(Match *)match;
@end
