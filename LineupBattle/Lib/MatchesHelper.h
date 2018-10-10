//
// Created by Anders Borre Hansen on 06/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MatchesHelper : NSObject
+ (NSArray *)groupByCompetition:(NSArray *)matches;

+ (NSArray *)matchesSeparatedByDate:(NSArray *)matches;

+ (NSArray *)sortedByDateAndGroupedByLeague:(NSArray *)array;

+ (CGFloat)heightForSection:(NSInteger)section competitions:(NSArray *)competitions;

+ (BOOL)shouldDisplaySectionWithHeaderTextWithCompetitions:(NSArray *)competitions section:(NSInteger)section;
@end
