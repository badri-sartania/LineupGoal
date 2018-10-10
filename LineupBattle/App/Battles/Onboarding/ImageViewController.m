//
// Created by Anders Borre Hansen on 13/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "ImageViewController.h"
#import "DefaultImageView.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"
#import "Utils.h"


@interface ImageViewController ()
@property(nonatomic, strong) UIImage *image;
@end


@implementation ImageViewController

- (id)initWithImage:(UIImage *)image {
    self = [super init];

    if (self) {
        self.image = image;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *imageContainer = [[UIView alloc] init];
    [self.view addSubview:imageContainer];
    [imageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@([Utils screenWidth] * 0.8));
        make.height.equalTo(@([Utils screenHeight] * 0.5));
    }];
    
    DefaultImageView *image = [[DefaultImageView alloc] initWithImage:self.image];
    [imageContainer addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageContainer);
        make.centerY.equalTo(imageContainer);
    }];

    self.headlineLabel = [DefaultLabel initWithMediumSystemFontSize:32 color:[UIColor primaryColor]];
    self.headlineLabel.adjustsFontSizeToFitWidth = YES;
    self.headlineLabel.textAlignment = NSTextAlignmentCenter;

    self.sublineLabel = [DefaultLabel init];
    self.sublineLabel.font = [UIFont fontWithName:@"NanumPen" size:30.0f];
    self.sublineLabel.textColor = [UIColor championsLeagueColor];
    self.sublineLabel.adjustsFontSizeToFitWidth = YES;
    self.sublineLabel.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:self.headlineLabel];
    [self.view addSubview:self.sublineLabel];

    [@[self.headlineLabel, self.sublineLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    }];

    [self.headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageContainer.mas_bottom).offset(10);
        make.width.equalTo(@([Utils screenWidth]*0.85f));
    }];

    [self.sublineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headlineLabel.mas_bottom).offset(5);
    }];
}

@end
