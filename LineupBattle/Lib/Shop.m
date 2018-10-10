//
// Created by Anders Borre Hansen on 18/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "Crashlytics.h"
#import <BlocksKit/NSArray+BlocksKit.h>
#import "Shop.h"
#import "Identification.h"
#import "HTTP.h"
#import "bio.h"
#import "pkcs7.h"
#import "obj_mac.h"
#import "objects.h"
#import "x509_vfy.h"
#import "RMAppReceipt.h"
#import "Wallet.h"
#import "Mixpanel.h"
#import "HTTP+RAC.h"

@interface Shop ()
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@end

@implementation Shop

NSDictionary static *_productDefinitions;
NSArray static *_productOrder;
NSDictionary static *_productTiers;


+ (Shop *)instance {
    static Shop *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _productDefinitions = @{
                @"com.pumodo.lineupbattle.1500credits" : @1500,
                @"com.pumodo.lineupbattle.4325credits" : @4325,
                @"com.pumodo.lineupbattle.18750credits" : @18750
            };
            _productOrder = @[
                @"com.pumodo.lineupbattle.1500credits",
                @"com.pumodo.lineupbattle.4325credits",
                @"com.pumodo.lineupbattle.18750credits"
            ];
            _productTiers = @{
                @"com.pumodo.lineupbattle.1500credits": @2,
                @"com.pumodo.lineupbattle.4325credits": @5,
                @"com.pumodo.lineupbattle.18750credits": @20
            };
        }
    }

    return _instance;
}

#pragma mark - Product request
- (void)requestProducts {
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:[_productDefinitions allKeys]]];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

#pragma mark - Make Payments
- (void)makePaymentRequestForProduct:(SKProduct *)product {
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.applicationUsername = [self hashedValueForAccountName:[Identification userId]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Payment Delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.products = [self sortSKProductsInCorrectOrder:response.products];
    CLS_LOG(@"Product count: %ld", (long)[self.products count]);
}

#pragma mark - SKRequest observing
- (void)requestDidFinish:(SKRequest *)request {
    CLS_LOG(@"%@", request);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    CLS_LOG(@"%@ | %@", request, error);
}

#pragma mark - Payment Queue
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (int i = 0; i < transactions.count; ++i) {
        SKPaymentTransaction *transaction = transactions[(NSUInteger)i];

        [[NSNotificationCenter defaultCenter] postNotificationName:ShopTransactionNotificationsName object:self userInfo:@{
            @"transaction": transaction
        }];

        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSURL *receiptURL = [mainBundle appStoreReceiptURL];
            NSError *receiptError;
            BOOL isPresent = [receiptURL checkResourceIsReachableAndReturnError:&receiptError];
            if (!isPresent) {
                [self customError:@{
                    @"title": @"Error while processing purchase"
                }];
                NSLog(@"Error: No Receipt");
                return;
            }

            // Receipt integretry validation
            BOOL isReceiptValid = [self verifyReceipt:receiptURL];
            NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
            if (!isReceiptValid) {
                [self customError:@{
                    @"title": @"Validation of purchase failed"
                }];
                NSLog(@"Receipt validation failed");
                return;
            }

            // Receipt information validation
            [RMAppReceipt setAppleRootCertificateURL:[[NSBundle mainBundle] URLForResource:@"AppleIncRootCertificate" withExtension:@"cer"]];
            RMAppReceipt *appReceipt = [RMAppReceipt bundleReceipt];

            if(![self validateReceiptInformation:appReceipt]) {
                [self customError:@{
                    @"title": @"Validation of purchase failed"
                }];
                NSLog(@"Receipt information validation failed");
                return;
            }

            // Send receipt to watson
            [[[HTTP instance] put:@"/register-purchase" body:@{
                @"receipt": [receipt base64EncodedStringWithOptions:0]
            }] subscribeNext:^(id x) {
                [[Wallet instance] addTransactions:appReceipt.inAppPurchases timestamp:[NSDate date]];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }];
        }
    }
}

