//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultLabel.h"

@interface PointsView : UIView
@property(nonatomic, strong) UILabel *pointsLabel;
@property(nonatomic, strong) UILabel *pointsDescriptionLabel;

- (instancetype)initWithPoints:(NSInteger)points;

- (void)setPoints:(NSInteger)points;
- (void)setFontSize:(CGFloat)size;
- (void)setLevelFormat:(NSInteger)currentPoints target:(NSInteger)targetPoints;
@end
