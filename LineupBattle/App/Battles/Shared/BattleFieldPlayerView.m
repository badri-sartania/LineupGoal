//
// Created by Anders Hansen on 10/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "BattleFieldPlayerView.h"
#import "DefaultImageView.h"
#import "DefaultLabel.h"
#import "ImageWithCaptainBadgeView.h"
#import "BattleHelper.h"
#import "UIColor+LineupBattle.h"
#import "BadgeView.h"
#import "HexColors.h"


@interface BattleFieldPlayerView ()
@property(nonatomic, strong) DefaultLabel *playerName;
@property(nonatomic, strong) DefaultLabel *playerTeam;
@property(nonatomic, strong) ImageWithCaptainBadgeView *playerImage;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) UIButton *captainButton;
@property(nonatomic, strong) DefaultLabel *playerPoints;
@end

@implementation BattleFieldPlayerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.playerName = [DefaultLabel initWithFont:@"HelveticaNeue-Bold" size:13 color:[UIColor hx_colorWithHexString:@"#34495E"]];
        self.playerName.textAlignment = NSTextAlignmentCenter;
        self.playerTeam = [DefaultLabel initWithFont:@"HelveticaNeue-Medium" size:10 color:[UIColor hx_colorWithHexString:@"#34495E"]];
        self.playerPoints = [DefaultLabel initWithFont:@"HelveticaNeue-Bold" size:15 color:[UIColor hx_colorWithHexString:@"#34495E"]];

        [self addSubview:self.playerName];
        [self addSubview:self.playerTeam];
        [self addSubview:self.playerPoints];
        [self addSubview:self.playerImage];
        [self addSubview:self.button];
        [self addSubview:self.captainButton];

        [self.playerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(2);
            make.size.equalTo(@62);
        }];

        [self.playerName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.playerImage.mas_bottom).offset(5);
        }];

        [self.playerTeam mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.playerName.mas_bottom).offset(2);
        }];

        [self.playerPoints mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.playerTeam.mas_bottom).offset(1);
        }];

        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
//            UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
//            make.edges.equalTo(self).with.insets(padding);
            make.edges.equalTo(self.playerImage);
        }];
        
        [self.captainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.playerImage).offset(10);
            make.bottom.equalTo(self.playerImage).offset(10);
            make.width.equalTo(@32);
            make.height.equalTo(@32);
        }];
    }

    return self;
}


- (instancetype)initWithPlayer:(Player *)player points:(NSInteger)points {
    self = [self init];
    if (self) {
        [self setPlayer:player];
        [self setPointsLabelText:points];
    }

    return self;
}

- (instancetype)initWithPlayer:(Player *)player {
    self = [self init];
    if (self) {
        [self setPlayer:player];
    }

    return self;
}

#pragma mark - Events
- (void)buttonPressed:(id)sender {
    [self.delegate buttonWasPressed:self];
}

- (void)captainButtonPressed:(id)sender {
    if (self.delegate != nil)
        [self.delegate captainButtonWasPressed: self];
}

#pragma mark - Set methods
- (void)setPlayer:(Player *)player {
    _player = player;

    if (player.objectId) {
        self.playerName.numberOfLines = 1;
        self.playerName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        self.playerName.text = player.name;
        self.playerTeam.text = [player.team.name uppercaseString];
//        self.playerPoints.text = [NSString stringWithFormat:@"%dp", player.team.points.intValue];
        if ([player.captain boolValue]) {
            self.playerPoints.text = [NSString stringWithFormat:@"%dp + %dp", _player.team.points.intValue, _player.team.points.intValue];
        } else {
            self.playerPoints.text = [NSString stringWithFormat:@"%dp", _player.team.points.intValue];
        }
        [self.playerImage.imageView loadImageWithUrlString:[player photoImageUrlString:@"34"] placeholder:@"playerPlaceholderThumb"];
        [self.playerImage.imageView circleWithBorder:[UIColor hx_colorWithHexString:@"2C3E50"] diameter:62 borderWidth:2.f];
        [self.playerImage showBadge:YES];
        [self.playerImage setCaptain:[player.captain boolValue]];
//        [self.playerImage showLineupStatusWithColor:player.lineupStatusColor image:player.lineupStatusImage];
        [self.playerImage showLineupStatusWithColor:[UIColor hx_colorWithHexString:@"1d952b"] image:[UIImage imageNamed:@"lineupStatusCheck"]];
    } else {
        self.playerName.numberOfLines = 2;
        self.playerName.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
        self.playerName.text = [[BattleHelper playerPositionNameByPositionType:player.position] uppercaseString];
        self.playerImage.imageView.image = [UIImage imageNamed:@"img_addPlayer"];
        [self.playerImage showBadge:NO];
        [self.playerImage setCaptain:NO];
    }
}

- (void)setPointsLabelText:(NSInteger)points {
//    self.playerPoints.text = [NSString stringWithFormat:@"%lip", (long)points];
    if ([_player.captain boolValue]) {
        self.playerPoints.text = [NSString stringWithFormat:@"%lip + %lip", (long)points, (long)points];
    } else {
        self.playerPoints.text = [NSString stringWithFormat:@"%lip", (long)points];
    }
}

- (void)showCaptainBadge:(BOOL)isVisible {
    self.playerImage.badgeView.hidden = !isVisible;
}

#pragma mark - Views
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor clearColor];
    }

    return _button;
}

- (UIButton *)captainButton {
    if (!_captainButton) {
        _captainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captainButton addTarget:self action:@selector(captainButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _captainButton.backgroundColor = [UIColor clearColor];
    }
    
    return _captainButton;
}

- (ImageWithCaptainBadgeView *)playerImage {
    if (!_playerImage ) {
        _playerImage = [[ImageWithCaptainBadgeView alloc] init];
        _playerImage.imageView.image = [UIImage imageNamed:@"playerPlaceholderThumb"];
//        [_playerImage.imageView circleWithBorder:[UIColor actionColor] diameter:40 borderWidth:2.5f];
    }

    return _playerImage;
}

@end
