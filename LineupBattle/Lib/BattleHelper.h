//
// Created by Anders Borre Hansen on 05/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BattleHelper : NSObject
+ (NSString *)playerPositionNameByPositionType:(NSString *)position;

+ (NSArray *)sortBattleTemplatesIntoGrouping:(NSArray *)battleTemplates;
+ (NSArray *)sortBattleTemplatesByStartDate:(NSArray *)battleTemplates;

+ (NSArray *)sortBattleTemplatesByStartDateIntoSections:(NSArray *)battleTemplates;
@end
