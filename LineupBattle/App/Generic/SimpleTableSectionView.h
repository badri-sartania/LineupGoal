//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultTableSectionView.h"
#import "CountryCodeHelper.h"


@interface SimpleTableSectionView : UIView
@property (nonatomic, strong) UIImageView *image;

- (void)setSectionDataWithTitle:(NSString *)title imageName:(NSString *)imageName;

- (void)setSectionDataWithTitle:(NSString *)title flagCode:(NSString *)flagCode countryCodeFormat:(CountryCodeFormat)format;

- (void)setFontWeightForTextToBeLight;
- (void)setUnderlineToNormalPosition;
@end
