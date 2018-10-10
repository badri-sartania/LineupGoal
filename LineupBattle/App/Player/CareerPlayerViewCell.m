//
// Created by Anders Hansen on 24/04/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "CareerPlayerViewCell.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"


@interface CareerPlayerViewCell ()
@property (nonatomic, strong) DefaultImageView *flag;
@property (nonatomic, strong) DefaultLabel *teamName;
@property (nonatomic, strong) DefaultLabel *years;
@property (nonatomic, strong) DefaultLabel *mp;
@property (nonatomic, strong) DefaultLabel *goals;
@end

@implementation CareerPlayerViewCell

- (void)addSubviews {
    [self addSubview:self.flag];
    [self addSubview:self.teamName];
    [self addSubview:self.years];
    [self addSubview:self.mp];
    [self addSubview:self.goals];
}

- (void)defineLayout {
    self.userInteractionEnabled = NO;

    [@[self.flag, self.teamName, self.years, self.mp, self.goals] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];

    [self.flag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.size.equalTo(@16);
    }];

    [self.teamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flag.mas_right).offset(5);
    }];

    [self.years mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-11);
    }];
}

- (void)setData:(Team *)team {
    if (team.country) {
        self.flag.image = [UIImage imageNamed:team.country];
    }
    self.teamName.text = team.name;
    self.years.text = [team yearString];
}

- (DefaultImageView *)flag {
    if (!_flag) {
        _flag = [[DefaultImageView alloc] init];
    }

    return _flag;
}

- (DefaultLabel *)teamName {
    if (!_teamName) {
        _teamName = [[DefaultLabel alloc] init];
    }

    return _teamName;
}

- (DefaultLabel *)years {
    if (!_years) {
        _years = [[DefaultLabel alloc] init];
        _years.textAlignment = NSTextAlignmentRight;
    }

    return _years;
}

- (DefaultLabel *)mp {
    if (!_mp) {
        _mp = [[DefaultLabel alloc] init];
    }

    return _mp;
}

- (DefaultLabel *)goals {
    if (!_goals) {
        _goals = [[DefaultLabel alloc] init];
    }

    return _goals;
}

@end
