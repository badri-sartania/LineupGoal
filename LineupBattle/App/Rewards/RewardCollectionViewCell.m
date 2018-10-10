//
//  RewardCollectionViewCell.m
//  GoalFury
//
//  Created by Alexandru on 4/11/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import "RewardCollectionViewCell.h"
#import "UIColor+LineupBattle.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "DefaultImageView.h"
#import "DefaultLabel.h"

@implementation RewardCollectionViewCell

-(id)initWithFrame:(CGRect)frame shopItem:(ShopItem *)item {
    self = [super initWithFrame:frame];
    if (self) {
        self.shopItem = item;
    }
    return self;
}

-(void)setupCellWithShopItem:(ShopItem *)item {
    self.shopItem = item;
    [self setupCell];
}

-(void)setupCell {
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    containerView.layer.cornerRadius = 4;
    containerView.layer.borderColor = [UIColor highlightColor].CGColor;
    containerView.layer.borderWidth = 1.0f;
    containerView.layer.masksToBounds = NO;
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    containerView.layer.shadowRadius = 6.0;
    containerView.layer.shadowOpacity = 0.11;
    
    // Show Reward image
    UIView *imageContainer = [[UIView alloc] init];
    [containerView addSubview:imageContainer];
    [imageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.height.equalTo(@140);
    }];
    
    DefaultImageView *imageReward = [[DefaultImageView alloc] init];
    [imageReward loadImageWithUrlString:self.shopItem.image placeholder:@"rewardItemPlaceholder"];
    [imageContainer addSubview:imageReward];
    [imageReward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(imageContainer);
        make.top.equalTo(imageContainer).offset(5);
        make.bottom.equalTo(imageContainer).offset(-5);
    }];
    
    // Show Reward item count
    UIView *countContainer = [[UIView alloc] init];
    [containerView addSubview:countContainer];
    [countContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(8);
        make.top.equalTo(containerView).offset(8);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    countContainer.backgroundColor = [UIColor championsLeagueColor];
    countContainer.layer.cornerRadius = 4;
    countContainer.layer.borderWidth = 0.0f;
    countContainer.layer.masksToBounds = true;
    
    DefaultLabel *labelCount = [DefaultLabel initWithBoldSystemFontSize:12 color:[UIColor whiteColor]];
    [countContainer addSubview:labelCount];
    [labelCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(countContainer);
    }];
    labelCount.text = [NSString stringWithFormat:@"%@ left", self.shopItem.amount];
    
    // Show Reward item name
    DefaultLabel *labelName = [DefaultLabel initWithBoldSystemFontSize:12 color:[UIColor primaryTextColor]];
    [containerView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView);
        make.top.equalTo(imageContainer.mas_bottom).offset(10);
    }];
    labelName.text = [self.shopItem.name uppercaseString];
    
    // Show Reward item price
    DefaultLabel *labelPrice = [DefaultLabel initWithLightSystemFontSize:20 color:[UIColor secondaryTextColor]];
    [containerView addSubview:labelPrice];
    [labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView);
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
    
    // Show Bolts
    UIView *boltContainer = [[UIView alloc] init];
    [containerView addSubview:boltContainer];
    [boltContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelPrice.mas_bottom).offset(2);
        make.bottom.equalTo(containerView.mas_bottom).offset(-10);
        make.left.equalTo(containerView).offset(10);
        make.right.equalTo(containerView).offset(-10);
    }];
    
    
    int boltIndex = 0;
    for (NSDictionary *boltDict in self.shopItem.boltPrice) {
        UIView *boltView = [[UIView alloc] init];
        [boltContainer addSubview:boltView];
        [boltView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(boltContainer).offset(34 * boltIndex + 8);
            make.left.right.equalTo(boltContainer);
            make.height.equalTo(@26);
        }];
        boltView.backgroundColor = [UIColor lightBackgroundColor];
        boltView.layer.cornerRadius = 4;
        boltView.layer.borderWidth = 0.0f;
        boltView.layer.masksToBounds = true;
        
        DefaultImageView *imgBolt = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"ic_bolt"]];
        [boltView addSubview:imgBolt];
        [imgBolt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boltView).offset(6);
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
        
        UIView *discountContainer = [[UIView alloc] init];
        [boltView addSubview:discountContainer];
        [discountContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(boltView).offset(-6);
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
        
        boltIndex++;
    }
    
}

@end
