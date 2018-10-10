//
// Created by Anders Borre Hansen on 18/11/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "HTTP+LineupBattle.h"
#import "NSArray+BlocksKit.h"
#import "Identification.h"
#import "UIAlertView+BlocksKit.h"
#import "CLSLogging.h"

@implementation HTTP (LineupBattle)

- (void)updateSubscription:(Subscription *)subscription forType:(NSString *)type withId:(NSString *)objectId {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    NSString *path = [NSString stringWithFormat:@"/%@/%@/subscribe", type, objectId];

    if (subscription) {
        @weakify(subscription);
        [[[subscription class] types] bk_each:^(NSString *key) {
            @strongify(subscription);
            NSNumber *val = [subscription valueForKey:key];
            if (val) params[key] = val;
        }];
    }

    NSString *apnToken = [Identification apnDeviceToken];
    if (apnToken) {
        params[@"token"] = apnToken;
    }

    @weakify(self);
    [self put:path params:nil body:params
      success:^(id o) {}
      failure:^(NSError *error) {
          UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"Ups, something went wrong" message:@"We're really sorry, but we could not add your subscription. Please try again later."];
          [alert addButtonWithTitle:@"Ok"];
          [alert bk_addButtonWithTitle:@"Retry" handler:^{
              @strongify(self);
              [self updateSubscription:subscription forType:type withId:objectId];
          }];
          [alert show];
      }
    ];
}

- (void)addBasicTeamSubscriptions:(NSArray *)subscriptionIds {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    NSString *apnToken = [Identification apnDeviceToken];
    if (apnToken)
        params[@"token"] = apnToken;

    // Set standard subscription
    params[@"before"] = @YES;
    params[@"ft"] = @YES;
    params[@"ids"] = subscriptionIds;

    @weakify(self);
    [self put:@"/teams/subscribe" params:params body:nil
        success:^(id o) {}
        failure:^(NSError *error) {
            UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"Ups, something went wrong" message:@"We're really sorry, but we could not add your subscriptions. Please try again later."];
            [alert addButtonWithTitle:@"Ok"];
            [alert bk_addButtonWithTitle:@"Retry" handler:^{
                @strongify(self);
                [self addBasicTeamSubscriptions:subscriptionIds];
            }];
            [alert show];
        }
    ];
}

- (void)sendAPNDeviceToken:(NSString *)token {
    NSDictionary *params = @{
       @"token": token
    };

    [self put:@"/me" params:nil body:params
        success:^(id o) {
            CLS_LOG(@"Submit response data: %@", o);
        }
        failure:^(NSError *error) {
            CLS_LOG(@"Error: %@", error);
        }
    ];
}

@end