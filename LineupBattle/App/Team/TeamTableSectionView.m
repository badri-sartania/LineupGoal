//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "TeamTableSectionView.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"

@interface TeamTableSectionView ()
@property (nonatomic, strong) UILabel *headline;
@property (nonatomic, strong) UILabel *mp;
@property (nonatomic, strong) UILabel *goals;
@property (nonatomic, strong) UILabel *a;
@property (nonatomic, strong) UILabel *yr;
@end

@implementation TeamTableSectionView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.headline = [self sectionLabel];
        self.headline.text = @"PLAYERS";
        
        self.mp = [self sectionLabel];
        self.mp.text = @"MP";

        self.goals = [self sectionLabel];
        self.goals.text = @"G";

        self.a = [self sectionLabel];
        self.a.text = @"A";

        self.yr = [self sectionLabel];
        self.yr.text = @"Y/R";

        [self addSubview:self.headline];
        [self addSubview:self.mp];
        [self addSubview:self.goals];
        [self addSubview:self.a];
        [self addSubview:self.yr];

        [self defineLayout];
    }
    
    return self;
}

- (UILabel *)sectionLabel {
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    sectionLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];

    return sectionLabel;
}

- (void)defineLayout {
    [@[self.headline, self.mp, self.goals, self.a, self.yr] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];

    [self.headline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
    }];

    [self.mp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-106);
    }];

    [self.goals mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-80);
    }];

    [self.a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-50);
    }];

    [self.yr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
    }];
}

- (void)setHeadlineText:(NSString *)headline {
    self.headline.text = headline;
}

@end
