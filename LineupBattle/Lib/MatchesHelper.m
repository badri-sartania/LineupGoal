//
// Created by Anders Borre Hansen on 06/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "MatchesHelper.h"
#import "Match.h"
#import "Array.h"


@implementation MatchesHelper

+ (NSArray *)groupByCompetition:(NSArray *)matches {
    // Group matches by competition
    NSArray *competitions = [MatchesHelper sortMatchesIntoCompetitions:matches];

    // Sort in the right order
    NSArray *sortedCompetitions = [Array sortArrayWithDictionaries:competitions key:@"order" assending:YES];

    // Sort matches in each competition
    NSArray *sortedCompetitionsAndMatches = [sortedCompetitions bk_map:^id(NSDictionary *competition) {
        NSMutableDictionary *mutableCompetition = [competition mutableCopy];
        mutableCompetition[@"matches"] = [MatchesHelper sortArrayOfMatchesByKickOff:competition[@"matches"]];

        return mutableCompetition;
    }];

    return sortedCompetitionsAndMatches;
}

+ (NSArray *)sortArrayOfMatchesByKickOff:(NSArray *)matches {
    NSArray *sortedMatches = [matches sortedArrayUsingComparator:^NSComparisonResult(Match *a, Match *b) {
        NSComparisonResult result = [a.kickOff compare:b.kickOff];

        if (result == NSOrderedSame) {
            result = [a.home.name compare:b.home.name];
        }

        return result;
    }];

    return sortedMatches;
}

+ (NSArray *)sortMatchesIntoCompetitions:(NSArray *)matches {
    NSMutableDictionary *leagues = [[NSMutableDictionary alloc] init];

    NSUInteger matchCount = matches.count;
    NSUInteger numberOrder = 1;
    for (NSUInteger i = 0; i < matchCount; i++) {
        Match *match = matches[i];
        NSString *leagueKey = [NSString stringWithFormat:@"%@-%@", match.competition.name, match.competition.country];

        if (!leagues[leagueKey]) {
            NSDictionary *league = @{
                @"name": match.competition ? match.competition.name : @"Unknown Competition",
                @"country": match.competition.country ?: @"UNK",
                @"matches": [[NSMutableArray alloc] init],
                @"order": @(numberOrder++),
                @"dateString": match.dateString ?: @"",
                @"date": match.kickOff ?: [NSDate distantPast]
            };

            leagues[leagueKey] = league;
        }

        [leagues[leagueKey][@"matches"] addObject:match];
    }

    return [leagues allValues];
}

+ (NSArray *)matchesSeparatedByDate:(NSArray *)matches {
    if (!matches) return @[];

    NSMutableDictionary *matchesByDate = [[NSMutableDictionary alloc] init];

    [matches bk_each:^(Match* match) {
        NSString *dateString = [match dateString];

        if (dateString) {
            if (!matchesByDate[dateString]) {
                matchesByDate[dateString] = @{
                        @"kickOff" : match.kickOff,
                        @"matches" : [[NSMutableArray alloc] init]
                };
            }

            [matchesByDate[dateString][@"matches"] addObject:match];
        }
    }];

    return [[[matchesByDate allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dic1, NSDictionary *dic2) {
        NSDate *date1 = dic1[@"kickOff"];
        NSDate *date2 = dic2[@"kickOff"];
        return [date1 compare:date2];
    }] bk_map:^id(NSDictionary *dic) {
        return dic[@"matches"];
    }];
}

+ (NSArray *)sortedByDateAndGroupedByLeague:(NSArray *)matches {
    NSArray *matchesSeparatedByDate = [MatchesHelper matchesSeparatedByDate:matches];
    NSArray *matchesSeparatedAndGroupedByCompetition = [matchesSeparatedByDate bk_map:^id (NSArray *matchesByDate) {
        return [MatchesHelper groupByCompetition:matchesByDate];
    }];

    NSArray *flattenedCompetitionsByDate = [matchesSeparatedAndGroupedByCompetition bk_reduce:[[NSMutableArray alloc] init] withBlock:^id (NSMutableArray *mutableArray, NSArray *competitions) {
        [mutableArray addObjectsFromArray:competitions];
        return mutableArray;
    }];

    return flattenedCompetitionsByDate;
}

#pragma mark - View Helpers
+ (CGFloat)heightForSection:(NSInteger)section competitions:(NSArray *)competitions {
    NSString *currentDateString = competitions[(NSUInteger) section][@"dateString"];
    NSString *prevDateString = section > 0 ? competitions[(NSUInteger) section-1][@"dateString"] : @"";

    if (![currentDateString isEqualToString:prevDateString] && section != 0) {
        return 41.f;
    }

    return 32.f;
}

+ (BOOL)shouldDisplaySectionWithHeaderTextWithCompetitions:(NSArray *)competitions section:(NSInteger)section {
    NSDictionary *league = competitions[(NSUInteger) section];
    NSString *currentDateString = league[@"dateString"];
    NSString *prevDateString = section > 0 ? competitions[(NSUInteger) section-1][@"dateString"] : @"";

    return ![currentDateString isEqualToString:prevDateString] && section != 0 && league[@"date"];
}
@end
