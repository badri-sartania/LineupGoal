//
// Created by Anders Borre Hansen on 04/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "CaptainButton.h"
#import "ImageWithCaptainBadgeView.h"
#import "UIColor+LineupBattle.h"


@implementation CaptainButton {
    UIButton *_button;
    ImageWithCaptainBadgeView *_imageView;
    DefaultLabel *_titleLabel;
    DefaultLabel *_subtitleLabel;
    DefaultImageView *_rightArrowImageView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *rightArrowImage = [UIImage imageNamed:@"rightArrow"];

        _imageView = [[ImageWithCaptainBadgeView alloc] init];
        _imageView.imageView.image = [UIImage imageNamed:@"ic_captain"];
        [_imageView showBadge:NO];
        [_imageView.imageView circleWithBorder:[UIColor whiteColor] diameter:36.f borderWidth:2.f];
        _titleLabel = [DefaultLabel initWithText:@"Select a team captain"];
        [_titleLabel boldSystemFontSize:16 color:[UIColor actionColor]];
        _subtitleLabel = [DefaultLabel initWithText:@"Captain gets 2x points"];
        _subtitleLabel.font = [UIFont systemFontOfSize:13];
        _rightArrowImageView = [[DefaultImageView alloc] initWithImage:rightArrowImage highlightedImage:rightArrowImage];

        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_subtitleLabel];
        [self addSubview:_rightArrowImageView];

        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.equalTo(@38);
            make.left.equalTo(@20);
        }];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).offset(15);
            make.centerY.equalTo(self).offset(-10);
        }];

        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).offset(15);
            make.centerY.equalTo(self).offset(10);
        }];

        [_rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
            make.width.equalTo(@12);
            make.height.equalTo(@20);
        }];

        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];

        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self);
        }];
    }

    return self;
}

- (void)buttonAction {
    [self.delegate captainButtonAction:self];
}

- (void)setPlayer:(Player *)player {
    if (player.objectId) {
        _titleLabel.text = player.name;

        [_imageView.imageView loadImageWithUrlString:[player photoImageUrlString:@"34"] placeholder:@"ic_captain" success:^{
            [_imageView showBadge:YES];
        } failure:^ {
            [_imageView showBadge:NO];
        }];
    } else {
        [_imageView showBadge:NO];
        _titleLabel.text = @"Select a team captain";
    }
}

@end
