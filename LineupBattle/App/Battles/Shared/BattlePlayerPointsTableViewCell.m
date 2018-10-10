//
// Created by Anders Borre Hansen on 03/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "BattlePlayerPointsTableViewCell.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "PointsView.h"
#import "ImageUrlGenerator.h"
#import "ImageViewWithBadge.h"
#import "FlagImage.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"


@implementation BattlePlayerPointsTableViewCell {
    ImageViewWithBadge *_pointsPlayerImageView;
    UILabel *_pointsPlayerLabel;
    UILabel *_playerClubLabel;
    PointsView *_pointsView;
    UILabel *_standingLabel;
    DefaultImageView *_flagImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _standingLabel = [[UILabel alloc] init];
        _standingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 14];
        _standingLabel.textColor = [UIColor hx_colorWithHexString:@"95A5A6"];
        _standingLabel.textAlignment = NSTextAlignmentCenter;
        _pointsPlayerImageView = [[ImageViewWithBadge alloc] initWithBadgeScale:0.8f];
        _pointsPlayerImageView.imageView.image = [UIImage imageNamed:@"playerPlaceholder"];
        [_pointsPlayerImageView.imageView circleWithBorder:[UIColor whiteColor] diameter:44 borderWidth:0];
        _flagImageView = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"UNK"]];
        [_flagImageView setContentMode:UIViewContentModeScaleAspectFit];
        _pointsPlayerLabel = [[UILabel alloc] init];
        _pointsPlayerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 16];
        _pointsPlayerLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];
        
        _playerClubLabel = [[UILabel alloc] init];
        _playerClubLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 14];
        _playerClubLabel.textColor = [UIColor hx_colorWithHexString:@"95A5A6"];
        _pointsView = [[PointsView alloc] initWithPoints:22];
        _pointsView.pointsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size: 16];
        _pointsView.pointsLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];

        [self addSubview:_standingLabel];
        [self addSubview:_pointsPlayerImageView];
        [self addSubview:_flagImageView];
        [self addSubview:_pointsPlayerLabel];
        [self addSubview:_playerClubLabel];
        [self addSubview:_pointsView];

        NSInteger centerOffset = 9;
        NSInteger edgeOffset = 10;

        // Center Y Views
        [_standingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(1);
            make.width.equalTo(@(20));
            make.centerY.equalTo(self);
        }];

        [_pointsPlayerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_standingLabel.mas_right).offset(1);
            make.size.equalTo(@44);
        }];

        // Top
        [@[_flagImageView, _pointsPlayerLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-centerOffset);
        }];
        
        [_pointsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];

        // Left
        [@[_flagImageView, _playerClubLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_pointsPlayerImageView.mas_right).offset(edgeOffset);
        }];

        // Right
        [@[_pointsView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-edgeOffset);
        }];

        // Bottom
        [@[_playerClubLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(centerOffset);
        }];

        // Special
        [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.equalTo(@22);
        }];

        [_pointsPlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_flagImageView.mas_right).offset(5);
        }];
    }

    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setPlayer:(Player *)player placement:(NSInteger)placement {
    if (placement % 2 == 1) {
        self.contentView.backgroundColor = [UIColor lightBackgroundColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    [_pointsView setPoints:player.points];
    _pointsPlayerLabel.text = player.name;
    _playerClubLabel.text = player.team.name;
    _standingLabel.text = [@(placement) stringValue];
    _flagImageView.image = [FlagImage flagWithCode:player.nationality countryCodeFormat:CountryCodeFormatFifa];
    
    [_pointsPlayerImageView setPosBadgeText:[player.position uppercaseString]
                                    bgColor:[UIColor hx_colorWithHexString:@"2C3E50"]
                           badgeBorderWidth:2.0f
                           badgeBorderColor:[UIColor whiteColor]
                                  badgeSize:25.f
                                   textSize:8.f];

    NSString *imageUrlString = [ImageUrlGenerator playerPhotoImageUrlStringBySize:@"34" photoToken:[player.photoToken stringValue] objectId:player.objectId];
    [_pointsPlayerImageView.imageView loadImageWithUrlString:imageUrlString placeholder:@"playerPlaceholder"];
}

@end
