//
// Created by Anders Borre Hansen on 21/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlayersHelper : NSObject
+ (NSArray *)filterPlayers:(NSArray *)players byPosition:(NSString *)position;

+ (NSArray *)sortPlayers:(NSArray *)players;
@end