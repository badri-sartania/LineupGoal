//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "CountryCodeHelper.h"
#import "DefaultLabel.h"


@interface FlagView : UIView
@property (nonatomic, strong) UILabel *countryLabel;

- (instancetype)initWithCountryCode:(NSString *)countryCode countryCodeFormat:(CountryCodeFormat)countryFormat;
- (void)setISO2CountryCode:(NSString *)countryCode;
- (void)setFifaCountryCode:(NSString *)countryCode;
@end
