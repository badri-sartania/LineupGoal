//
// Created by Anders Hansen on 21/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "RewardsCollectionViewController.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"
#import "Wallet.h"
#import "DefaultLabel.h"
#import "ShopViewController.h"
#import "DefaultNavigationController.h"
#import "ShopItem.h"
#import "RewardCollectionViewCell.h"
#import "DefaultNavigationController.h"
#import "RewardDetailViewController.h"

@interface RewardsCollectionViewController ()
@property (nonatomic, strong) NSArray *shopItems;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) DefaultLabel *coinLabel;
@end

static NSInteger navigationBarHeight = 64;

@implementation RewardsCollectionViewController

- (id)init {
    self = [super init];
    if (self) {
        /*
        - shop image
        - name
        - price (the one crossed over)
        - amount of items
        - bolt swap price(s): I will create from 1 to 4 prices where each has 3 parameters:
            - discount
            - number of bolts to activate discount
            - price
         */
        
        NSArray *dic = @[
                         @{
                             @"image": @"https://www.cawila.de/media/product/b62/adidas-real-madrid-trikot-ucl-2017-2018-9d3.png",
                             @"name": @"Real Madrid Jersey",
                             @"price": @"$100",
                             @"amount": @"100",
                             @"boltPrice": @[
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         }
                                     
                                     ]
                             },
                         @{
                             @"image": @"https://www.cawila.de/media/product/b62/adidas-real-madrid-trikot-ucl-2017-2018-9d3.png",
                             @"name": @"Real Madrid Jersey",
                             @"price": @"$100",
                             @"amount": @"100",
                             @"boltPrice": @[
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         }
                                     
                                     ]
                             },
                         @{
                             @"image": @"https://www.cawila.de/media/product/b62/adidas-real-madrid-trikot-ucl-2017-2018-9d3.png",
                             @"name": @"Real Madrid Jersey",
                             @"price": @"$100",
                             @"amount": @"100",
                             @"boltPrice": @[
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         }
                                     
                                     ]
                             },
                         @{
                             @"image": @"https://www.cawila.de/media/product/b62/adidas-real-madrid-trikot-ucl-2017-2018-9d3.png",
                             @"name": @"Real Madrid Jersey",
                             @"price": @"$100",
                             @"amount": @"100",
                             @"boltPrice": @[
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         }
                                     
                                     ]
                             },
                         @{
                             @"image": @"https://www.cawila.de/media/product/b62/adidas-real-madrid-trikot-ucl-2017-2018-9d3.png",
                             @"name": @"Real Madrid Jersey",
                             @"price": @"$100",
                             @"amount": @"100",
                             @"boltPrice": @[
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         },
                                     @{
                                         @"discount": @"10",
                                         @"boltCount": @"5",
                                         @"price": @"$90"
                                         }
                                     
                                     ]
                             },
                         ];
        self.shopItems = [MTLJSONAdapter modelsOfClass:[ShopItem class] fromJSONArray:dic error:NULL];
        NSLog(@"Template shop items");
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupCollectionView];
    
    self.view.backgroundColor = [UIColor lightBorderColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}


- (void)setupNavigationBar {
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], navigationBarHeight)];
    [self.navigationBar setBackgroundColor:[UIColor primaryColor]];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(navigationBarHeight);
    }];
    
    UILabel *navTitle = [[UILabel alloc] init];
    [navTitle setText:@"REWARDS"];
    navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
    }];
    
    DefaultLabel *boltCountLabel = [DefaultLabel initWithCondensedBoldSystemFontSize:17 color:[UIColor whiteColor]];
    [boltCountLabel setText:@"150"];
    [self.navigationBar addSubview:boltCountLabel];
    [boltCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navTitle);
        make.right.equalTo(self.navigationBar).offset(-10);
    }];
    
    UIImageView *imageBolt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_bolt"]];
    [self.navigationBar addSubview:imageBolt];
    [imageBolt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(boltCountLabel.mas_left).offset(-5);
        make.centerY.equalTo(navTitle);
    }];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(([Utils screenWidth] - 10) / 2, 350);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, navigationBarHeight + 4, [Utils screenWidth] - 10, [Utils screenHeight] - navigationBarHeight - 8) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[RewardCollectionViewCell class] forCellWithReuseIdentifier:@"rewardCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(4);
        make.bottom.equalTo(self.view).offset(-4);
    }];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Button Actions

- (void)shopAction {
    ShopViewController *shopViewController = [[ShopViewController alloc] init];
    DefaultNavigationController *shopNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:shopViewController];
    [self presentViewController:shopNavigationController animated:YES completion:nil];
}

#pragma mark - Collection View Delegates

- (RewardCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ShopItem *item = [self.shopItems objectAtIndex:indexPath.section * 2 + indexPath.row];
    RewardCollectionViewCell *cell = (RewardCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"rewardCollectionViewCell" forIndexPath:indexPath];
    [cell setupCellWithShopItem:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopItem *item = [self.shopItems objectAtIndex:indexPath.section * 2 + indexPath.row];
    RewardDetailViewController *rewardDetailVC = [[RewardDetailViewController alloc] initWithShopItem:item];
    DefaultNavigationController *defaultNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:rewardDetailVC];
    [self presentViewController:defaultNavigationController animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemCount = 1;
    if (self.shopItems.count > section * 2 + 1)
        itemCount = 2;
    return itemCount;
}

//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    return CGSizeMake(0, 0);
//}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return ceil((float)self.shopItems.count / 2);
}

@end
