//
//  EventCalculator.h
//  LineupBattle
//
//  Created by Anders Hansen on 09/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Match;

@interface EventCalculator : NSObject

- (instancetype)initWithMatch:(Match *)match;

- (NSArray *)processEventsAndCalculateScore;
@end
