//
// Created by Anders Borre Hansen on 28/10/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "DefaultLabel.h"

@interface InfoTableViewCell : DefaultViewCell
@property(nonatomic, strong) DefaultLabel *descLabel;
@property(nonatomic, strong) DefaultLabel *dataLabel;
@end