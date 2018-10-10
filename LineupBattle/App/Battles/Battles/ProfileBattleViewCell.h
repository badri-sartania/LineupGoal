//
// Created by Anders Borre Hansen on 11/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "Battle.h"

@interface ProfileBattleViewCell : DefaultViewCell
- (void)setData:(Battle *)battle position:(NSInteger)position;
- (void)setHorizontalMargin:(NSInteger)margin;
- (void)setHorizontalMargin:(NSInteger)margin withHeader:(NSString *)headerTitle;
- (void)setShadowCell:(BOOL)shadow;
- (void)setDemoData;
@end
