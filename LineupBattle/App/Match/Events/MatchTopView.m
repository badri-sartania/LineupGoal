//
// Created by Anders Borre Hansen on 06/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import <Mixpanel/Mixpanel.h>
#import "Crashlytics.h"
#import "MatchTopView.h"
#import "DefaultLabel.h"
#import "TeamViewController.h"
#import "DefaultNavigationController.h"
#import "DefaultImageView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"
#import <YLMoment/YLMoment.h>
#import "Utils.h"

@interface MatchTopView ()
    @property(nonatomic, strong) UIButton *homeButton;
    @property(nonatomic, strong) UIButton *awayButton;
    @property(nonatomic, strong) DefaultLabel *league;
    @property(nonatomic, strong) DefaultLabel *homeClubName;
    @property(nonatomic, strong) DefaultImageView *homeClubImageView;
    @property(nonatomic, strong) DefaultLabel *awayClubName;
    @property(nonatomic, strong) DefaultImageView *awayClubImageView;
    @property(nonatomic, strong) DefaultLabel *matchTime;
    @property(nonatomic, strong) DefaultLabel *matchStanding;
//    @property(nonatomic, strong) CALayer *bottomBorder;
@end

@implementation MatchTopView

- (id)initWithViewModel:(MatchViewModel *)viewModel frame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.viewModel = viewModel;
        self.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.league];
        [self addSubview:self.homeClubName];
        [self addSubview:self.homeClubImageView];
        [self addSubview:self.matchStanding];
        [self addSubview:self.matchTime];
        [self addSubview:self.awayClubImageView];
        [self addSubview:self.awayClubName];
        [self addSubview:self.homeButton];
        [self addSubview:self.awayButton];

//        [self.layer addSublayer:self.bottomBorder];

        [self defineMASLayout];
        [self updateViews];
    }

    return self;
}

- (void)updateViews {
    Match *match = self.viewModel.model;

    self.league.text = match.competition.name;
    self.homeClubName.text = match.home.name;
    self.awayClubName.text = match.away.name;


    if ([match isNotStartedYet]) {
        if (match.kickOff != nil) {
//            self.matchStanding.text = [[YLMoment momentWithDate:match.kickOff] format:@"dd MMM"];
            self.matchStanding.text = @"0-0";
        }
    } else {
        self.matchTime.text = [match infoText];
        self.matchStanding.text =  match.homeStanding == nil &&  match.awayStanding == nil ? @"0-0" : [NSString stringWithFormat:@"%@-%@", match.homeStanding, match.awayStanding];
    }

    [self.homeClubImageView loadImageWithUrlString:match.home.logoUrl placeholder:@"clubPlaceholder"];
    [self.awayClubImageView loadImageWithUrlString:match.away.logoUrl placeholder:@"clubPlaceholder"];


}

#pragma mark - Layout
- (void)defineMASLayout {
    UIView *superview = self;
    NSNumber *imageSize = @60.f;

    // League
    [self.league mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.top.equalTo(superview.mas_top).offset(10);
        make.height.equalTo(@30);
        make.width.equalTo(superview);
    }];
    
    // Standing
    [self.matchStanding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.centerX.equalTo(superview);
        make.centerY.equalTo(superview);
    }];

    // Home and Away club logos
    [self.homeClubImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.matchStanding.mas_left);
        make.centerY.equalTo(self.matchStanding.mas_centerY);
        make.size.equalTo(imageSize);
    }];
    
    [self.awayClubImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.matchStanding.mas_centerY);
        make.left.equalTo(self.matchStanding.mas_right);
        make.size.equalTo(imageSize);
    }];
    //////////////////////////////
    
    // Time
    [self.matchTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(@[self.homeClubName, self.awayClubName]);
        make.centerX.equalTo(superview);
    }];
    //////////////////////////////
    
    [self.homeClubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.homeClubImageView.mas_centerX);
        make.top.equalTo(self.homeClubImageView.mas_bottom).offset(5.f);
        make.width.equalTo(@100);
    }];

    [self.homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.homeClubImageView);
        make.centerY.equalTo(self.homeClubImageView);
        make.size.equalTo(imageSize);
    }];

    // Away Team
    [self.awayClubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.awayClubImageView.mas_centerX);
        make.top.equalTo(self.awayClubImageView.mas_bottom).offset(5.f);
        make.width.equalTo(@100);
    }];

    [self.awayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.awayClubImageView);
        make.centerY.equalTo(self.awayClubImageView);
        make.size.equalTo(imageSize);
    }];
}

