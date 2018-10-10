//
// Created by Anders Borre Hansen on 11/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "BattlesActiveViewCell.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"


@implementation BattlesActiveViewCell {
    DefaultLabel *_titleLabel;
    DefaultLabel *_stateLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _titleLabel = [DefaultLabel initWithBoldSystemFontSize:14 color:[UIColor actionColor]];
        _stateLabel = [DefaultLabel initWithBoldSystemFontSize:12];

        [self addSubview:_titleLabel];
        [self addSubview:_stateLabel];

        [@[_titleLabel, _stateLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
        }];

        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
        }];
    }

    return self;
}

- (void)setData:(Battle *)battle {
    _stateLabel.text = [battle stateString];
    _titleLabel.text = battle.template.name;
}

@end
