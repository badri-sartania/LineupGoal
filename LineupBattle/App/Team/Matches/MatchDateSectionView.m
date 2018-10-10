//
// Created by Anders Hansen on 26/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "MatchDateSectionView.h"
#import "DefaultLabel.h"


@interface MatchDateSectionView ()
    @property (nonatomic, strong) DefaultLabel *date;
    @property (nonatomic, strong) DefaultLabel *league;
@end

@implementation MatchDateSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.date];
        [self addSubview:self.league];

        [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self);
           make.left.equalTo(@10);
        }];

        [self.league mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(@(-10));
        }];
    }
    return self;
}

- (void)setSectionDataWithTitle:(NSString *)title league:(NSString *)league {
    self.date.text = title;
    self.league.text = league;
}

- (DefaultLabel *)date {
    if (!_date) {
        _date = [[DefaultLabel alloc] init];
        _date.font = [UIFont systemFontOfSize:14];
    }

    return _date;
}

- (DefaultLabel *)league {
    if (!_league) {
        _league = [[DefaultLabel alloc] init];
        _league.font = [UIFont systemFontOfSize:14];
    }

    return _league;
}


@end