//
// Created by Anders Borre Hansen on 02/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Battle.h"
#import "DefaultLabel.h"


@interface TeamCollectionViewCell : UIView
@property (strong, nonatomic) Team* team;

+ (CGFloat)height;

+ (CGFloat)width;

- (void)addHomeTeamStyle;

- (void)addAwayTeamStyle;

- (void)setTeam:(Team *)team;

- (void)setCount:(NSInteger)count;

- (void)addV;

- (void)addS;
@end
