//
//  RewardDetailViewController.m
//  GoalFury
//
//  Created by Alexandru on 4/11/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import "RewardDetailViewController.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "SMPageControl.h"
#import "RewardPurchaseViewController.h"

@interface RewardDetailViewController ()

@property (nonatomic, strong) ShopItem *shopItem;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *imageSlider;
@property (nonatomic, strong) SMPageControl *pageControl;
@end

static NSInteger navigationBarHeight = 64;
static NSInteger buyButtonHeight = 60;

@implementation RewardDetailViewController

- (id)initWithShopItem:(ShopItem *)item {
    self = [super init];
    
    if (self) {
        self.shopItem = item;
        self.images = @[
                        @"https://images.footballfanatics.com/FFImage/thumb.aspx?i=/productimages/_2841000/altimages/ff_2841407alt2_full.jpg&w=2000",
                        @"https://cdn1.uksoccershop.com/images/adtnl_prodts_img/1497445823-real-madrid-2017-2018-adidas-away-shirt-long-sleeve.jpg",
                        @"https://www.cawila.de/media/product/b62/adidas-real-madrid-trikot-ucl-2017-2018-9d3.png"
                        ];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES];
    [self setupNavigationBar];
    [self setupBottomView];
    [self setupScrollContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Views
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
    [navTitle setText:@"BOLTS FOR DISCOUNT"];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
    }];
    
    // Navigation left button
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navButton setImage:[UIImage imageNamed:@"ic_arrow_down"]
               forState:UIControlStateNormal];
    [navButton setContentMode:UIViewContentModeCenter];
    [navButton addTarget:self
                  action:@selector(closeDetail)
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
        make.height.equalTo(@(buyButtonHeight));
    }];
    
    UIButton *buyButton = [[UIButton alloc] init];
    [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(onPurchase) forControlEvents:UIControlEventTouchUpInside];
    
    [buyButton setTitleColor:[UIColor championsLeagueColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 20];
    [self.bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
}

- (void)setupScrollContent {
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *sliderContainer = [self setupImageSlider];
    
    // Show Price
    DefaultLabel *labelPrice = [DefaultLabel initWithLightSystemFontSize:20 color:[UIColor secondaryTextColor]];
    [self.scrollView addSubview:labelPrice];
    [labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(sliderContainer.mas_bottom).offset(10);
    }];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:35.0];
    NSDictionary *attrsDictionary = @{
                                      NSForegroundColorAttributeName : [UIColor secondaryTextColor],
                                      NSFontAttributeName: font,
                                      NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                                      };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.shopItem.price attributes:attrsDictionary];
    labelPrice.attributedText = attrString;
    
    // Show Discount and Information Section
    [self setupInformationSectionUnder:[self setupDiscountSectionUnderPrice:labelPrice]];
}

- (UIView *)setupImageSlider {
    UIView *sliderContainer = [[UIView alloc] init];
    [self.scrollView addSubview:sliderContainer];
    [sliderContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.right.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(10);
        make.height.equalTo(@300);
        make.width.equalTo(@([Utils screenWidth]));
    }];
    
    self.imageSlider = [[UIScrollView alloc] init];
    self.imageSlider.delegate = self;
    [sliderContainer addSubview:self.imageSlider];
    [self.imageSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sliderContainer);
        make.right.equalTo(sliderContainer);
        make.top.equalTo(sliderContainer);
        make.height.equalTo(@280);
    }];
    [self.imageSlider setShowsVerticalScrollIndicator:NO];
    [self.imageSlider setShowsHorizontalScrollIndicator:NO];
    [self.imageSlider setPagingEnabled:YES];
    int i = 0;
    while (i < self.images.count) {
        DefaultImageView *image = [[DefaultImageView alloc] init];
        [self.imageSlider addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageSlider);
            make.bottom.equalTo(self.imageSlider);
            make.left.equalTo(self.imageSlider).offset([Utils screenWidth] * i);
            make.width.equalTo(@([Utils screenWidth]));
            make.height.equalTo(@280);
        }];
        [image loadImageWithUrlString:self.images[i] placeholder:@"rewardImagePlaceholder"];
        
        if (i == self.images.count - 1) {
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.imageSlider);
            }];
        }
        i++;
    }
    
    self.pageControl = [[SMPageControl alloc] init];
    self.pageControl.numberOfPages = i;
    self.pageControl.pageIndicatorImage = [UIImage imageNamed:@"img_page_indicator"];
    self.pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"img_active_page_indicator"];
    [self.pageControl sizeToFit];
    [sliderContainer addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sliderContainer);
        make.bottom.equalTo(sliderContainer);
        make.width.equalTo(@(i * 30));
    }];
    self.pageControl.currentPage = 0;
    
    // Show Reward item count
    UIView *countContainer = [[UIView alloc] init];
    [sliderContainer addSubview:countContainer];
    [countContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sliderContainer).offset(10);
        make.top.equalTo(sliderContainer).offset(2);
        make.width.equalTo(@65);
        make.height.equalTo(@26);
    }];
    countContainer.backgroundColor = [UIColor championsLeagueColor];
    countContainer.layer.cornerRadius = 4;
    countContainer.layer.borderWidth = 0.0f;
    countContainer.layer.masksToBounds = true;
    
    DefaultLabel *labelCount = [DefaultLabel initWithBoldSystemFontSize:15 color:[UIColor whiteColor]];
    [countContainer addSubview:labelCount];
    [labelCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(countContainer);
    }];
    labelCount.text = [NSString stringWithFormat:@"%@ left", self.shopItem.amount];
    
    return sliderContainer;
}

