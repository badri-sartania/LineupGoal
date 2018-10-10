//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "LeaderboardTableViewCell.h"
#import "DefaultImageView.h"
#import "FlagView.h"
#import "CoinView.h"
#import "ImageViewWithBadge.h"
#import "Identification.h"
#import "UIColor+LineupBattle.h"

@implementation LeaderboardTableViewCell {
    DefaultLabel *_profileNameLabel;
    PointsView *_pointsView;
    DefaultLabel *_standingLabel;
    ImageViewWithBadge *_profileImageView;
    FlagView *_flagView;
    DefaultLabel *_labelBolt;
    DefaultImageView *_imageBolt;
};

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _standingLabel = [DefaultLabel initWithSystemFontSize:14 color:[UIColor secondaryTextColor]];
        _profileImageView = [[ImageViewWithBadge alloc] initWithBadgeScale:0.0f];
//        _profileImageView.badgeView.textLabel.font = [UIFont systemFontOfSize:12];
        [_profileImageView.imageView circleWithBorder:[UIColor whiteColor] diameter:44.f borderWidth:0.f];
        _profileNameLabel = [DefaultLabel init];
        _flagView = [[FlagView alloc] initWithCountryCode:nil countryCodeFormat:CountryCodeFormatISO31661Alpha2];
        _flagView.countryLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        [_flagView.countryLabel setTextColor:[UIColor secondaryTextColor]];
        _pointsView = [[PointsView alloc] initWithPoints:0];
        _labelBolt = [DefaultLabel initWithSystemFontSize:14 color:[UIColor primaryTextColor]];
        _imageBolt = [[DefaultImageView alloc] init];
        [_imageBolt setImage:[UIImage imageNamed:@"ic_bolt"]];

        [self addSubview:_standingLabel];
        [self addSubview:_profileNameLabel];
        [self addSubview:_profileImageView];
        [self addSubview:_flagView];
        [self addSubview:_pointsView];
        [self addSubview:_labelBolt];
        [self addSubview:_imageBolt];

        // Center Y Views
        [_standingLabel setTextAlignment:NSTextAlignmentCenter];
        [_standingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3);
            make.centerY.equalTo(self);
            make.width.equalTo(@40);
        }];

        [_profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_standingLabel.mas_right).offset(3);
            make.width.height.equalTo(@44);
            make.centerY.equalTo(self);
        }];
        
        [_profileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_profileImageView.mas_right).offset(10);
            make.top.equalTo(_profileImageView.mas_top).offset(2);
        }];

        // Bottom
        [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_profileImageView.mas_right).offset(10);
            make.bottom.equalTo(_profileImageView.mas_bottom).offset(-2);
            make.width.equalTo(@200);
            make.height.equalTo(@16);
        }];

        // Right
        [_pointsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_profileNameLabel);
            make.right.equalTo(self).offset(-10);
        }];
        
        [_labelBolt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.bottom.equalTo(_flagView);
        }];
        
        [_imageBolt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_labelBolt);
            make.right.equalTo(_labelBolt.mas_left).offset(-4);
            make.width.equalTo(@9);
        }];
    }

    return self;
}

- (void)setUser:(User *)user position:(NSInteger)position type:(NSString *)type{
    NSString *userLevel = user.level ? [user.level stringValue] : @"1";
//    [_profileImageView setBadgeText:userLevel];
    [_profileImageView.imageView loadImageWithUrlString:[user profileImagePath:34] placeholder:@"playerPlaceholder"];

    _profileNameLabel.text = user.name ?: @"Anonymous user";
    [_pointsView setPoints:[type isEqualToString:@"xi"] ? [user.ultimateXI_points integerValue] : [user.points integerValue]];
    [_flagView setISO2CountryCode:user.country];
    _standingLabel.text = [NSString stringWithFormat:@"%@", user.pos ?: @""];

    _standingLabel.font =  [user.objectId isEqualToString:[Identification userId]] ? [UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
    _profileNameLabel.font =  [user.objectId isEqualToString:[Identification userId]] ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16];
    if (user.coins != nil) _labelBolt.text = [user.coins stringValue];
    else _labelBolt.text = @"0";
    
    if (position % 2 == 0) {
        [self setBackgroundColor:[UIColor lightBackgroundColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}


@end
