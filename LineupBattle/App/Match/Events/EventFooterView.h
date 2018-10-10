//
// Created by Anders Hansen on 15/06/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultLabel.h"
#import "DefaultImageView.h"


@interface EventFooterView : UIView
@property(nonatomic, strong) DefaultLabel *titleLabel;
@property(nonatomic, strong) DefaultImageView *imageView;
@end