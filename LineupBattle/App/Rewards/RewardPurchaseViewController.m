//
//  RewardPurchaseViewController.m
//  GoalFury
//
//  Created by Kevin Li on 4/13/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import "RewardPurchaseViewController.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"


@interface RewardPurchaseViewController ()
@property (nonatomic, strong) ShopItem *shopItem;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *discountSection;
@end

static NSInteger navigationBarHeight = 64;
static NSInteger bottomStatusHeight = 28;
static NSInteger buyButtonHeight = 60;
static NSInteger boltViewTagStart = 1001;
static NSInteger discountTagStart = 1100;

@implementation RewardPurchaseViewController

- (id)initWithShopItem:(ShopItem *)item {
    self = [super init];
    
    if (self) {
        self.shopItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupBottomView];
    [self setupContentView];
    [self setupDescriptionView];
    self.view.backgroundColor = [UIColor lightBorderColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup UIs
- (void)setupNavigationBar {
    // Setup navigation bar
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], navigationBarHeight)];
    [self.navigationBar setBackgroundColor:[UIColor primaryColor]];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(navigationBarHeight);
    }];
    
    // Navigation title
    DefaultLabel *navTitle = [DefaultLabel initWithCondensedBoldSystemFontSize:17 color:[UIColor whiteColor]];
    [navTitle setText:@"SHOP"];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
    }];
    
    // Navigation left button
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navButton setImage:[UIImage imageNamed:@"ic_arrow_back"]
               forState:UIControlStateNormal];
    [navButton setContentMode:UIViewContentModeCenter];
    [navButton addTarget:self
                  action:@selector(goBack)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navButton];
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).offset(20);
        make.bottom.equalTo(self.navigationBar);
        make.width.equalTo(@54);
    }];
    
    // Navigation right bolt
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

- (void)setupBottomView {
    self.bottomView = [[UIView alloc] init];
    [self.bottomView setBackgroundColor:[UIColor primaryColor]];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(buyButtonHeight + bottomStatusHeight));
    }];
    
    UIButton *buyButton = [[UIButton alloc] init];
    [buyButton setTitle:@"Activate Discount" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(onPurchase) forControlEvents:UIControlEventTouchUpInside];
    
    [buyButton setTitleColor:[UIColor championsLeagueColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 20];
    [self.bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView);
        make.height.equalTo(@(buyButtonHeight));
    }];
    
    UIView *bottomStatusView = [[UIView alloc] init];
    [self.bottomView addSubview:bottomStatusView];
    [bottomStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomView);
        make.bottom.equalTo(buyButton.mas_top);
    }];
    bottomStatusView.backgroundColor = [UIColor actionColor];
    
    DefaultLabel *labelStatus = [DefaultLabel initWithSystemFontSize:13 color:[UIColor lightBorderColor]];
    [bottomStatusView addSubview:labelStatus];
    [labelStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bottomStatusView);
    }];
    labelStatus.text = @"You’ll recieve an email with purchase instructions";
}

- (void)setupContentView {
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderWidth = 0.0f;
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    self.contentView.layer.shadowRadius = 6.0;
    self.contentView.layer.shadowOpacity = 0.11;
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(7);
        make.left.equalTo(self.scrollView).offset(7);
        make.right.equalTo(self.scrollView).offset(-7);
        make.width.equalTo(@([Utils screenWidth] - 14));
    }];
    
    DefaultImageView *imageReward = [[DefaultImageView alloc] init];
    [imageReward loadImageWithUrlString:self.shopItem.image placeholder:@"rewardItemPlaceholder"];
    [self.contentView addSubview:imageReward];
    [imageReward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@150);
    }];
    
    DefaultLabel *labelName = [DefaultLabel initWithBoldSystemFontSize:12 color:[UIColor primaryTextColor]];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(imageReward.mas_bottom).offset(10);
    }];
    labelName.text = [self.shopItem.name uppercaseString];
    
    DefaultLabel *labelPrice = [DefaultLabel initWithLightSystemFontSize:20 color:[UIColor secondaryTextColor]];
    [self.contentView addSubview:labelPrice];
    [labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(labelName.mas_bottom).offset(2);
    }];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    NSDictionary *attrsDictionary = @{
                                      NSForegroundColorAttributeName : [UIColor secondaryTextColor],
                                      NSFontAttributeName: font,
                                      NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                                      };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.shopItem.price attributes:attrsDictionary];
    labelPrice.attributedText = attrString;
    
    DefaultLabel *labelDescription = [DefaultLabel initWithNanumFontSize:20 color:[UIColor primaryTextColor]];
    [self.contentView addSubview:labelDescription];
    [labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(labelPrice.mas_bottom).offset(10);
    }];
    labelDescription.text = @"CHOOSE DISCOUNT PRICE";
    
    [self setupDiscountSectionUnderView:labelDescription];
}

