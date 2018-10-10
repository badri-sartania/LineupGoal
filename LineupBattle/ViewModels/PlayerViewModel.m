//
// Created by Anders Hansen on 12/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "PlayerViewModel.h"
#import "HTTP.h"
#import "AFHTTPRequestOperation.h"
#import "Utils.h"
#import "HTTP+RAC.h"

@implementation PlayerViewModel
- (id)initWithPlayer:(Player *)player {
    self = [super init];

    if (self) {
        self.player = player;
    }

    return self;
}

- (void)fetchPlayerDetails:(void (^)(void))callbackBlock {
    if (self.player.objectId) {
        @weakify(self);
        [[[HTTP instance] get:[NSString stringWithFormat:@"/players/%@", self.player.objectId]] subscribeNext:^(id response) {
            @strongify(self);
            [Utils hideConnectionErrorNotification];
            self.player = [Player dictionaryTransformer:response];
            callbackBlock();
        } error:^(NSError *error) {
            [Utils showConnectionErrorNotification];
        }];
    }
}

@end
