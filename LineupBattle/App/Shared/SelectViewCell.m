//
// Created by Anders Hansen on 19/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "SelectViewCell.h"

@implementation SelectViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;

        self.name = [DefaultLabel initWithSystemFontSize:16 weight:UIFontWeightLight];
        self.logo = [[DefaultImageView alloc] init];
        [self.logo circleWithBorder:[UIColor whiteColor] diameter:38.f borderWidth:0];

        [self addSubview:self.logo];
        [self addSubview:self.name];
        [self addSubview:self.selectButton];

        [self setLayout];
    }

    return self;
}

- (void)setLayout {
    self.showsReorderControl = NO;

    [self.logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.size.equalTo(@38);
    }];

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.logo.mas_right).offset(10);
    }];

    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.userInteractionEnabled = NO;
        [_selectButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateHighlighted];
    }

    return _selectButton;
}

- (BOOL)toggleSelection {
    BOOL newHighlightState = !self.selectButton.highlighted;
    [self.selectButton setHighlighted:newHighlightState];
    return newHighlightState;
}

@end
