//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "TeamTableCellView.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "UIImage+LineupBattle.h"
#import "FlagImage.h"
#import "ImageWithCaptainBadgeView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"


@interface TeamTableCellView ()
@property (nonatomic, strong) ImageWithCaptainBadgeView  *avatar;
@property (nonatomic, strong) UIImageView  *flag;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *position;
@property (nonatomic, strong) UILabel *mp;
@property (nonatomic, strong) UILabel *goals;
@property (nonatomic, strong) UILabel *assists;
@property (nonatomic, strong) UILabel *yr;
@end

@implementation TeamTableCellView
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.flag       = [[DefaultImageView alloc] init];
        
        UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
        UIColor *labelColor = [UIColor hx_colorWithHexString:@"2C3E50"];
        
        self.name = [[UILabel alloc] init];
        self.name.font = labelFont;
        self.name.textColor = labelColor;
        
        self.position   = [[UILabel alloc] init];
        self.position.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        self.position.textColor = [UIColor hx_colorWithHexString:@"95A5A6"];

        self.mp = [[UILabel alloc] init];
        self.mp.textAlignment = NSTextAlignmentCenter;
        self.mp.font = labelFont;
        self.mp.textColor = labelColor;

        self.goals = [[UILabel alloc] init];
        self.goals.textAlignment = NSTextAlignmentCenter;
        self.goals.font = labelFont;
        self.goals.textColor = labelColor;

        self.assists = [[UILabel alloc] init];
        self.assists.textAlignment = NSTextAlignmentCenter;
        self.assists.font = labelFont;
        self.assists.textColor = labelColor;

        self.yr = [[UILabel alloc] init];
        self.yr.textAlignment = NSTextAlignmentCenter;
        self.yr.font = labelFont;
        self.yr.textColor = labelColor;

        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.flag];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.position];
        [self.contentView addSubview:self.mp];
        [self.contentView addSubview:self.goals];
        [self.contentView addSubview:self.assists];
        [self.contentView addSubview:self.yr];
    }

    return self;
}

- (void)setupCell {
    [self defineLayout];
}

- (void)setData:(Player *)player {
    self.player = player;

    if (player.photoToken) {
        [self.avatar.imageView loadImageWithUrlString:[player photoImageUrlString:@"34"] placeholder:@"playerPlaceholderThumb"];
    } else {
        self.avatar.imageView.image = [UIImage imageNamed:@"playerPlaceholderThumb"];
    }
    [self.avatar showLineupStatusWithColor:player.lineupStatusColor image:player.lineupStatusImage];
    self.flag.image = [FlagImage flagWithCode:player.nationality countryCodeFormat:CountryCodeFormatFifa];
    self.name.text = player.name;
    self.position.text = player.positionName;
    self.mp.text = [player.stats[@"mp"] ?: @0 stringValue];
    self.goals.text = [player.stats[@"goals"] ?: @0 stringValue];
    self.assists.text = [player.stats[@"assists"] ?: @0 stringValue];
    self.yr.text = [NSString stringWithFormat:@"%@/%@", (player.stats[@"yellowCards"] ?: @0), (player.stats[@"redCards"] ?: @0)];
}

- (void)defineLayout {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(@44);
        make.left.equalTo(@11);
    }];

    [self.flag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-8);
        make.size.equalTo(@22);
        make.left.equalTo(self.avatar.mas_right).offset(11);
    }];

    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flag.mas_top).offset(2);
        make.left.equalTo(self.flag.mas_right).offset(7);
    }];

    [self.position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flag.mas_bottom).offset(1);
        make.left.equalTo(self.flag);
    }];

    UIView *superview = self.contentView;

    [@[self.mp, self.goals, self.assists, self.yr] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
        make.width.equalTo(@30);
    }];

    [self.mp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-100);
    }];

    [self.goals mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-70);
    }];

    [self.assists mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-40);
    }];

    [self.yr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-6);
    }];
}

#pragma mark - Views
- (ImageWithCaptainBadgeView *)avatar {
    if(!_avatar) {
        _avatar = [[ImageWithCaptainBadgeView alloc] init];
        [_avatar setContentMode:UIViewContentModeScaleAspectFit];
        [_avatar.imageView circleWithBorder:[UIColor whiteColor] diameter:44.f borderWidth:0.f];
        _avatar.imageView.image = [UIImage imageNamed:@"playerPlaceholderThumb"];
        [_avatar showBadge:NO];
    }

    return _avatar;
};

- (void)setAsDisabled {
    UIImage *bwImage = [[_avatar.imageView.image copy] imageBlackAndWhite];
    UIImage *bwFlag = [[_flag.image copy] imageBlackAndWhite];
    _avatar.imageView.image = bwImage;
    _flag.image= bwFlag;
}

@end
