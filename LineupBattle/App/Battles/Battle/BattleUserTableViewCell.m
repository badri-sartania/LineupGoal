//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "BattleUserTableViewCell.h"
#import "FlagView.h"
#import "PointsView.h"
#import "CoinView.h"
#import "ProfileImageWithBadgeView.h"
#import "NSNumber+OrdinalSuffix.h"
#import "Identification.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"


@implementation BattleUserTableViewCell {
    UILabel *_profileNameLabel;
    UILabel *_standingLabel;
    ImageViewWithBadge *_profileImageView;
    FlagView *_flagView;
    PointsView *_pointsView;
    CoinView *_coinView;
    UIImageView *_boltImage;
    UILabel *_boltLabel;
//    DefaultLabel *_coinBeforeLabel;
};

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _standingLabel = [[UILabel alloc] init];
        _standingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
        _standingLabel.textColor = [UIColor hx_colorWithHexString:@"95A5A6"];
        _profileImageView = [[ImageViewWithBadge alloc] initWithBadgeScale:1.0f];
        [_profileImageView.badgeView setHidden:YES];
        [_profileImageView.imageView circleWithBorder:[UIColor whiteColor] diameter:45.f];
        _profileNameLabel = [[UILabel alloc] init];
        _profileNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
        _profileNameLabel.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];
        
        _flagView = [[FlagView alloc] initWithCountryCode:nil countryCodeFormat:CountryCodeFormatISO31661Alpha2];
        
        _pointsView = [[PointsView alloc] initWithPoints:0];
        _coinView = [[CoinView alloc] initWithCoins:0 direction:CoinDirectionLeft];
//        _coinBeforeLabel = [DefaultLabel init];

        [self addSubview:_standingLabel];
        [self addSubview:_profileNameLabel];
        [self addSubview:_profileImageView];
        [self addSubview:_flagView];
        [self addSubview:_pointsView];
        [self addSubview:_coinView];
//        [self addSubview:_coinBeforeLabel];

        NSInteger centerOffset = 10;
        NSInteger edgeOffset = 10;

        // Center Y Views
        [_standingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(edgeOffset);
            make.width.equalTo(@(20));
            make.centerY.equalTo(self);
        }];

        [_profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(30);
            make.size.equalTo(@44);
        }];

        // Top
        [@[_profileNameLabel, _pointsView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-centerOffset);
        }];

        // Bottom
        [@[_flagView, _coinView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(centerOffset);
        }];

        // Left
        [@[_profileNameLabel, _flagView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_profileImageView.mas_right).offset(edgeOffset);
        }];

        // Right
        [@[_pointsView, _coinView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-edgeOffset);
        }];

        // Special
        [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
        }];

        [_coinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18.2);
        }];

//        [_coinBeforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_coinView.mas_left).offset(-4);
//        }];
    }

    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setUser:(User *)user points:(NSInteger)points placement:(NSInteger)placement battle:(Battle *)battle {
    _profileNameLabel.font = [user.current boolValue] ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16];
    
    if (placement % 2 == 1) {
        self.contentView.backgroundColor = [UIColor lightBackgroundColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }

    // Placement
    _standingLabel.text = placement == 0 ? @"" : [NSString stringWithFormat:@"%li", (long)placement];
    _standingLabel.textColor = [UIColor hx_colorWithHexString:@"95A5A6"];
    
    [_profileImageView setBadgeText:[user.level stringValue]];
    [_profileImageView.imageView loadImageWithUrlString:[user profileImagePath:34] placeholder:@"ic_profile_user"];
    _profileNameLabel.text = user.name ?: @"Anonymous user";
    [_flagView setISO2CountryCode:user.country];


    [_pointsView setPoints:points];

    BOOL isBattleStarted = battle.state > BattleTemplateStateNotStarted;

    // Only show coin and placement
    if (isBattleStarted) {
        // Coins
        [_coinView setCoins:[user.win integerValue]];
//        _coinBeforeLabel.text = [@(placement) ordinalNumberSuffixString];
    }

//    _coinBeforeLabel.hidden = !isBattleStarted;
    _coinView.hidden = !isBattleStarted;

    _profileNameLabel.font = [user.objectId isEqualToString:[Identification userId]] ? [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f] : [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
    _standingLabel.font = [user.objectId isEqualToString:[Identification userId]] ? [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f] : [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
}

- (void)showCoinView:(BOOL)visible {
    [_coinView setHidden:!visible];
}

- (void)setupFriendRowAt:(NSInteger)friendIndex {
    UIColor *placeholderColor = [UIColor hx_colorWithHexString:@"D7DBDD"];
    _standingLabel.textColor = placeholderColor;
    _profileNameLabel.textColor = placeholderColor;
    _pointsView.pointsLabel.textColor = placeholderColor;
    _pointsView.pointsDescriptionLabel.textColor = placeholderColor;
    
    if (friendIndex == 1) {
        [_profileImageView.imageView setImage:[UIImage imageNamed:@"ic_friend_1"]];
        _profileNameLabel.text = @"Friend";
        _standingLabel.text = @"2";
    } else if (friendIndex == 2) {
        [_profileImageView.imageView setImage:[UIImage imageNamed:@"ic_friend_2"]];
        _profileNameLabel.text = @"Frenemy";
        _standingLabel.text = @"3";
    }
}

@end
