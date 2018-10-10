//
// Created by Anders Borre Hansen on 26/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "BattlesTableViewCell.h"
#import "DefaultLabel.h"
#import "Date.h"
#import "CoinView.h"
#import "UIColor+LineupBattle.h"
#import "BoxLabelView.h"
#import "StyleKitView.h"
#import "StyleKit.h"
#import "FlagImage.h"
#import "DefaultImageView.h"
#import "UIImage+LineupBattle.h"
#import "HexColors.h"


@implementation BattlesTableViewCell {
    UIView *_contentWrapper;
    UIView *_seperator;
    DefaultImageView *_flagImageView;
    UILabel *_battleNameLabel;
    UILabel *_battleDetailLabel;
    UIImageView *_boltImage;
    UIImageView *_userImage;
    UILabel *_boltLabel;
    UILabel *_userLabel;
    UILabel *_prizeLabel;
    UILabel *_entriesLabel;
    UIImageView *_arrowView;
};

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _contentWrapper = [[UIView alloc] init];
        [_contentWrapper setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentWrapper];
        
        _contentWrapper.layer.masksToBounds = NO;
        _contentWrapper.layer.shadowOffset = CGSizeMake(0, 5);
        _contentWrapper.layer.shadowRadius = 5;
        _contentWrapper.layer.shadowOpacity = 0.1;
        
        _seperator = [[UIView alloc] init];
        [_seperator setBackgroundColor:[UIColor hx_colorWithHexString:@"#ECF0F1"]];
        
        _flagImageView = [[DefaultImageView alloc] initWithFrame:CGRectMake(13.f, 13.f, 46.f, 46.f)];

        _battleNameLabel = [[UILabel alloc] init];
        _battleDetailLabel = [[UILabel alloc] init];
        _boltLabel = [[UILabel alloc] init];
        _userLabel = [[UILabel alloc] init];
        _prizeLabel = [[UILabel alloc] init];
        _entriesLabel = [[UILabel alloc] init];
        _battleNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
        _battleDetailLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
        _boltLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
        _userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
        _prizeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _entriesLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _battleNameLabel.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        _battleDetailLabel.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        _boltLabel.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        _userLabel.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        _prizeLabel.textColor = [UIColor hx_colorWithHexString:@"#95A5A6"];
        _entriesLabel.textColor = [UIColor hx_colorWithHexString:@"#95A5A6"];
        
        _boltImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_bolt"]];
        _userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_user"]];
        _prizeLabel.text = @"Prizes";
        _entriesLabel.text = @"Max entries";
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_right"]];
        
        [_contentWrapper addSubview:_seperator];
        [_contentWrapper addSubview:_flagImageView];
        [_contentWrapper addSubview:_battleNameLabel];
        [_contentWrapper addSubview:_battleDetailLabel];
        
        [_contentWrapper addSubview:_boltImage];
        [_contentWrapper addSubview:_userImage];
        [_contentWrapper addSubview:_boltLabel];
        [_contentWrapper addSubview:_userLabel];
        [_contentWrapper addSubview:_prizeLabel];
        [_contentWrapper addSubview:_entriesLabel];
        
        [_contentWrapper addSubview:_arrowView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_contentWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7);
        make.right.equalTo(self).offset(-7);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentWrapper);
        make.top.equalTo(_contentWrapper);
        make.right.equalTo(_contentWrapper);
        make.height.equalTo(@1);
    }];
    
    [@[_battleNameLabel, _boltImage, _prizeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_flagImageView.mas_right).offset(12);
    }];
    
    [_battleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWrapper).offset(7);
    }];

    [_boltImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@11);
        make.height.equalTo(@15);
        make.top.equalTo(_contentWrapper).offset(32);
    }];
    
    [_boltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_boltImage.mas_right).offset(3);
        make.top.equalTo(_contentWrapper).offset(31);
    }];
    
    [_prizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWrapper).offset(48);
    }];
    
    [@[_userImage, _entriesLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_flagImageView.mas_right).offset(61);
    }];
    
    [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWrapper).offset(33);
        make.width.equalTo(@11);
        make.height.equalTo(@13);
    }];
    
    [_entriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWrapper).offset(48);
    }];
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWrapper).offset(31);
        make.left.equalTo(_userImage.mas_right).offset(2);
    }];
    
    [_battleDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWrapper).offset(7);
        make.right.equalTo(_contentWrapper).offset(-11);
    }];

    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_battleDetailLabel.mas_bottom).offset(12);
        make.right.equalTo(_contentWrapper).offset(-11);
    }];
    _arrowView.hidden = YES;
    
    [super layoutSubviews];
}

