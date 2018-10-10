//
// Created by Anders Borre Hansen on 16/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Player.h"
#import "InfiniteScrollView.h"
#import "BattleTemplateViewModel.h"


@protocol SelectPlayerViewControllerDelegate
- (BOOL)selectedPlayer:(Player *)player forTeam:(Team *)team offset:(NSUInteger)offset;
@end

@interface SelectPlayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, InfiniteScrollViewDataSource, InfiniteScrollViewDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) id <SelectPlayerViewControllerDelegate> delegate;
@property(nonatomic, copy) NSString *positionType;
@property (nonatomic) NSInteger playersPerTeam;

- (id)initWithViewModel:(BattleTemplateViewModel *)viewModel positionType:(NSString *)positionType lastTeamOffset:(NSUInteger)startIndex positionPlayer:(Player *)player;
@end


