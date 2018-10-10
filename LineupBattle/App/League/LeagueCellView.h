//
//  LeagueCellView.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 03/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "DefaultViewCell.h"


@interface LeagueCellView : DefaultViewCell

@property(nonatomic, copy) NSString *color;

- (void)setData:(Team *)leagueRow color:(NSString *)color position:(NSInteger)position;

@end
