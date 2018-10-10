//
// Created by Anders Hansen on 07/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "PreMatchView.h"
#import "TeamFormView.h"
#import "CenterMatchCell.h"
#import "DefaultSubscriptionViewController.h"
#import "MatchPageViewController.h"
#import "UIColor+LineupBattle.h"

@interface PreMatchView ()

//@property(nonatomic, strong) DefaultLabel *coachesSectionLabel;
//@property(nonatomic, strong) DefaultLabel *venueSectionLabel;
//@property(nonatomic, strong) DefaultLabel *refereeSectionLabel;
//@property(nonatomic, strong) DefaultLabel *prevMeetingsSectionLabel;
//@property(nonatomic, strong) DefaultLabel *homeCoachLabel;
//@property(nonatomic, strong) DefaultLabel *awayCoachLabel;
//@property(nonatomic, strong) DefaultImageView *awayCoachFlag;
//@property(nonatomic, strong) DefaultImageView *homeCoachFlag;
//@property(nonatomic, strong) DefaultLabel *venueLabel;
//@property(nonatomic, strong) DefaultLabel *refereeLabel;
@property(nonatomic, strong) DefaultLabel *lbForm;
@property(nonatomic, strong) TeamFormView *homeForm;
@property(nonatomic, strong) TeamFormView *awayForm;
@property(nonatomic, strong) MatchViewModel *viewModel;
@end

@implementation PreMatchView {
    CGFloat sectionTopMargin;
    CGFloat dataOffset;
    CGFloat coachFlagSize;
}

- (id)initWithViewModel:(MatchViewModel *)viewModel {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;

        [self addSubviews];
        [self defineLayout];
        [self updateData];
    }

    return self;
}

- (void)updateData {
    Match *match = self.viewModel.model;

    self.lbForm.text = @"FORM";
    [self.homeForm setData:match.home.form];
    [self.awayForm setData:match.away.form];
/*
    self.refereeSectionLabel.text = @"Referee";
    self.refereeLabel.text = match.referee;

    self.venueSectionLabel.text = @"Venue";
    self.venueLabel.text = match.venue;

    if (match.h2h.count > 0) {
        self.prevMeetingsSectionLabel.text = @"Previous Meetings";
        [self.lastMatchesTable reloadData];
        [self.lastMatchesTable setTableHeightBasedOnScrollView];
    }

    self.homeCoachLabel.text = match.home.coach[@"name"];
    self.homeCoachFlag.image = [UIImage imageNamed:match.home.coach[@"country"]];

    self.awayCoachLabel.text = match.away.coach[@"name"];
    self.awayCoachFlag.image = [UIImage imageNamed:match.away.coach[@"country"]];

    self.coachesSectionLabel.text = @"Coaches";
 */
}

- (void)addSubviews {
    self.lbForm                   = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor secondaryTextColor]];
    self.homeForm                 = [[TeamFormView alloc] init];
    self.awayForm                 = [[TeamFormView alloc] init];
/*
    self.coachesSectionLabel      = [DefaultLabel initWithColor:[UIColor hx_colorWithHexString:@"95a5a5"]];
    self.homeCoachLabel           = [DefaultLabel init];
    self.homeCoachFlag            = [[DefaultImageView alloc] init];
    self.awayCoachLabel           = [DefaultLabel init];
    self.awayCoachFlag            = [[DefaultImageView alloc] init];

    self.venueSectionLabel        = [DefaultLabel initWithColor:[UIColor hx_colorWithHexString:@"95a5a5"]];
    self.venueLabel               = [DefaultLabel initWithAlignment:NSTextAlignmentCenter];
    self.venueLabel.numberOfLines = 0;

    self.refereeSectionLabel      = [DefaultLabel initWithColor:[UIColor hx_colorWithHexString:@"95a5a5"]];
    self.refereeSectionLabel.numberOfLines = 0;
    self.refereeLabel             = [DefaultLabel init];

    self.prevMeetingsSectionLabel = [DefaultLabel initWithColor:[UIColor hx_colorWithHexString:@"95a5a5"]];
    self.prevMeetingsSectionLabel.numberOfLines = 0;
*/
    [self addSubview:self.lbForm];
    [self addSubview:self.homeForm];
    [self addSubview:self.awayForm];
/*
    [self addSubview:self.coachesSectionLabel];
    [self addSubview:self.homeCoachLabel];
    [self addSubview:self.homeCoachFlag];
    [self addSubview:self.awayCoachLabel];
    [self addSubview:self.awayCoachFlag];
    [self addSubview:self.venueSectionLabel];
    [self addSubview:self.venueLabel];
    [self addSubview:self.refereeSectionLabel];
    [self addSubview:self.refereeLabel];
    [self addSubview:self.prevMeetingsSectionLabel];
    [self addSubview:self.lastMatchesTable];
 */
}