- (UIView *)setupDiscountSectionUnderPrice:(UIView *)price {
    UIView *discountSection = [[UIView alloc] init];
    [self.scrollView addSubview:discountSection];
    [discountSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price.mas_bottom).offset(10);
        make.left.right.equalTo(self.scrollView);
    }];
    
    // Show border
    UIView *borderTop = [[UIView alloc] init];
    [discountSection addSubview:borderTop];
    [borderTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(discountSection);
        make.left.equalTo(discountSection).offset(32);
        make.right.equalTo(discountSection).offset(-32);
        make.height.equalTo(@1);
    }];
    borderTop.backgroundColor = [UIColor lightBorderColor];
    
    // Show Discount Descriptions
    DefaultLabel *boltDescription = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [discountSection addSubview:boltDescription];
    [boltDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(discountSection).offset(22);
        make.top.equalTo(borderTop.mas_bottom).offset(4);
    }];
    boltDescription.text = @"Spend bolts";
    
    DefaultLabel *discountDescription = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [discountSection addSubview:discountDescription];
    [discountDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderTop.mas_bottom).offset(4);
        make.right.equalTo(discountSection).offset(MIN(-([Utils screenWidth] * 0.3), -100));
    }];
    discountDescription.text = @"Discount";
    
    DefaultLabel *priceDescription = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
    [discountSection addSubview:priceDescription];
    [priceDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(discountSection).offset(-22);
        make.top.equalTo(borderTop.mas_bottom).offset(4);
    }];
    priceDescription.text = @"Your Price";
    
    int i = 0;
    while (i < self.shopItem.boltPrice.count) {
        
        NSDictionary *boltDict = self.shopItem.boltPrice[i];
        
        // Bolt view with light background
        UIView *boltView = [[UIView alloc] init];
        [discountSection addSubview:boltView];
        [boltView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(discountSection).offset(22);
            make.right.equalTo(discountSection).offset(-22);
            make.top.equalTo(priceDescription.mas_bottom).offset(34 * i + 8);
            make.height.equalTo(@26);
            if (i == self.shopItem.boltPrice.count - 1) {
                make.bottom.equalTo(discountSection).offset(-10);
            }
        }];
        boltView.backgroundColor = [UIColor lightBackgroundColor];
        boltView.layer.cornerRadius = 4;
        boltView.layer.borderWidth = 0.0f;
        boltView.layer.masksToBounds = true;
        
        // Bolt icon and count
        DefaultImageView *imgBolt = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"ic_bolt"]];
        [boltView addSubview:imgBolt];
        [imgBolt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boltView).offset(4);
            make.centerY.equalTo(boltView);
            make.width.equalTo(@9);
            make.height.equalTo(@13);
        }];
        
        DefaultLabel *labelBolt = [DefaultLabel initWithCondensedBoldSystemFontSize:15 color:[UIColor primaryTextColor]];
        [boltView addSubview:labelBolt];
        [labelBolt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgBolt.mas_right).offset(4);
            make.centerY.equalTo(boltView);
        }];
        labelBolt.text = [boltDict objectForKey:@"boltCount"];
        
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
        DefaultLabel *priceLabel = [DefaultLabel initWithSystemFontSize:17 color:[UIColor primaryColor]];
        [boltView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(boltView);
            make.right.equalTo(boltView).offset(-6);
        }];
        priceLabel.text = [boltDict objectForKey:@"price"];
        
        i++;
    }
    
    return discountSection;
}

