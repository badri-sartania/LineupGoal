//
//  LeagueCellView.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 03/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import "LeagueCellView.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"

@interface LeagueCellView ()
@property (nonatomic, strong) UIView *standBar;
@property (nonatomic, strong) DefaultLabel *position;
@property (nonatomic, strong) DefaultLabel *name;
@property (nonatomic, strong) DefaultLabel *mp;
@property (nonatomic, strong) DefaultLabel *diff;
@property (nonatomic, strong) DefaultLabel *pts;
@end

@implementation LeagueCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        [self defineLayout];
    }
    return self;
}

- (void)setData:(Team *)team color:(NSString *)color position:(NSInteger)position {
    
    if (position % 2 == 0) {
        [self setBackgroundColor:[UIColor lightBackgroundColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    self.color                  = color;
    self.position.text          = [team.position stringValue];
    self.name.text              = team.name;
    self.mp.text                = [team.mp stringValue];
    self.pts.text               = [team.points stringValue];

    NSInteger diffValue = [team.goals[@"own"] integerValue] - [team.goals[@"against"] integerValue];

    self.diff.text              = diffValue > 0 ? [NSString stringWithFormat:@"+%li", (long)diffValue] : [NSString stringWithFormat:@"%li", (long)diffValue];

    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 3.5f, self.frame.size.height+2);
    leftBorder.backgroundColor = self.color ? [UIColor hx_colorWithHexString:self.color].CGColor : [UIColor whiteColor].CGColor;
    [self.layer addSublayer:leftBorder];
}

- (void)addSubviews {
    [self addSubview:self.standBar];
    [self addSubview:self.position];
    [self addSubview:self.name];
    [self addSubview:self.mp];
    [self addSubview:self.diff];
    [self addSubview:self.pts];
}

- (void)defineLayout {
    UIView *superview = self.contentView;

    [@[self.standBar, self.position, self.name, self.mp, self.diff, self.pts] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
    }];
    
    [self.standBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview);
        make.width.equalTo(@5);
        make.height.equalTo(superview);
    }];

    [self.position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.width.equalTo(@25);
    }];

    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@44);
    }];

    // Stats

    [self.pts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-20);
        make.width.equalTo(@40);
    }];

    [self.diff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pts.mas_left);
        make.width.equalTo(@35);
    }];

    [self.mp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.diff.mas_left);
        make.width.equalTo(@35);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Views
- (UIView *)standBar {
    if (!_standBar) {
        _standBar = UIView.new;
    }
    
    return _standBar;
}

- (DefaultLabel *)position {
    if (!_position) {
        _position = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryColor]];
        _position.textAlignment = NSTextAlignmentCenter;
    }

    return _position;
}

- (DefaultLabel *)name {
    if (!_name) {
        _name = [DefaultLabel initWithMediumSystemFontSize:15 color:[UIColor primaryColor]];
    }

    return _name;
}

- (DefaultLabel *)mp {
    if (!_mp) {
        _mp = [DefaultLabel initWithSystemFontSize:15 color:[UIColor secondaryTextColor]];
        _mp.textAlignment = NSTextAlignmentLeft;
    }

    return _mp;
}

- (DefaultLabel *)diff {
    if (!_diff) {
        _diff = [DefaultLabel initWithSystemFontSize:15 color:[UIColor secondaryTextColor]];
        _diff.textAlignment = NSTextAlignmentCenter;
    }

    return _diff;
}

- (DefaultLabel *)pts {
    if (!_pts) {
        _pts = [DefaultLabel initWithMediumSystemFontSize:15 color:[UIColor primaryColor]];
        _pts.textAlignment = NSTextAlignmentRight;
    }

    return _pts;
}


@end