#pragma mark - Views
- (UIButton *)homeButton {
    if (!_homeButton) {
        _homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _homeButton.frame = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);
        [_homeButton addTarget:self action:@selector(buttonForHomeTeam:) forControlEvents:UIControlEventTouchUpInside];
        _homeButton.backgroundColor = [UIColor clearColor];
    }

    return _homeButton;
}

- (UIButton *)awayButton {
    if (!_awayButton) {
        _awayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _awayButton.frame = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);
        [_awayButton addTarget:self action:@selector(buttonForAwayTeam:) forControlEvents:UIControlEventTouchUpInside];
        _awayButton.backgroundColor = [UIColor clearColor];
    }

    return _awayButton;
}

- (DefaultLabel *)league {
    if (!_league) {
        _league = [DefaultLabel initWithSystemFontSize:15 color:[UIColor secondaryTextColor]];
        _league.textAlignment = NSTextAlignmentCenter;
    }

    return _league;
}

- (DefaultImageView *)homeClubImageView {
    if (!_homeClubImageView) {
        _homeClubImageView = [[DefaultImageView alloc] init];
        [_homeClubImageView setContentMode:UIViewContentModeScaleAspectFit];
        _homeClubImageView.image = [UIImage imageNamed:@"clubPlaceholder"];
    }

    return _homeClubImageView;
}

- (DefaultLabel *)homeClubName {
    if (!_homeClubName) {
        _homeClubName = [DefaultLabel initWithBoldSystemFontSize:15 color:[UIColor primaryColor]];
        _homeClubName.textAlignment = NSTextAlignmentCenter;
        _homeClubName.adjustsFontSizeToFitWidth = YES;
    }

    return _homeClubName;
}

- (DefaultLabel *)matchStanding {
    if (!_matchStanding) {
        _matchStanding = [DefaultLabel initWithCondensedBoldSystemFontSize:40 color:[UIColor primaryTextColor]];
        _matchStanding.textAlignment = NSTextAlignmentCenter;
    }

    return _matchStanding;
}

- (DefaultLabel *)matchTime {
    if (!_matchTime) {
        _matchTime = [DefaultLabel initWithBoldSystemFontSize:15 color:[UIColor primaryColor]];
    }

    return _matchTime;
}

- (DefaultImageView *)awayClubImageView {
    if (!_awayClubImageView) {
        _awayClubImageView = [[DefaultImageView alloc] init];
        [_awayClubImageView setContentMode:UIViewContentModeScaleAspectFit];
        _awayClubImageView.image = [UIImage imageNamed:@"clubPlaceholder"];
    }

    return _awayClubImageView;
}

- (DefaultLabel *)awayClubName {
    if (!_awayClubName) {
        _awayClubName = [DefaultLabel initWithBoldSystemFontSize:15 color:[UIColor primaryColor]];
        _awayClubName.textAlignment = NSTextAlignmentCenter;
        _awayClubName.adjustsFontSizeToFitWidth = YES;
    }

    return _awayClubName;
}

//- (CALayer *)bottomBorder {
//    if (!_bottomBorder) {
//        _bottomBorder = [CALayer layer];
//        _bottomBorder.frame = CGRectMake(10, 117, self.frame.size.width-20, 0.5);
//        _bottomBorder.backgroundColor = [UIColor hx_colorWithHexString:@"#717171"].CGColor;
//    }
//
//    return _bottomBorder;
//}

#pragma mark - Events
- (void)buttonForHomeTeam:(id)selector {
    [self teamButton:self.viewModel.model.home];
}

- (void)buttonForAwayTeam:(id)selector {
    [self teamButton:self.viewModel.model.away];
}

- (void)teamButton:(Team *)team {
    TeamViewController *teamViewController = [[TeamViewController alloc] initWithTeam:team];
    teamViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeModal:)];
    // NavigationItems need to be set before this init else the Notification injection in the DefaultNavigationController will not pick the changes up
    DefaultNavigationController *nav = [[DefaultNavigationController alloc] initWithRootViewController:teamViewController];


    [self.viewController presentViewController:nav animated:YES completion:nil];

    @weakify(team);
    [[RACObserve(team, objectId) distinctUntilChanged] subscribeNext:^(NSString *objectId) {
        @strongify(team);

        if (objectId != nil) {
            CLS_LOG(@"Team: %@", objectId);

            [[Mixpanel sharedInstance] track:@"Team" properties:@{
                @"id": team.objectId ?: [NSNull null],
                @"name": team.name ?: [NSNull null],
                @"origin": @"match events"
            }];
        }
    }];
}

- (void)closeModal:(id)sender {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
