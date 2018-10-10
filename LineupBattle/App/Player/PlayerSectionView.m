//
// Created by Anders Hansen on 14/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "PlayerSectionView.h"


@implementation PlayerSectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self addSubview:self.name];
        [self addSubview:self.rightLabel];
        [self setUnderlineToNormalPosition];
        [self setFontWeightForTextToBeLight];

        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(16);
        }];

        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self);
           make.right.equalTo(self).offset(-10);
        }];
    }

    return self;
}

- (void)setSectionTitle:(NSString *)title {
    self.name.text = title;
}

- (void)setSectionLastText:(NSString *)title {
    self.rightLabel.text = title;
}

- (void)setFontWeightForTextToBeLight {
    self.name.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    self.rightLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
}

- (DefaultLabel *)name {
    if (!_name) {
        _name = [[DefaultLabel alloc] init];
        _name.font = [UIFont systemFontOfSize:14];
    }

    return _name;
}

- (DefaultLabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[DefaultLabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:14];
    }

    return _rightLabel;
}

- (void)setUnderlineToNormalPosition {
    self.bottomBorder.frame = CGRectMake(16, 30.0f, self.frame.size.width, 0.5f);
}


@end