- (void)customError:(NSDictionary *)dic {
    [[NSNotificationCenter defaultCenter] postNotificationName:ShopTransactionCustomError object:self userInfo:dic];
}

- (BOOL)validateReceiptInformation:(RMAppReceipt *)receipt {
    if (receipt.inAppPurchases.count == 0) return NO;

    return YES;
}

#pragma mark - Helpers
// Custom method to calculate the SHA-256 hash using Common Crypto
- (NSString *)hashedValueForAccountName:(NSString*)userAccountName {
    const int HASH_SIZE = 32;
    unsigned char hashedChars[HASH_SIZE];
    const char *accountName = [userAccountName UTF8String];
    size_t accountNameLen = strlen(accountName);

    // Confirm that the length of the user name is small enough
    // to be recast when calling the hash function.
    if (accountNameLen > UINT32_MAX) {
        CLS_LOG(@"Account name too long to hash: %@", userAccountName);
        return nil;
    }
    CC_SHA256(accountName, (CC_LONG)accountNameLen, hashedChars);

    // Convert the array of bytes into a string showing its hex representation.
    NSMutableString *userAccountHash = [[NSMutableString alloc] init];
    for (int i = 0; i < HASH_SIZE; i++) {
        // Add a dash every four bytes, for readability.
        if (i != 0 && i%4 == 0) {
            [userAccountHash appendString:@"-"];
        }
        [userAccountHash appendFormat:@"%02x", hashedChars[i]];
    }

    return userAccountHash;
}

- (BOOL)verifyReceipt:(NSURL *)receiptUrl {
    // Load the receipt file
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];

    // Create a memory buffer to extract the PKCS #7 container
    BIO *receiptBIO = BIO_new(BIO_s_mem());
    BIO_write(receiptBIO, [receiptData bytes], (int) [receiptData length]);
    PKCS7 *receiptPKCS7 = d2i_PKCS7_bio(receiptBIO, NULL);
    if (!receiptPKCS7) {
        // Validation fails
    }

    // Check that the container has a signature
    if (!PKCS7_type_is_signed(receiptPKCS7)) {
        return false;
    }

    // Check that the signed container has actual data
    if (!PKCS7_type_is_data(receiptPKCS7->d.sign->contents)) {
        return false;
    }

    // Load the Apple Root CA (downloaded from https://www.apple.com/certificateauthority/)
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"AppleIncRootCertificate" ofType:@"cer"];
    NSData *appleRootData = [NSData dataWithContentsOfFile:certPath];

    BIO *appleRootBIO = BIO_new(BIO_s_mem());
    BIO_write(appleRootBIO, (const void *) [appleRootData bytes], (int) [appleRootData length]);
    X509 *appleRootX509 = d2i_X509_bio(appleRootBIO, NULL);

    // Create a certificate store
    X509_STORE *store = X509_STORE_new();
    X509_STORE_add_cert(store, appleRootX509);

    // Be sure to load the digests before the verification
    OpenSSL_add_all_digests();

    // Check the signature
    int result = PKCS7_verify(receiptPKCS7, NULL, store, NULL, NULL, 0);
    if (result != 1) {
        return false;
    }

    return true;
}

- (NSArray *)sortSKProductsInCorrectOrder:(NSArray *)products {
    return [products sortedArrayUsingComparator:^NSComparisonResult(SKProduct *obj1, SKProduct *obj2) {
        return [@([_productOrder indexOfObject:obj1.productIdentifier]) compare:@([_productOrder indexOfObject:obj2.productIdentifier])];
    }];
}

- (SKProduct *)productWithIdentifier:(NSString *)identifier {
    return [self.products bk_match:^BOOL(SKProduct *product) {
        return [product.productIdentifier isEqualToString:identifier];
    }];
}

- (NSNumber *)creditsForProductIdentifier:(NSString *)productIdentifier {
    return _productDefinitions[productIdentifier];
}

- (NSNumber *)tierForProductIdentifier:(NSString *)productIdentifier {
    return _productTiers[productIdentifier];
}

+ (NSString *)formatPriceFromProduct:(SKProduct *)product {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];

    return formattedPrice;
}

@end

