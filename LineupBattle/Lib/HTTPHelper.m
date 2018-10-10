//
// Created by Anders Borre Hansen on 28/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "HTTPHelper.h"
#import "NSDictionary+UrlEncodedString.h"
#import "Identification.h"
#import "Utils.h"


@implementation HTTPHelper


+ (NSString *)applyQuery:(NSDictionary *)query toUrlString:(NSString *)url {
    BOOL urlHasQuestionMark = [url rangeOfString:@"?"].location != NSNotFound;
    return [NSString stringWithFormat:@"%@%@%@", url, urlHasQuestionMark ? @"&" : @"?", [query urlEncodedString]];
}

+ (NSDictionary *)applyAuthToDictionary:(NSDictionary *)query {
    NSMutableDictionary *queryWithAuth = [[NSMutableDictionary alloc] initWithDictionary:query];

    if (!queryWithAuth[@"auth"]) {
        queryWithAuth[@"auth"] = [Identification authenticationToken];
    }

    return queryWithAuth;
}

+ (RACScheduler *)backgroundScheduler {
    return [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
}

+ (NSString *)userAgent {
    return [NSString stringWithFormat:@"LineupBattle iPhone/%@ (%@; iOS v%@; %@; %@)",
                                      [Utils appVersion],
                                      [Utils platform],
                                      [[UIDevice currentDevice] systemVersion],
                                      [[NSLocale currentLocale] localeIdentifier],
                                      [NSLocale preferredLanguages][0]];
}

@end
