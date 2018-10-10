//
// Created by Anders Borre Hansen on 18/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


static NSString *const ShopTransactionNotificationsName = @"ShopNoticationTransaction";
static NSString *const ShopTransactionCustomError = @"ShopNoticationCustomError";

@interface Shop : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) NSArray *products;

+ (Shop *)instance;

+ (NSString *)formatPriceFromProduct:(SKProduct *)product;

- (SKProduct *)productWithIdentifier:(NSString *)identifier;
- (NSNumber *)creditsForProductIdentifier:(NSString *)productIdentifier;

- (NSNumber *)tierForProductIdentifier:(NSString *)productIdentifier;

- (void)requestProducts;
- (void)makePaymentRequestForProduct:(SKProduct *)product;

@end



