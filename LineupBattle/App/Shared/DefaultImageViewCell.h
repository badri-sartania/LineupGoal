//
// Created by Anders Borre Hansen on 08/10/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"


@interface DefaultImageViewCell : DefaultViewCell
@property(nonatomic, strong) DefaultImageView *defaultImage;
@property(nonatomic, strong) DefaultLabel *defaultLabel;
@end