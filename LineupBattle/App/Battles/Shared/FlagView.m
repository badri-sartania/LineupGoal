//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "FlagView.h"
#import "DefaultImageView.h"
#import "FlagImage.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"

@implementation FlagView {
   DefaultImageView *_flagImageView;
}

- (instancetype)initWithCountryCode:(NSString *)countryCode countryCodeFormat:(CountryCodeFormat)countryFormat {
    self = [super init];
    if (self) {
        _flagImageView = [[DefaultImageView alloc] init];
        _countryLabel = [[UILabel alloc] init];
        _countryLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _countryLabel.textColor = [UIColor primaryColor];
        _countryLabel.alpha = 0.6f;

        [self setISO2CountryCode:countryCode];

        [self addSubview:_flagImageView];
        [self addSubview:_countryLabel];

        [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self);
            make.size.equalTo(self.mas_height);
        }];

        [_countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_flagImageView.mas_right).offset(5);
        }];

        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_flagImageView);
            make.right.equalTo(_countryLabel);
        }];
    }

    return self;
}

- (void)setISO2CountryCode:(NSString *)countryCode {
    _flagImageView.image = [FlagImage flagWithCode:countryCode countryCodeFormat:CountryCodeFormatISO31661Alpha2];
    NSString *countryName = [CountryCodeHelper isoAlpha2CodeToName:countryCode];
    if ([countryName isEqualToString:@""]) {
        _countryLabel.text = @"Country";
    } else {
        _countryLabel.text = countryName;
    }
}

- (void)setFifaCountryCode:(NSString *)countryCode {
    _flagImageView.image = [FlagImage flagWithCode:countryCode countryCodeFormat:CountryCodeFormatFifa];
    NSString *countryName = [CountryCodeHelper fifaCodeToName:countryCode];
    if ([countryName isEqualToString:@""]) {
        _countryLabel.text = @"Country";
    } else {
        _countryLabel.text = countryName;
    }
}

@end
