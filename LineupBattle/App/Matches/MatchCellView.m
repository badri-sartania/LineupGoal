//
// Created by Anders Borre Hansen on 26/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "MatchCellView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"

@interface MatchCellView ()
- (void)setAsUnstarted;
- (void)setAsStarted:(Match *)match;
- (void)setAsFinished:(Match *)match;
- (void)markLeadingTeam:(Match *)match;
@end

@implementation MatchCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;

        self.matchHomeName = [[UILabel alloc] init];
        self.matchHomeName.font = [UIFont fontWithName:@"HelveticaNeue" size: 15];
        self.matchHomeName.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        
        [self.contentView addSubview:self.matchHomeName];

        self.matchAwayName = [[UILabel alloc] init];
        self.matchAwayName.font = [UIFont fontWithName:@"HelveticaNeue" size: 15];
        self.matchAwayName.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];

        [self.contentView addSubview:self.matchAwayName];

        self.standingBackground = [[UIView alloc] init];
        [self.contentView addSubview:self.standingBackground];

        self.matchHomeStanding = [[UILabel alloc] init];
        self.matchHomeStanding.font = [UIFont fontWithName:@"HelveticaNeue" size: 15];
        self.matchHomeStanding.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        [self.contentView addSubview:self.matchHomeStanding];

        self.matchAwayStanding = [[UILabel alloc] init];
        self.matchAwayStanding.font = [UIFont fontWithName:@"HelveticaNeue" size: 15];
        self.matchAwayStanding.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        [self.contentView addSubview:self.matchAwayStanding];

        self.matchInfo = [[UILabel alloc] init];
        self.matchInfo.font = [UIFont fontWithName:@"HelveticaNeue" size: 15];
        self.matchInfo.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
        [self.contentView addSubview:self.matchInfo];
    }

    return self;
}

- (void)setupMatch:(Match *)match {
    if (match) {
        self.match = match;
        [self setData:match];
        [self setMatchState:match];
    }
}

- (void)setData:(Match *)match {
    self.matchInfo.text = match.infoText;
    self.matchHomeName.text = match.home.name;
    self.matchAwayName.text = match.away.name;
    [self.matchHomeStanding setText:[match.homeStanding stringValue]];
    [self.matchAwayStanding setText:[match.awayStanding stringValue]];

    // Adding cards
    [self removeAllCards];
    [self addCardsFor:self.matchHomeName withNumberOfCards:match.homeRedCards];
    [self addCardsFor:self.matchAwayName withNumberOfCards:match.awayRedCards];

    // Add highlight if just scored
    [self highlightJustScoreForTeams:match];
}

- (void)highlightJustScoreForTeams:(Match *)match {
    UIColor *highlightColor = [UIColor hx_colorWithHexString:@"1d952b"];
    match.hasNewHomeGoal ? [self hightLightLabel:self.matchHomeName color:highlightColor] : [self unHighlightLabel:self.matchHomeName];
    match.hasNewAwayGoal ? [self hightLightLabel:self.matchAwayName color:highlightColor] : [self unHighlightLabel:self.matchAwayName];
}

- (void)hightLightLabel:(UILabel *)label color:(UIColor *)color {
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 15];
    if (self.match.isPlaying) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = color;
    }
}

- (void)unHighlightLabel:(UILabel *)label {
    label.font = [UIFont fontWithName:@"HelveticaNeue" size: 15];
    if (self.match.isPlaying) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = [UIColor hx_colorWithHexString:@"2C3E50"];
    }
}

- (void)setMatchState:(Match *)match {
    if (match.isPlaying) {
        [self setAsStarted:match];
    } else if (match.hasFinished)  {
        [self setAsFinished:match];
    } else {
        [self setAsUnstarted];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.matchInfo.textAlignment = NSTextAlignmentCenter;
    self.matchHomeStanding.textAlignment = NSTextAlignmentCenter;
    self.matchAwayStanding.textAlignment = NSTextAlignmentCenter;

    [self.matchInfo mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(@18);
       make.centerY.equalTo(self.mas_centerY);
       make.width.equalTo(@50);
    }];

    [self.standingBackground mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.matchInfo.mas_right).offset(12);
       make.top.equalTo(self);
       make.width.equalTo(@25);
       make.height.equalTo(@56);
    }];

    [self.matchHomeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-11);
        make.left.equalTo(self.standingBackground.mas_right).offset(10);
    }];

    [self.matchAwayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(11);
        make.left.equalTo(self.standingBackground.mas_right).offset(10);
    }];

    [self.matchHomeStanding mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self.standingBackground);
       make.centerY.equalTo(self.standingBackground).offset(-11);
    }];

    [self.matchAwayStanding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.standingBackground);
        make.centerY.equalTo(self.standingBackground).offset(11);
    }];
}

#pragma mark - Decorator methods

- (void)setAsUnstarted {
    self.matchHomeStanding.text = @"0";
    self.matchAwayStanding.text = @"0";
    self.standingBackground.backgroundColor = [UIColor hx_colorWithHexString:@"ECF0F1"];
}

- (void)setAsStarted:(Match *)match {
    [self markLeadingTeam:match];
    self.standingBackground.backgroundColor = [UIColor hx_colorWithHexString:@"2ECC71"];
    
}

- (void)setAsFinished:(Match *)match {
    [self markLeadingTeam:match];
    self.standingBackground.backgroundColor = [UIColor hx_colorWithHexString:@"ECF0F1"];
}

- (void)markLeadingTeam:(Match *)match {
    BOOL homeHighlight = [match.homeStanding compare:match.awayStanding] == NSOrderedDescending;
    BOOL awayHighlight = [match.homeStanding compare:match.awayStanding] == NSOrderedAscending;

    if (homeHighlight) {
        [self hightLightLabel:self.matchHomeName color:[UIColor hx_colorWithHexString:@"2C3E50"]];
        [self hightLightLabel:self.matchHomeStanding color:[UIColor hx_colorWithHexString:@"2C3E50"]];
    } else {
        [self unHighlightLabel:self.matchHomeName];
        [self unHighlightLabel:self.matchHomeStanding];
    }

    if (awayHighlight) {
        [self hightLightLabel:self.matchAwayName color:[UIColor hx_colorWithHexString:@"2C3E50"]];
        [self hightLightLabel:self.matchAwayStanding color:[UIColor hx_colorWithHexString:@"2C3E50"]];
    } else {
        [self unHighlightLabel:self.matchAwayName];
        [self unHighlightLabel:self.matchAwayStanding];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - card methods

- (void)removeAllCards {
    UIView *removeView;
    while ((removeView = [self viewWithTag:45]) != nil) {
        [removeView removeFromSuperview];
    }
}

- (void)addCardsFor:(UIView *)team withNumberOfCards:(NSNumber *)cards {
    NSInteger redCount = cards == nil ? 0 : [cards integerValue];

    UIImageView *prevHomeImage;
    for (NSInteger j = 0; j < redCount; j++) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small_redcard"]];
        img.tag = 45;
        [self addSubview:img];

        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(team.mas_baseline).offset(0.5f);

            if (prevHomeImage == nil) {
                make.left.equalTo(team.mas_right).offset(5);
            } else {
                make.left.equalTo(prevHomeImage.mas_right).offset(3);
            }
        }];

        prevHomeImage = img;
    }
}

@end