- (void)defineLayout {
    /*
    sectionTopMargin = 25.f;
    dataOffset = 8.f;
    coachFlagSize = 20.f;

    NSArray *centerViews = @[
        self.coachesSectionLabel,
        self.venueSectionLabel,
        self.venueLabel,
        self.refereeSectionLabel,
        self.refereeLabel,
        self.prevMeetingsSectionLabel,
        self.lastMatchesTable
    ];

    [centerViews mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];*/
    
    // FORM label
    [self.lbForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];

    // Team form
    [@[self.homeForm, self.awayForm] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbForm.mas_centerY);
        make.width.equalTo(@125);
        make.height.equalTo(@25);
    }]; 

    [self.homeForm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lbForm).offset(-60);
    }];

    [self.awayForm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbForm).offset(65);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lbForm).offset(60);
    }];
/*
    // Coaches
    CGFloat coachCenterOffset = 15.f;
    CGFloat coachTextOffset = 8.f;

    [self.coachesSectionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeForm).offset(25);
    }];

    [self.homeCoachFlag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachesSectionLabel.mas_bottom);
        make.centerX.equalTo(self).offset(-coachCenterOffset);
    }];

    [self.homeCoachLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.homeCoachFlag);
        make.right.equalTo(self.homeCoachFlag.mas_left).offset(-coachTextOffset);
    }];

    [self.awayCoachFlag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachesSectionLabel.mas_bottom);
        make.centerX.equalTo(self).offset(coachCenterOffset);
    }];

    [self.awayCoachLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.awayCoachFlag);
        make.left.equalTo(self.awayCoachFlag.mas_right).offset(coachTextOffset);
    }];

    // Venue
    [self.venueSectionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeCoachLabel.mas_bottom);
    }];

    [self.venueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.venueSectionLabel.mas_bottom);
        make.width.equalTo(self).offset(-40);
    }];

    // Referee
    [self.refereeSectionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.venueLabel.mas_bottom);
    }];

    [self.refereeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refereeSectionLabel.mas_bottom);
    }];

    // Past Meetings table
    [self.prevMeetingsSectionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refereeLabel.mas_bottom).offset(sectionTopMargin);
    }];

    [self.lastMatchesTable mas_updateConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.prevMeetingsSectionLabel.mas_bottom).offset(dataOffset);
       make.width.equalTo(self);
    }];

    // Set height to same a content inside the view
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self.lastMatchesTable.mas_bottom);
    }];

    [self.refereeSectionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.venueLabel.mas_bottom).offset(sectionTopMargin);
    }];

    [self.refereeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refereeSectionLabel.mas_bottom).offset(dataOffset);
    }];

    [self.venueSectionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeCoachLabel.mas_bottom).offset(sectionTopMargin);
    }];

    [self.venueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.venueSectionLabel.mas_bottom).offset(dataOffset);
    }];

    [self.coachesSectionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeForm).offset(sectionTopMargin+25);
    }];

    [@[self.homeCoachFlag, self.awayCoachFlag] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachesSectionLabel.mas_bottom).offset(dataOffset);
        make.size.equalTo(@(coachFlagSize));
    }];
 */
}
/*
#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.model.h2h.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterMatchCell *cell = (CenterMatchCell *)[tableView dequeueReusableCellWithIdentifier:@"prevMeeting" forIndexPath:indexPath];
    Match *match = self.viewModel.model.h2h[(NSUInteger)indexPath.row];
    [cell setData:match];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Match *match = self.viewModel.model.h2h[(NSUInteger)indexPath.row];

    if (match.objectId) {
        DefaultSubscriptionViewController *subscriptionViewControllerWithMatchPageViewController = [[[MatchPageViewController alloc] initWithMatch:match] wrapInSubscriptionViewController];
        [self.parentViewController.navigationController pushViewController:subscriptionViewControllerWithMatchPageViewController animated:YES];
    }
}

#pragma mark - Views
- (DefaultTableView *)lastMatchesTable {
    if (!_lastMatchesTable) {
        _lastMatchesTable = [[DefaultTableView alloc] initWithDelegate:self];
        _lastMatchesTable.dataSource = self;
        _lastMatchesTable.scrollEnabled = NO;
        [_lastMatchesTable registerClass:[CenterMatchCell class] forCellReuseIdentifier:@"prevMeeting"];
    }

    return _lastMatchesTable;
}
*/
@end
