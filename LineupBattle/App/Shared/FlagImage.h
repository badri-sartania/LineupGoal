//
// Created by Anders Borre Hansen on 27/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountryCodeHelper.h"


@interface FlagImage : UIImage
+ (UIImage *)flagWithCode:(NSString *)code countryCodeFormat:(CountryCodeFormat)countryCodeFormat;
@end
