//
//  LeaguesIndicatorView.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 02/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaguesIndicatorView : UIView
- (id)initWithCompetitionCount:(NSUInteger)count andFrame:(CGRect)frame;
- (void)updateCompetitionCount:(NSUInteger)count;
@end