- (void)setData:(BattleTemplate *)battleTemplate :(int)index {
    UIImage *flag = nil;
    if (battleTemplate.country != nil) {
        flag = [FlagImage flagWithCode:battleTemplate.country countryCodeFormat:CountryCodeFormatFifa];
        if (flag != nil) [_flagImageView setImage:flag];
    } else {
        NSString *flagName = [NSString stringWithFormat:@"flag_%@", [[battleTemplate.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        flag = [UIImage imageNamed:flagName];
        if (flag != nil) [_flagImageView setImage:flag];
        else [_flagImageView setImage:[UIImage imageNamed:@"flag_premier_league"]];
    }
    if (index == 0) {
        _seperator.backgroundColor = [UIColor whiteColor];
    }
    _battleNameLabel.text = battleTemplate.name;
    
    self.layer.zPosition = index;
//    [_entryView setCoins:[battleTemplate.entry integerValue]];
//    [_priceView setCoins:([battleTemplate.entry integerValue] ?: 0)*[battleTemplate.maxUsers integerValue]];
//    _participantsLabel.text = [battleTemplate.maxUsers stringValue];
    
    _boltLabel.text = [battleTemplate.entry stringValue];
    _userLabel.text = [battleTemplate.maxUsers stringValue];
    
    YLMoment *moment = [YLMoment momentWithDate:battleTemplate.startDate];

    [self setReminderStatus:[battleTemplate.reminder boolValue]];

    if ([moment isValid]) {
        [_battleDetailLabel setText:[[moment format:@"HH:mm"] uppercaseString]];
    }

    [self setAsJoined:[battleTemplate.joined boolValue]];
}

- (void)setAsJoined:(BOOL)joined {
    if (joined) {
        if ([self viewWithTag:99]) return;

        UIView *overlayView = UIView.new;
        overlayView.tag = 99;
        [self addSubview:overlayView];

        overlayView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];

        [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        DefaultLabel *joinedLabel = [DefaultLabel initWithColor:[UIColor actionColor]];
        joinedLabel.text = @"Battle joined";
        [overlayView addSubview:joinedLabel];

        [joinedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(overlayView).offset(-14);
            make.left.equalTo(overlayView).offset(70);
        }];

        UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        [overlayView addSubview:checkImageView];

        [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(joinedLabel.mas_right).offset(5);
            make.centerY.equalTo(joinedLabel);
        }];


//        [_reminderButton setImage:[UIImage imageNamed:@"bell_gray"] forState:UIControlStateNormal];
    } else {
        [[self viewWithTag:99] removeFromSuperview];
    }

//    _battleNameLabel.textColor = joined ? [UIColor darkGrayColor] : [UIColor actionColor];
//    [_battleDetailLabel setColor:joined ? [UIColor darkGrayColor] : [UIColor actionColor]];
}

- (void)setReminderStatus:(BOOL)reminder {
    NSString *bellImageName = reminder ? @"bell_selected" : @"bell";
//    [_reminderButton setImage:[UIImage imageNamed:bellImageName] forState:UIControlStateNormal];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _flagImageView.image = nil;
}

- (void)reminderButtonAction {
    [self.delegate buttonWasPressed:self];
}

- (void)setDemoAt:(int)index {
    if (index == 0) {
        self.layer.zPosition = index;
        [_flagImageView setImage:[UIImage imageNamed:@"flag_premier_league"]];
        _battleNameLabel.text = @"PREMIER LEAGUE";
        _battleDetailLabel.text = @"12:30";
        _boltLabel.text = @"60";
        _userLabel.text = @"12";
    } else if (index == 1) {
        self.layer.zPosition = index;
        [_flagImageView setImage:[UIImage imageNamed:@"flag_mix"]];
        _battleNameLabel.text = @"SATURDAY MIX";
        _battleDetailLabel.text = @"15:00";
        _boltLabel.text = @"60";
        _userLabel.text = @"12";
    } else {
        self.layer.zPosition = index;
        [_flagImageView setImage:[UIImage imageNamed:@"flag_champions_league"]];
        _battleNameLabel.text = @"CHAMPIONS LEAGUE";
        _battleDetailLabel.text = @"21:30";
        _boltLabel.text = @"120";
        _userLabel.text = @"12";
    }
}

@end
