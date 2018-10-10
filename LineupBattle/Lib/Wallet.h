//
// Created by Anders Borre Hansen on 28/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const WalletNotificationCreditChangeName = @"WalletNoticationTransaction";

@interface Wallet : NSObject
@property (nonatomic, readonly) NSNumber *credits;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSMutableArray *transactionsIds;

+ (Wallet *)instance;

- (void)setCredits:(NSInteger)credits timestamp:(NSDate *)date;

- (void)addTransactions:(NSArray *)transactions timestamp:(NSDate *)date;
@end
