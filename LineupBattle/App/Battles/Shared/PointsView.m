//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "PointsView.h"
#import "HexColors.h"


@implementation PointsView

- (instancetype)init {
    self = [super init];

    if (self) {
//        _pointsLabel = [DefaultLabel initWithSystemFontSize:16 weight:UIFontWeightMedium];
        _pointsLabel = [[UILabel alloc] init];
        _pointsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
        _pointsLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];
        
        _pointsDescriptionLabel = [[UILabel alloc] init];
        _pointsDescriptionLabel.text = @"p";
        _pointsDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
        _pointsDescriptionLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];
//        _pointsDescriptionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];

        [self addSubview:_pointsDescriptionLabel];
        [self addSubview:_pointsLabel];

        [_pointsDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self);
        }];

        [_pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_pointsDescriptionLabel.mas_left).offset(-1);
            make.centerY.equalTo(self);
        }];

        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_pointsDescriptionLabel);
            make.left.equalTo(_pointsLabel);
        }];
    }

    return self;
}

- (instancetype)initWithPoints:(NSInteger)points {
    self = [self init];
    
    if (self) {
        [self setPoints:points];
    }

    return self;
}

- (void)setPoints:(NSInteger)points {
    UIColor *labelColor = points < 0 ? [UIColor hx_colorWithHexString:@"EB0E30"] : [UIColor hx_colorWithHexString:@"2C3E50"];

    self.pointsLabel.textColor = labelColor;
    self.pointsLabel.text = [NSString localizedStringWithFormat:@"%@", @(points)];
    self.pointsDescriptionLabel.textColor = labelColor;
}

- (void)setLevelFormat:(NSInteger)currentPoints target:(NSInteger)targetPoints {
    NSString *currentString = [NSString localizedStringWithFormat:@"%@", @(currentPoints)];
    NSString *targetString = [NSString localizedStringWithFormat:@"%@", @(targetPoints)];

    self.pointsLabel.text = [NSString stringWithFormat:@"%@/%@", currentString, targetString];
}

- (void)setFontSize:(CGFloat)size {
//    self.pointsDescriptionLabel.font = [UIFont systemFontOfSize:size weight:UIFontWeightLight];
//    self.pointsLabel.font = [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

@end
