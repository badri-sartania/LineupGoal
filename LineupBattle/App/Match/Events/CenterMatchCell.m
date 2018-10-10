//
// Created by Anders Hansen on 08/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "CenterMatchCell.h"
#import "DefaultLabel.h"
#import "HexColors.h"


@interface CenterMatchCell ()
@property(nonatomic, strong) DefaultLabel *homeTeamName;
@property(nonatomic, strong) DefaultLabel *awayTeamName;
@property(nonatomic, strong) DefaultLabel *homeStanding;
@property(nonatomic, strong) DefaultLabel *awayStanding;
@property(nonatomic, strong) DefaultLabel *matchInfo;
@property(nonatomic, strong) DefaultLabel *standingSeperator;
@end

@implementation CenterMatchCell

- (void)setData:(Match *)match {
    self.homeTeamName.text = match.home.name;
    self.awayTeamName.text = match.away.name;
    self.homeStanding.text = [match.homeStanding stringValue];
    self.awayStanding.text = [match.awayStanding stringValue];
    self.matchInfo.text = [NSString stringWithFormat:@"%@, %@", match.competition.name, [[YLMoment momentWithDate:match.kickOff] format:@"d. MMM YYYY"]];
}

- (void)addSubviews {
    self.homeTeamName       = [DefaultLabel initWithSystemFontSize:14];
    self.homeTeamName.textAlignment = NSTextAlignmentRight;
    self.awayTeamName       = [DefaultLabel initWithSystemFontSize:14];

    self.homeStanding       = [DefaultLabel init];
    self.awayStanding       = [DefaultLabel init];
    self.standingSeperator  = [DefaultLabel initWithText:@":"];
    self.matchInfo          = [DefaultLabel init];
    self.matchInfo.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    self.matchInfo.textColor = [UIColor hx_colorWithHexString:@"717171"];

    [self addSubview:self.homeTeamName];
    [self addSubview:self.awayTeamName];
    [self addSubview:self.homeStanding];
    [self addSubview:self.awayStanding];
    [self addSubview:self.standingSeperator];
    [self addSubview:self.matchInfo];
}

- (void)defineLayout {
    NSArray *centerViews = @[self.standingSeperator, self.matchInfo];
    NSArray *topViews = @[self.homeTeamName, self.awayTeamName, self.homeStanding, self.awayStanding, self.standingSeperator];

    [topViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
    }];

    [centerViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];

    // Home Team
    [self.homeStanding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-10);
    }];

    [self.homeTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.homeStanding.mas_left).offset(-10);
        make.left.equalTo(self).offset(10);
    }];

    // Away Team
    [self.awayStanding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(10);
    }];

    [self.awayTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayStanding.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
    }];

    // Info
    [self.matchInfo mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self).offset(23);
    }];
}

@end