- (void)setupInformationSectionUnder:(UIView *) topView {
    UIView *informationContainer = [[UIView alloc] init];
    [self.scrollView addSubview:informationContainer];
    [informationContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(24);
        make.bottom.equalTo(self.scrollView).offset(-10);
        make.left.equalTo(self.scrollView).offset(20);
        make.right.equalTo(self.scrollView).offset(-20);
    }];
    
    // Item name
    DefaultLabel *labelName = [DefaultLabel initWithMediumSystemFontSize:17 color:[UIColor primaryColor]];
    [informationContainer addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(informationContainer);
    }];
    labelName.text = [self.shopItem.name uppercaseString];
    labelName.lineBreakMode = NSLineBreakByWordWrapping;
    labelName.numberOfLines = 0;
    
    // Item information
    DefaultLabel *itemInformation = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryColor]];
    [informationContainer addSubview:itemInformation];
    [itemInformation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(informationContainer);
        make.top.equalTo(labelName.mas_bottom).offset(10);
    }];
    itemInformation.text = @"With up to 40 hours of battery life, Beats Solo3 Wireless is your perfect everyday headphone. With Fast Fuel, a 5-minute charge gives you 3 hours of playback. Enjoy award-winning Beats sound with Class 1 Bluetooth® wireless listening freedom. The on-ear, cushioned ear cups are adjustable so you can customize your fit for all-day comfort.";
    itemInformation.lineBreakMode = NSLineBreakByWordWrapping;
    itemInformation.numberOfLines = 0;
    
    // INFO title
    DefaultLabel *labelInfoDescription = [DefaultLabel initWithMediumSystemFontSize:17 color:[UIColor primaryColor]];
    [informationContainer addSubview:labelInfoDescription];
    [labelInfoDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(informationContainer);
        make.top.equalTo(itemInformation.mas_bottom).offset(24);
    }];
    labelInfoDescription.text = @"INFO";
    
    // Description under INFO title
    DefaultLabel *labelInfoContent = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryColor]];
    [informationContainer addSubview:labelInfoContent];
    [labelInfoContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(informationContainer);
        make.top.equalTo(labelInfoDescription.mas_bottom).offset(5);
    }];
    labelInfoContent.text = @"- Fine-tuned acoustics for clarity, breadth and balance\n- Streamlined design for a custom-fit\n- Durable and foldable so you can take them on-the-go\n- Take calls and control music with\nRemoteTalk cable\n- What's in the box: Beats Solo2 on-ear headphone, RemoteTalk cable, carrying case";
    labelInfoContent.lineBreakMode = NSLineBreakByWordWrapping;
    labelInfoContent.numberOfLines = 0;
    
    // Shipping information title
    DefaultLabel *labelShipTitle = [DefaultLabel initWithMediumSystemFontSize:17 color:[UIColor primaryColor]];
    [informationContainer addSubview:labelShipTitle];
    [labelShipTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(informationContainer);
        make.top.equalTo(labelInfoContent.mas_bottom).offset(24);
    }];
    labelShipTitle.text = @"SHIPPING INFO";
    
    // Description under Shipping information title
    DefaultLabel *labelShipContent = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryColor]];
    [informationContainer addSubview:labelShipContent];
    [labelShipContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(informationContainer);
        make.top.equalTo(labelShipTitle.mas_bottom).offset(5);
        make.bottom.equalTo(self.scrollView).offset(-24);
    }];
    labelShipContent.text = @"Free shipping in EU. Rest of the world have individual shipping fees.\n\nShare this product button: FB, Twitter, email. ?";
    labelShipContent.lineBreakMode = NSLineBreakByWordWrapping;
    labelShipContent.numberOfLines = 0;
}

#pragma mark - Button actions
- (void)closeDetail {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onInformation {
    NSLog(@"Information button pressed");
}

- (void)onPurchase {
    RewardPurchaseViewController *purchaseVC = [[RewardPurchaseViewController alloc] initWithShopItem:self.shopItem];
    [self.navigationController pushViewController:purchaseVC animated:YES];
}

#pragma mark - Scrollview Delegate and required module.

-(int)getCurrentDisplayedSlide{
    //sum through all the views until you get to a position that matches the offset then that's what page youre on (each view can be a different width)
    int page = 0;
    int currentXPosition = 0;
    while (currentXPosition <= self.imageSlider.contentOffset.x && currentXPosition < self.imageSlider.contentSize.width){
        currentXPosition += [Utils screenWidth];
        
        if (currentXPosition <= self.imageSlider.contentOffset.x){
            page++;
        }
    }
    
    return page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.images.count == 0){
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = [self getCurrentDisplayedSlide];
}


@end