- (void)setupDiscountSectionUnderView:(UIView*)topView {
    self.discountSection = [[UIView alloc] init];
    [self.contentView addSubview:self.discountSection];
    [self.discountSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    // Show Discount Descriptions
    DefaultLabel *boltDescription = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [self.discountSection addSubview:boltDescription];
    [boltDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountSection).offset(32);
        make.top.equalTo(self.discountSection).offset(4);
    }];
    boltDescription.text = @"Spend bolts";
    
    DefaultLabel *discountDescription = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [self.discountSection addSubview:discountDescription];
    [discountDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(boltDescription.mas_centerY);
        make.right.equalTo(self.discountSection).offset(MIN(-([Utils screenWidth] * 0.3), -100));
    }];
    discountDescription.text = @"Discount";
    
    DefaultLabel *priceDescription = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [self.discountSection addSubview:priceDescription];
    [priceDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(boltDescription.mas_centerY);
        make.right.equalTo(self.discountSection).offset(-32);
    }];
    priceDescription.text = @"Your Price";
    
    // Show border
    UIView *borderTop = [[UIView alloc] init];
    [self.discountSection addSubview:borderTop];
    [borderTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(discountDescription.mas_bottom).offset(4);
        make.left.equalTo(self.discountSection).offset(0);
        make.right.equalTo(self.discountSection).offset(0);
        make.height.equalTo(@1);
    }];
    borderTop.backgroundColor = [UIColor lightBorderColor];
    
    int i = 0;
    while (i < self.shopItem.boltPrice.count) {
        
        NSDictionary *boltDict = self.shopItem.boltPrice[i];
        
        // Bolt view with light background
        UIView *boltView = [[UIView alloc] init];
        [boltView setTag:(boltViewTagStart + i)];
        [self.discountSection addSubview:boltView];
        [boltView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.discountSection);
            make.right.equalTo(self.discountSection);
            make.top.equalTo(priceDescription.mas_bottom).offset(44 * i);
            make.height.equalTo(@44);
            if (i == self.shopItem.boltPrice.count - 1) {
                make.bottom.equalTo(self.discountSection);
            }
        }];
        
        UIButton *discountButton = [[UIButton alloc] init];
        [discountButton setTag:discountTagStart + i];
        [boltView addSubview:discountButton];
        [discountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(boltView);
        }];
        [discountButton addTarget:self
                           action:@selector(onSelectDiscount:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        if (i < self.shopItem.boltPrice.count - 1) {
            UIImageView *borderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_dot_line"]];
            [boltView addSubview:borderImage];
            [borderImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(boltView);
                make.leftMargin.offset(32);
                make.rightMargin.offset(-32);
            }];
        }
        
        // Select image
        UIImageView *imageSelect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_select_inactive"]];
        [boltView addSubview:imageSelect];
        [imageSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boltView).offset(36);
            make.centerY.equalTo(boltView);
            make.width.height.equalTo(@26);
        }];
        [imageSelect setTag:boltView.tag + 10];
        
        // Bolt icon and count
        DefaultImageView *imgBolt = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"ic_bolt"]];
        [boltView addSubview:imgBolt];
        [imgBolt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageSelect.mas_right).offset(10);
            make.centerY.equalTo(boltView);
            make.width.equalTo(@9);
            make.height.equalTo(@13);
        }];
        
        DefaultLabel *labelBolt = [DefaultLabel initWithCondensedBoldSystemFontSize:20 color:[UIColor highlightColor]];
        [boltView addSubview:labelBolt];
        [labelBolt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgBolt.mas_right).offset(4);
            make.centerY.equalTo(boltView);
        }];
        labelBolt.text = [boltDict objectForKey:@"boltCount"];
        [labelBolt setTag:boltView.tag + 11];
        
        // Discount %, FREE
        UIView *discountContainer = [[UIView alloc] init];
        [boltView addSubview:discountContainer];
        [discountContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(discountDescription.mas_right);
            make.centerY.equalTo(boltView);
            if ([[[boltDict objectForKey:@"discount"] lowercaseString] isEqualToString:@"free"]) {
                make.width.equalTo(@44);
            } else {
                make.width.equalTo(@36);
            }
            make.height.equalTo(@18);
        }];
        discountContainer.backgroundColor = [UIColor relegationColor];
        discountContainer.layer.cornerRadius = 4;
        discountContainer.layer.borderWidth = 0.0f;
        discountContainer.layer.masksToBounds = true;
        
        DefaultLabel *labelDiscount = [DefaultLabel initWithBoldSystemFontSize:12 color:[UIColor whiteColor]];
        [discountContainer addSubview:labelDiscount];
        [labelDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(discountContainer);
        }];
        if ([[[boltDict objectForKey:@"discount"] lowercaseString] isEqualToString:@"free"]) {
            labelDiscount.text = [[boltDict objectForKey:@"discount"] uppercaseString];
        } else {
            labelDiscount.text = [NSString stringWithFormat:@"-%@%%", [[boltDict objectForKey:@"discount"] uppercaseString]];
        }
        
        // Price
        DefaultLabel *priceLabel = [DefaultLabel initWithSystemFontSize:17 color:[UIColor highlightColor]];
        [boltView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(boltView);
            make.right.equalTo(boltView).offset(-32);
        }];
        priceLabel.text = [boltDict objectForKey:@"price"];
        [priceLabel setTag:boltView.tag + 12];
        i++;
    }
    
}

