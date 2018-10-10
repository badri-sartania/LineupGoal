//
// Created by Anders Hansen on 25/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "TopTeamView.h"
#import "DefaultImageView.h"
#import "DefaultLabel.h"
#import "Utils.h"
#import "FlagView.h"
#import "HexColors.h"


@interface TopTeamView ()
@property (nonatomic, strong) DefaultImageView *logo;
@property (nonatomic, strong) FlagView *flagView;
@property (nonatomic, strong) DefaultLabel *teamName;
@property (nonatomic, strong) CALayer *bottomBorder;
@end

@implementation TopTeamView

- (id)init {
    self = [super init];
    if (self) {
        self.flagView = [[FlagView alloc] initWithCountryCode:nil countryCodeFormat:CountryCodeFormatFifa];
        self.flagView.countryLabel.font = [UIFont systemFontOfSize:12];

        [self addSubview:self.logo];
        [self addSubview:self.teamName];
        [self addSubview:self.flagView];

        [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(15);
            make.size.equalTo(@60);
        }];

        [self.teamName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.logo.mas_bottom).offset(7);
        }];

        [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.top.equalTo(self.teamName.mas_bottom).offset(2);
            make.centerX.equalTo(self);
        }];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.layer addSublayer:self.bottomBorder];
}

- (void)updateData:(Team *)team {
    [self.logo loadImageWithUrlString:team.logoUrl placeholder:@"clubPlaceholder"];
    self.teamName.text = team.name;
    [self.flagView setFifaCountryCode:team.country];
}

#pragma mark - View
- (DefaultImageView *)logo {
   if (!_logo) {
       _logo = [[DefaultImageView alloc] init];
       _logo.image = [UIImage imageNamed:@"clubPlaceholder"];
   }

   return _logo;
}

- (DefaultLabel *)teamName {
   if (!_teamName) {
       _teamName = [DefaultLabel init];
       _teamName.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
   }

   return _teamName;
}

- (CALayer *)bottomBorder {
    if (!_bottomBorder) {
        _bottomBorder = [CALayer layer];
        _bottomBorder.frame = CGRectMake(10, self.bounds.size.height-1, self.bounds.size.width-20, 0.5);
        _bottomBorder.backgroundColor = [UIColor hx_colorWithHexString:@"#717171"].CGColor;
    }

    return _bottomBorder;
}

@end