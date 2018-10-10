//
// Created by Anders Hansen on 14/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "DefaultTableSectionView.h"
#import "DefaultLabel.h"

@interface PlayerSectionView : DefaultTableSectionView
@property (nonatomic, strong) DefaultLabel *name;
@property (nonatomic, strong) DefaultLabel *rightLabel;
@property (nonatomic, strong) UIImageView *image;

- (void)setSectionTitle:(NSString *)title;
- (void)setSectionLastText:(NSString *)title;
@end