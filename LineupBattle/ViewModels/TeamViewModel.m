//
// Created by Anders Hansen on 25/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//


#import "TeamViewModel.h"
#import "HTTP.h"
#import "Utils.h"
#import "HTTP+RAC.h"


@implementation TeamViewModel

- (instancetype)initWithTeam:(Team *)team {
    self = [super init];
    if (self) {
        self.team = team;
    }

    return self;
}

#pragma mark - Data Fetching
- (void)fetchDetailsCatchError:(BOOL)catchError success:(void (^)())successBlock {
    @weakify(self);
    if (self.team.objectId) {
        NSString *path = [NSString stringWithFormat:@"/teams/%@", self.team.objectId];
        [[[HTTP instance] get:path] subscribeNext:^(id response) {
            @strongify(self);

            [Utils hideConnectionErrorNotification];
            self.team = [Team dictionaryTransformer:response];
            successBlock();
        } error:^(NSError *error) {
            if(!catchError) {
                [Utils showConnectionErrorNotification];
            }
        }];
    }
}

@end
