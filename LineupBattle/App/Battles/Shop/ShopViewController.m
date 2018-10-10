//
//  ViewController.m
//  Champion
//
//  Created by Anders Borre Hansen on 10/04/15.
//  Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "SCLButton.h"
#import "Crashlytics.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <JGProgressHUD/JGProgressHUD-Defines.h>
#import <JGProgressHUD/JGProgressHUD.h>
#import "ShopViewController.h"
#import "ShopItemView.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"
#import "DefaultLabel.h"
#import "CoinView.h"
#import "Wallet.h"
#import "SpinnerHelper.h"
#import "HexColors.h"


@interface ShopViewController ()
@property (nonatomic, strong) NSArray *productButtons;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, strong) CoinView *coinView;
@end

@implementation ShopViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Shop";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(closeShopAction)];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedTransaction:) name:ShopTransactionNotificationsName object:[Shop instance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCredits:) name:WalletNotificationCreditChangeName object:[Wallet instance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customErrorTransaction:) name:ShopTransactionCustomError object:[Shop instance]];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)closeShopAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    DefaultLabel *preLabel = [DefaultLabel initWithText:@"You have"];
    DefaultLabel *postLabel = [DefaultLabel initWithText:@"- Get more credits here"];
    self.coinView = [[CoinView alloc] initWithCoins:[[[Wallet instance] credits] integerValue]];

    [self.view addSubview:preLabel];
    [self.view addSubview:postLabel];
    [self.view addSubview:self.coinView];

    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.centerX.equalTo(self.view).offset(-35);
        make.height.equalTo(@18);
    }];

    [@[preLabel, postLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coinView);
    }];

    [preLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coinView.mas_left).offset(-5);
    }];

    [postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinView.mas_right).offset(5);
    }];

    self.view.backgroundColor = [UIColor whiteColor];

    ShopItemView *shopItemView1 = [[ShopItemView alloc] initWithCoins:1500 image:[UIImage imageNamed:@"stack_small"] imageXOffset:0];
    ShopItemView *shopItemView2 = [[ShopItemView alloc] initWithCoins:4350 image:[UIImage imageNamed:@"stack_medium"] imageXOffset:17];
    ShopItemView *shopItemView3 = [[ShopItemView alloc] initWithCoins:18750 image:[UIImage imageNamed:@"stack_large"] imageXOffset:17];

    [self.view addSubview:shopItemView1];
    [self.view addSubview:shopItemView2];
    [self.view addSubview:shopItemView3];

    NSNumber *itemWidth = @([Utils screenWidth]/2);
    NSNumber *itemHeight = @([Utils screenWidth]/1.7);


    CGFloat startItemHeight = 35.f;

    [@[shopItemView1, shopItemView2, shopItemView3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(itemWidth);
        make.height.equalTo(itemHeight);
    }];

    [@[shopItemView1, shopItemView3] mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.view);
    }];

    [@[shopItemView2] mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(self.view);
    }];

    [@[shopItemView1, shopItemView2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(startItemHeight);
    }];

    [@[shopItemView3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopItemView1.mas_bottom);
    }];

    NSDictionary *buttonConf = @{
        @"backgroundColor": [UIColor actionColor]
    };

    CGFloat static fontSize = 15.f;

    SCLButton *shopButton1 = [[SCLButton alloc] init];
    [shopButton1 parseConfig:buttonConf];
    shopButton1.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [shopButton1 addTarget:self action:@selector(makePaymentRequestForProductFromButton:) forControlEvents:UIControlEventTouchUpInside];
    shopButton1.tag = 0;
    shopButton1.layer.cornerRadius = 4;
    [self.view addSubview:shopButton1];
    [shopButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopItemView1);
        make.centerY.equalTo(shopItemView1).offset(65);
    }];

    SCLButton *shopButton2 = [[SCLButton alloc] init];
    [shopButton2 parseConfig:buttonConf];
    shopButton2.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [shopButton2 addTarget:self action:@selector(makePaymentRequestForProductFromButton:) forControlEvents:UIControlEventTouchUpInside];
    shopButton2.tag = 1;
    shopButton2.layer.cornerRadius = 4;
    [self.view addSubview:shopButton2];
    [shopButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopItemView2);
        make.centerY.equalTo(shopItemView2).offset(65);
    }];

    SCLButton *shopButton3 = [[SCLButton alloc] init];
    [shopButton3 parseConfig:buttonConf];
    shopButton3.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [shopButton3 addTarget:self action:@selector(makePaymentRequestForProductFromButton:) forControlEvents:UIControlEventTouchUpInside];
    shopButton3.tag = 2;
    shopButton3.layer.cornerRadius = 4;
    [self.view addSubview:shopButton3];
    [shopButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopItemView3);
        make.centerY.equalTo(shopItemView3).offset(65);
    }];

    self.productButtons = @[
        shopButton1,
        shopButton2,
        shopButton3
    ];

    [@[shopButton1, shopButton2, shopButton3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@120);
    }];

    // Lines
    UIColor *lineColor = [UIColor hx_colorWithHexString:@"ebecee"];

    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0.f, startItemHeight, [Utils screenWidth], 1.f)];
    lineView0.backgroundColor = lineColor;
    [self.view addSubview:lineView0];

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake([Utils screenWidth]/2.f, startItemHeight, 1.f, [itemHeight integerValue]*2.f)];
    lineView1.backgroundColor = lineColor;
    [self.view addSubview:lineView1];

    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0.f, [itemHeight integerValue]+startItemHeight, [Utils screenWidth], 1.f)];
    lineView2.backgroundColor = lineColor;
    [self.view addSubview:lineView2];

    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0.f, [itemHeight integerValue]*2.f+startItemHeight, [Utils screenWidth], 1.f)];
    lineView3.backgroundColor = lineColor;
    [self.view addSubview:lineView3];

    self.hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];
    self.hud.backgroundColor = [UIColor colorWithCGColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.35].CGColor];
    self.view.layer.zPosition = 1;

    // Data logic
    if ([Shop instance].products.count == 0) {
        [[Shop instance] requestProducts];
        [self.hud showInView:self.view];
    }

    @weakify(self);
    [[RACObserve([Shop instance], products) ignore:nil] subscribeNext:^(NSArray *products) {
        @strongify(self);

        [self.hud dismissAnimated:YES];

        for (int i = 0; i < products.count; ++i) {
            SKProduct *product = products[(NSUInteger)i];

            CLS_LOG(@"Product: %@ %@ %lf", product.productIdentifier, product.localizedTitle, product.price.floatValue);
            [((SCLButton *)self.productButtons[(NSUInteger)i]) setTitle:[Shop formatPriceFromProduct:product] forState:UIControlStateNormal];
        }
    }];
}

