//
// Created by Anders Hansen on 19/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultImageView.h"
#import "DefaultLabel.h"
#import "DefaultViewCell.h"

@interface SelectViewCell : DefaultViewCell
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) DefaultLabel *name;
@property (nonatomic, strong) DefaultImageView *logo;

- (void)setLayout;

- (BOOL)toggleSelection;
@end