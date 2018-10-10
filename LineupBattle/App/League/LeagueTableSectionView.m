//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "LeagueTableSectionView.h"
#import "DefaultLabel.h"
#import "Utils.h"
#import "Competition.h"
#import "UIColor+LineupBattle.h"
#import "FlagView.h"

@interface LeagueTableSectionView ()
@property (nonatomic, strong) FlagView *flagView;
@property (nonatomic, strong) DefaultLabel *mp;
@property (nonatomic, strong) DefaultLabel *pts;
@property (nonatomic, strong) DefaultLabel *diff;

@end


@implementation LeagueTableSectionView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.flagView = [[FlagView alloc] initWithCountryCode:nil countryCodeFormat:CountryCodeFormatISO31661Alpha2];
        self.flagView.countryLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15.0f];
        [self.flagView.countryLabel setTextColor:[UIColor primaryTextColor]];
        self.flagView.countryLabel.alpha = 1.0f;

        // Stats
        self.mp         = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryTextColor]];
        self.mp.text    = @"M";
        self.pts        = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryTextColor]];
        self.pts.text   = @"Pts";
        self.diff       = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryTextColor]];
        self.diff.text  = @"+/-";
        self.pts.textAlignment = NSTextAlignmentRight;
        self.mp.textAlignment = NSTextAlignmentLeft;
        self.diff.textAlignment = NSTextAlignmentCenter;

        [self addSubview:self.flagView];
        [self addSubview:self.mp];
        [self addSubview:self.pts];
        [self addSubview:self.diff];

        [self defineLayout];
    }
    return self;
}

- (void)setGrouping:(Grouping *)grouping {
    self.flagView.countryLabel.text = [grouping.competition.name uppercaseString];
    if (grouping.competition.country) [self.flagView setISO2CountryCode:grouping.competition.country];
}

- (void)defineLayout {

    [@[self.flagView, self.mp, self.diff, self.pts] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];

    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
    }];

    // Stats
    [self.pts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.width.equalTo(@40);
    }];

    [self.diff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pts.mas_left).offset(0);
        make.width.equalTo(@35);
    }];

    [self.mp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.diff.mas_left);
        make.width.equalTo(@35);
    }];

}

@end
