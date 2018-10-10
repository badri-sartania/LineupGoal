//
// Created by Anders Borre Hansen on 05/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "BattleHelper.h"
#import "BattleTemplate.h"
#import "Date.h"


@implementation BattleHelper

+ (NSString *)playerPositionNameByPositionType:(NSString *)position {
    const NSDictionary *positionName = @{
        @"gk": @"Goalkeeper",
        @"df": @"Defender",
        @"mf": @"Midfielder",
        @"fw": @"Forward"
    };

    return positionName[position];
}

#pragma mark - Group helper
+ (NSArray *)sortBattleTemplatesIntoGrouping:(NSArray *)battleTemplates {
    NSArray *sortedBattleTemplates = [BattleHelper sortBattleTemplatesByStartDate:battleTemplates];

    NSMutableDictionary *templates = [[NSMutableDictionary alloc] init];
    [sortedBattleTemplates bk_each:^(BattleTemplate *template) {
        NSString *groupingName = template.groupingHeader ?: @"Rest";

        if (!templates[groupingName]) {
            NSDictionary *grouping = @{
                @"name": groupingName,
                @"country": template.country ?: @"UNK",
                @"battleTemplates": [[NSMutableArray alloc] init]
            };

            templates[groupingName] = grouping;
        }

        [templates[groupingName][@"battleTemplates"] addObject:template];
    }];

    NSArray *battlesInGroupings = [templates allValues];
    NSArray *sortedBattlesInGroupings = [battlesInGroupings sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        BattleTemplate *b1 = a[@"battleTemplates"][0];
        BattleTemplate *b2 = b[@"battleTemplates"][0];

        NSComparisonResult result = [b1.startDate compare:b2.startDate];

        if (result == NSOrderedSame) {
            result = [b1.name compare:b2.name];
        }

        return result;
    }];

    return sortedBattlesInGroupings;
}

+ (NSArray *)sortBattleTemplatesByStartDateIntoSections:(NSArray *)battleTemplates {
	NSArray *sortedBattleTemplates = [BattleHelper sortBattleTemplatesByStartDate:battleTemplates];

	NSMutableDictionary *templates = [[NSMutableDictionary alloc] init];
	[sortedBattleTemplates bk_each:^(BattleTemplate *template) {
		NSString *groupingName = [Date getRequestDateFormat:template.startDate];

		if (!templates[groupingName]) {
			NSDictionary *grouping = @{
			   @"date": template.startDate ?: [NSNull null],
			   @"templates": [[NSMutableArray alloc] init]
            };

			templates[groupingName] = grouping;
		}

		[templates[groupingName][@"templates"] addObject:template];
	}];

	NSArray *sortedSections = [[templates allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
		NSComparisonResult result = [a[@"date"] compare:b[@"date"]];

		return result;
	}];

	return sortedSections;
}

+ (NSArray *)sortBattleTemplatesByStartDate:(NSArray *)battleTemplates {
    NSArray *sortedTemplates = [battleTemplates sortedArrayUsingComparator:^NSComparisonResult(BattleTemplate *a, BattleTemplate *b) {
        NSComparisonResult result = [a.startDate compare:b.startDate];

        if (result == NSOrderedSame) {
            result = [a.name compare:b.name];
        }

        return result;
    }];

    return sortedTemplates;
}

@end