- (void)makePaymentRequestForProductFromButton:(UIView *)button {
    self.hud.textLabel.text = @"Working";
    [self.hud showInView:self.navigationController.view];

    SKProduct *product = [Shop instance].products[(NSUInteger)button.tag];
    [[Shop instance] makePaymentRequestForProduct:product];
}

#pragma mark - Notification Methods
- (void)updateCredits:(id)updateCredits {
    [self.coinView setCoins:[[[Wallet instance] credits] integerValue]];
}

- (void)updatedTransaction:(NSNotification *)notification {
    SKPaymentTransaction *transaction = notification.userInfo[@"transaction"];

    switch (transaction.transactionState) {
        // Call the appropriate custom method for the transaction state.
        case SKPaymentTransactionStatePurchasing:
            CLS_LOG(@"SKPaymentTransactionStatePurchasing: %@", transaction);
            break;
        case SKPaymentTransactionStateDeferred:
            CLS_LOG(@"SKPaymentTransactionStateDeferred: %@", transaction);
            _hud.textLabel.text = @"Waiting for approval";
            break;
        case SKPaymentTransactionStateFailed:
            CLS_LOG(@"SKPaymentTransactionStateFailed: %@, %@", transaction, transaction.error);
            [self.hud dismiss];
            if (transaction.error.code == SKErrorPaymentCancelled) return;
            [self failedTransaction:transaction];
            break;
        case SKPaymentTransactionStatePurchased:
            CLS_LOG(@"SKPaymentTransactionStatePurchased: %@", transaction);
            [self.hud dismiss];
            break;
        case SKPaymentTransactionStateRestored:
            CLS_LOG(@"SKPaymentTransactionStateRestored: %@", transaction);
            break;
        default:
            // For debugging
            CLS_LOG(@"Unexpected transaction state %@", @(transaction.transactionState));
            break;
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Error"];
    [alertView setMessage:transaction.error.localizedDescription];
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}

- (void)customErrorTransaction:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = userInfo[@"title"];
    NSString *message = userInfo[@"message"];

    if (!title) {
        NSLog(@"No title for custom error");
        return;
    }

    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title];
    if (message) [alertView setMessage:message];
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}

@end
