//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoinDescriptionView : UIView
- (instancetype)initWithDescription:(NSString *)description coins:(NSInteger)coins;

- (void)setCoins:(NSInteger)coins;
@end