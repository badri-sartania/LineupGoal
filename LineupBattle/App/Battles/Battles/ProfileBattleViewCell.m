//
// Created by Anders Borre Hansen on 11/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <YLMoment/YLMoment.h>
#import "ProfileBattleViewCell.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "CoinView.h"
#import "FlagImage.h"
#import "NSNumber+OrdinalSuffix.h"
#import "UIColor+LineupBattle.h"
#import "PointsView.h"
#import "HexColors.h"
#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

static NSInteger flagSize = 36.0f;

@implementation ProfileBattleViewCell {
    UIView *_contentWrapper;
    DefaultImageView *_flagImageView;
    UIImageView *_imgBolt;
    UIImageView *_imgLive;
    UILabel *_titleLabel;
    UILabel *_stateLabel;
    UILabel *_timeLabel;
    CoinView *_creditView;
    PointsView *_pointsView;
    SectionHeaderView *sectionHeader;
//    UIImageView *_arrowView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _flagImageView = [[DefaultImageView alloc] initWithFrame:CGRectMake(7.f, 10.f, flagSize, flagSize)];
        [_flagImageView circleWithBorder:[UIColor primaryColor] diameter:flagSize borderWidth:1.0f];
        _titleLabel = [[UILabel alloc] init];
        _stateLabel = [[UILabel alloc] init];
        _timeLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
        _stateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16];
        _titleLabel.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        _stateLabel.textColor = [UIColor hx_colorWithHexString:@"#95A5A6"];
        _timeLabel.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        
        _imgBolt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_bolt"]];
        _imgLive = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_live"]];
        
        _contentWrapper = [[UIView alloc] init];
        [_contentWrapper setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentWrapper];
        
        [_contentWrapper addSubview:_flagImageView];
        [_contentWrapper addSubview:_titleLabel];
        [_contentWrapper addSubview:_stateLabel];
        [_contentWrapper addSubview:_timeLabel];
        [_contentWrapper addSubview:_imgBolt];
        [_contentWrapper addSubview:_imgLive];
        
        [self updateChildConstraints];
    }

    return self;
}

- (void)setData:(Battle *)battle position:(NSInteger)position{
    UIImage *flag = nil;
    if (battle.template.country != nil) {
        flag = [FlagImage flagWithCode:battle.template.country countryCodeFormat:CountryCodeFormatFifa];
        if (flag != nil) [_flagImageView setImage:flag];
    } else {
        NSString *flagName = [NSString stringWithFormat:@"flag_%@", [[battle.template.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        flag = [UIImage imageNamed:flagName];
        if (flag != nil) [_flagImageView setImage:flag];
    }
    
    if (battle.state == BattleTemplateStateNotStarted) {
        _stateLabel.text = [NSString stringWithFormat:@"Starts %@", [[YLMoment momentWithDate:battle.template.startDate] fromNow]];
        _timeLabel.text = [[YLMoment momentWithDate:battle.template.startDate] format:@"EEEE h:mm"];
        _pointsView.hidden = YES;
        _imgBolt.hidden = YES;
        _imgLive.hidden = YES;
    } else if (battle.state == BattleTemplateStateOngoing) {
        _stateLabel.text = [NSString stringWithFormat:@"Ends in %@", [[YLMoment momentWithDate:battle.template.endDate] fromNow]];
        _timeLabel.text = [battle.pos ordinalNumberSuffixString];
        _pointsView.hidden = YES;
        _imgBolt.hidden = YES;
        _imgLive.hidden = NO;
    } else {
        [_creditView setCoins:[battle.win integerValue]];
        _stateLabel.text = [NSString stringWithFormat:@"%@ place | %dp", [battle.pos ordinalNumberSuffixString], [battle.xp intValue]];
        _pointsView.hidden = YES;
        _timeLabel.text = [NSString stringWithFormat:@"%d", [battle.win intValue]];
        _imgBolt.hidden = NO;
        _imgLive.hidden = YES;
    }

    _creditView.hidden = battle.state == BattleTemplateStateNotStarted || battle.state == BattleTemplateStateOngoing;
    _titleLabel.text = battle.template.name;
    
    if (position % 2 == 0) {
        [_contentWrapper setBackgroundColor:[UIColor lightBackgroundColor]];
    } else {
        [_contentWrapper setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (sectionHeader != nil) {
        sectionHeader.hidden = YES;
    }
}

- (void)updateChildConstraints {
    [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentWrapper).offset(10);
        make.top.equalTo(_contentWrapper).offset(7);
        make.width.equalTo(@(flagSize));
        make.height.equalTo(@(flagSize));
    }];
    
    // Left
    [@[_titleLabel, _stateLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_flagImageView.mas_right).offset(7);
    }];
    
    [@[_titleLabel, _imgLive] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_contentWrapper).offset(-10);
    }];
    
    [_imgLive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(6);
        make.width.equalTo(@(28));
        make.height.equalTo(@(14));
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_contentWrapper).offset(8);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentWrapper).offset(-10);
    }];
    
    [@[_imgBolt, _timeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_contentWrapper);
    }];
    
    [_imgBolt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeLabel.mas_left).offset(-4);
    }];
}

- (void)setHorizontalMargin:(NSInteger)margin {
    [_contentWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setHorizontalMargin:(NSInteger)margin withHeader:(NSString *)headerTitle {
    sectionHeader = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 13, self.frame.size.width - 14, 20)];
    sectionHeader.hidden = NO;
    [sectionHeader setTitle:headerTitle];
    [sectionHeader setTitleColor:[UIColor whiteColor]];
    [sectionHeader setBackgroundColor:[UIColor hx_colorWithHexString:@"#2ECC71"]];
    
    [self addSubview:sectionHeader];
    [sectionHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7);
        make.right.equalTo(self).offset(-7);
        make.top.equalTo(self).offset(13);
        make.height.equalTo(@20);
    }];
    
    [_contentWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.top.equalTo(sectionHeader.mas_bottom);
        make.bottom.equalTo(self);
    }];
}

- (void)setShadowCell:(BOOL)shadow {
    if (shadow) {
        _contentWrapper.layer.masksToBounds = NO;
        _contentWrapper.layer.shadowOffset = CGSizeMake(0, 0);
        _contentWrapper.layer.shadowRadius = 3;
        _contentWrapper.layer.shadowOpacity = 0.2;
    } else {
        _contentWrapper.layer.masksToBounds = NO;
        _contentWrapper.layer.shadowOffset = CGSizeMake(0, 0);
        _contentWrapper.layer.shadowRadius = 0;
        _contentWrapper.layer.shadowOpacity = 0;
    }
}
- (void)setDemoData {
    _titleLabel.text = @"SUNDAY MIX";
    _stateLabel.text = @"Starts in 2 days";
    _timeLabel.text = @"Sunday 15:25";
}

@end