- (void)setupDescriptionView {
    DefaultLabel *labelDescription = [DefaultLabel initWithSystemFontSize:12 color:[UIColor primaryColor]];
    [self.scrollView addSubview:labelDescription];
    [labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.left.right.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView).offset(-10);
    }];
    labelDescription.text = @"By completing this deal you agree to GoalFury’s\nterms and conditions";
    labelDescription.numberOfLines = 0;
    labelDescription.textAlignment = NSTextAlignmentCenter;
}

- (void)setupDiscountSectionClear {
    int i = 0;
    while (i < self.shopItem.boltPrice.count) {
        UIView *boltView = [self getChildViewFrom:self.discountSection byTag:(boltViewTagStart + i)];
        DefaultImageView *imageSelect = (DefaultImageView *)[self getChildViewFrom:boltView byTag:boltView.tag + 10];
        DefaultLabel *labelBolt = (DefaultLabel *)[self getChildViewFrom:boltView byTag:boltView.tag + 11];
        DefaultLabel *priceLabel = (DefaultLabel *)[self getChildViewFrom:boltView byTag:boltView.tag + 12];
        
        boltView.backgroundColor = [UIColor whiteColor];
        [imageSelect setImage:[UIImage imageNamed:@"ic_select_inactive"]];
        labelBolt.textColor = [UIColor highlightColor];
        priceLabel.textColor = [UIColor highlightColor];
        i++;
    }
}

#pragma mark - Button actions
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onPurchase {
    NSLog(@"onPurchase");
}

- (void)onSelectDiscount:(UIButton *)button {
    NSInteger index = button.tag - discountTagStart;
    [self setupDiscountSectionClear];
    UIView *boltView = [self getChildViewFrom:self.discountSection byTag:(boltViewTagStart + index)];
    if (boltView != nil) {
        DefaultImageView * imageSelect = (DefaultImageView *)[self getChildViewFrom:boltView byTag:boltView.tag + 10];
        DefaultLabel *labelBolt = (DefaultLabel *)[self getChildViewFrom:boltView byTag:boltView.tag + 11];
        DefaultLabel *priceLabel = (DefaultLabel *)[self getChildViewFrom:boltView byTag:boltView.tag + 12];
        
        boltView.backgroundColor = [UIColor lightBackgroundColor];
        [imageSelect setImage:[UIImage imageNamed:@"ic_select_active"]];
        labelBolt.textColor = [UIColor primaryColor];
        priceLabel.textColor = [UIColor primaryColor];
    }
}

- (UIView *)getChildViewFrom:(UIView *)parentView byTag:(NSInteger)tag {
    for (UIView *child in parentView.subviews){
        if (child.tag == tag) {
            return child;
        }
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
