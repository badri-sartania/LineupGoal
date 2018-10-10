//
// Created by Anders Borre Hansen on 02/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "TeamCollectionViewCell.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"


@interface TeamCollectionViewCell ()
@property (strong, nonatomic) DefaultLabel* day;
@property (strong, nonatomic) DefaultImageView* logoView;
@property (nonatomic, strong) DefaultLabel *countView;
@end

@implementation TeamCollectionViewCell

+ (CGFloat)height {
    static CGFloat height = 92.f;
    return height;
}

+ (CGFloat)width {
    static CGFloat width = 75.f;
    return width;
}

- (id)init {
    CGRect frame = CGRectMake(0.f, 0.f, [TeamCollectionViewCell width], [TeamCollectionViewCell height]);
    self = [super initWithFrame:frame];

    if (self) {
        self.logoView = [[DefaultImageView alloc] init];
        self.countView = [DefaultLabel initWithSystemFontSize:10 color:[UIColor darkGrayTextColor]];

        [self addSubview:self.day];
        [self addSubview:self.logoView];
        [self addSubview:self.countView];

        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-10);
            make.size.equalTo(@45);
        }];

        [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(2);
            make.right.equalTo(self).offset(-4);
        }];

        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)addHomeTeamStyle {
    [self addV];
    [self addBorderWithRect:CGRectMake(75.25f, 0.f, 0.5f, 38.f)];
    [self addBorderWithRect:CGRectMake(75.25f, 54.f, 0.5f, 38.f)];
    [self.layer setNeedsLayout];
}

- (void)addAwayTeamStyle {
    [self addS];
    [self addBorderWithRect:CGRectMake(75.25f, 1.f, 0.5f, self.frame.size.height)];
    [self.layer setNeedsLayout];
}

- (void)addBorderWithRect:(CGRect)rect {
    CALayer *border = [CALayer layer];
    border.frame = rect;
    border.backgroundColor = [UIColor hx_colorWithHexString:@"#96a5a6"].CGColor;
    [self.layer addSublayer:border];
}

- (void)setTeam:(Team *)team {
    _team = team;
    [self.logoView loadImageWithUrlString:team.logoThumbUrl placeholder:@"clubPlaceholderThumb"];
    self.day.text = [team.shortName ?: team.name uppercaseString];
}

- (void)setCount:(NSInteger)count {
    self.countView.text = count > 0 ? [@(count) stringValue] : @"";
}

- (void)addV {
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"V"];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    label.textColor = [UIColor hx_colorWithHexString:@"95a5a6"];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

- (void)addS {
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"S"];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    label.textColor = [UIColor hx_colorWithHexString:@"95a5a6"];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Views
- (DefaultLabel *)day {
    if (!_day) {
        _day = [[DefaultLabel alloc] init];
        _day.frame = CGRectMake(0.f, 65.f, self.bounds.size.width, 20.f);
        _day.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
        _day.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];
        _day.textAlignment = NSTextAlignmentCenter;
    }

    return _day;
}
@end
