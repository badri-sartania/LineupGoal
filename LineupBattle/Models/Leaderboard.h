//
//  Leaderboard.h
//  LineupBattle
//
//  Created by Anders Borre Hansen on 01/12/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

#import "LBMTLModel.h"

@interface Leaderboard : LBMTLModel
@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, copy, readonly) NSString *country;
@property(nonatomic, copy, readonly) NSString *prize;
@property(nonatomic, strong, readonly) NSArray *users;
@property(nonatomic, strong, readonly) NSArray *total;
@property(nonatomic, strong, readonly) NSArray *lineup;
@end
