//
// Created by Anders Borre Hansen on 28/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "Wallet.h"
#import "NSDate+LineupBattle.h"
#import "RMAppReceipt.h"
#import "Shop.h"


@implementation Wallet

static NSString *walletPersistenceKey = @"wallet";

+ (Wallet *)instance {
    static Wallet *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *walletData = [[NSUserDefaults standardUserDefaults] objectForKey:walletPersistenceKey];
        _credits = walletData[@"credits"];
        _date = walletData[@"date"];
        _transactionsIds = walletData[@"transactionIds"] ? [[NSMutableArray alloc] initWithArray:walletData[@"transactionIds"]] : [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)setCredits:(NSInteger)credits timestamp:(NSDate *)date {
    if (!_date || (date && [date greaterThan:_date])) {
        _date = date;
        _credits = @(credits);
        [self persistWallet];
        [self notifyCreditChange];

        // Track change in wallet
        [[Mixpanel sharedInstance].people set:@"credits" to:_credits];
    }
}

- (void)persistWallet {
    NSMutableDictionary *persistDic = [[NSMutableDictionary alloc] init];

    // Wallet should not be cleared, only overridden
    if (_credits) persistDic[@"credits"] = _credits;
    if ([_date isKindOfClass:[NSDate class]]) persistDic[@"date"] = _date;
    if (_transactionsIds) persistDic[@"transactionIds"] = _transactionsIds;

    [[NSUserDefaults standardUserDefaults] setObject:persistDic forKey:walletPersistenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addTransactions:(NSArray *)transactions timestamp:(NSDate *)date {
    _date = date;
    [transactions bk_each:^(RMAppReceiptIAP *iap) {
        NSString *transactionIdentifier = iap.transactionIdentifier;
        if (![_transactionsIds containsObject:transactionIdentifier]) {
            NSNumber *creditsForProductIAP = [[Shop instance] creditsForProductIdentifier:iap.productIdentifier];

            if (creditsForProductIAP) {
                _credits = @([self.credits integerValue] + [creditsForProductIAP integerValue]);
                [_transactionsIds addObject:transactionIdentifier];

                // Tracking
                SKProduct *product = [[Shop instance] productWithIdentifier:iap.productIdentifier];
                NSNumber *tier = [[Shop instance] tierForProductIdentifier:iap.productIdentifier];

                if (product && tier) {
                    [[Mixpanel sharedInstance].people trackCharge:tier withProperties:@{
                        @"localePrice": [Shop formatPriceFromProduct:product] ?: @"",
                        @"credits": creditsForProductIAP
                    }];
                }
            }
        }
    }];
    [self persistWallet];
    [self notifyCreditChange];
}

- (void)notifyCreditChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:WalletNotificationCreditChangeName object:self userInfo:nil];
}

@end
