//
// Created by Anders Hansen on 11/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "MatchViewModel.h"
#import "HTTP.h"
#import "NSDate+Lineupbattle.h"
#import "Lineup.h"
#import "HTTP+RAC.h"
#import "HTTP+LineupBattle.h"

@interface MatchViewModel()
@property(nonatomic, strong) RACDisposable *fetchDisposable;
@property(nonatomic, strong) RACDisposable *autoFetchDisposable;
@end

@implementation MatchViewModel

- (instancetype)initWithMatch:(Match *)match {
    self = [super init];
    if (self) {
        self.model = [match copy];
        self.subscription = match.subscription ?: [[MatchSubscription alloc] init];
        [self setupMatchDetailsFetchAtInterval:30];
    }

    return self;
}

#pragma mark - Data Fetching
- (RACSignal *)fetchMatchDetailsSignal {
    NSString *path = [NSString stringWithFormat:@"/matches/%@", self.model.objectId];

    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);

        self.fetchDisposable = [[[HTTP instance] get:path] subscribeNext:^(id response) {
            @strongify(self);

            // Invokes update of match model and subviews are reloaded
            self.model = [Match dictionaryTransformer:response];
            self.events = [self.model processedEvents];

            // Subscription Data
            self.objectId = self.model.objectId;
            self.name = self.model.name;

            if (self.model.subscription) self.subscription = self.model.subscription;

            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];

        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            [self.fetchDisposable dispose];
        }];
    }];
}

- (void)setupMatchDetailsFetchAtInterval:(NSInteger)interval {
    if ([self.model.kickOff isToday]) {
        @weakify(self);
        self.autoFetchDisposable = [[RACSignal
            interval:interval onScheduler:[RACScheduler mainThreadScheduler]]
            subscribeNext:^(id x) {
                @strongify(self);
                [[self fetchMatchDetailsSignal] subscribeCompleted:^{}];
            }
        ];
    }
}

- (void)disposeFetch{
    [_fetchDisposable dispose];
}
- (void)disposeAutoFetch{
    [_autoFetchDisposable dispose];
}

#pragma mark - Subscriptions
- (void)submitSubscription {
    [[HTTP instance] updateSubscription:self.subscription forType:@"matches" withId:self.model.objectId];
}

#pragma mark - event

- (NSArray *)formatedHomeLineup {
    return [Lineup withPlayers:self.model.homeLineup formation:self.model.homeFormation];
}

- (NSArray *)formatedAwayLineup {
    return [Lineup withPlayers:self.model.awayLineup formation:self.model.awayFormation];
}

@end
