//
// Created by Anders Borre Hansen on 16/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "Crashlytics.h"
#import "EventMatchViewController.h"
#import "MatchTopView.h"
#import "EventMatchCellView.h"
#import "PlayerViewModel.h"
#import "PlayerViewController.h"
#import "DefaultTableView.h"
#import "PreMatchView.h"
#import "SplitterEventCellView.h"
#import "CenterTextCellView.h"
#import "SimpleLocale.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"


@interface EventMatchViewController ()
@property(nonatomic, strong) MatchTopView *matchTopView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) DefaultTableView *tableView;
@property(nonatomic, strong) PreMatchView *preMatchView;
@property(nonatomic, strong) MatchViewModel *viewModel;
@property(nonatomic, strong) UIView *sizingView;
@property(nonatomic, strong) DefaultLabel *eventFooterView;
@end

@implementation EventMatchViewController

- (id)initWithViewModel:(MatchViewModel *)matchViewModel {
    self = [super init];

    if (self) {
        self.viewModel = matchViewModel;
        [self.tableView startSpinner];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectCellSelection];
//    [self.preMatchView.lastMatchesTable deselectCellSelection];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.matchTopView];
    self.matchTopView.viewController = self;

    // Subviews
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    self.contentView = UIView.new;
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.eventFooterView];
    [self.contentView addSubview:self.preMatchView];

    // Layout
    [self defineMASLayout];

    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.refreshControl];

    // Spinner
    self.spinner = [Spinner initWithSuperView:self.contentView];
    [self.spinner startAnimating];
    [self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(140);
        make.size.equalTo(@30);
    }];

    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
//    self.sizingView = UIView.new;
//    [self.scrollView addSubview:self.sizingView];
//    [self updateContentHeight];
}

// Will determine the height of contentView and insert into scrollView
- (void)updateContentHeight {
    [self.sizingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.preMatchView.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)defineMASLayout {
    NSNumber *topHeight = @140;

    UIView *superView = self.contentView;

    // Top Views
    [self.matchTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(@([Utils screenWidth]));
        make.height.equalTo(topHeight);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(self.matchTopView.frame.size.height, 0, 0, 0));
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];

    [@[self.tableView, self.preMatchView, self.eventFooterView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.width.equalTo(superView);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
    }];

    [self.eventFooterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(20);
        make.width.equalTo(@150);
        make.height.equalTo(@60);
    }];

    [self.preMatchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventFooterView.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - Bindings and Data Update
- (void)updateView {

    if (self.viewModel.model.isNotStartedYet) {
        self.eventFooterView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        self.eventFooterView.text = [NSString stringWithFormat:@"KICK OFF AT %@\n%@", [self.viewModel.model kickOffTime], [self.viewModel.model weekDay]];
    } else {
        self.eventFooterView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        self.eventFooterView.text = @"KICK OFF";
    }

    [self.matchTopView updateViews];
    [self.preMatchView updateData];

    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([self calculateTableViewHeight]));
    }];

    [self.spinner stopAnimating];
}

- (CGFloat)calculateTableViewHeight {
    CGFloat height = 0;
    for (int i = 0; i < self.viewModel.events.count; i++) {
        Event *event = self.viewModel.events[(NSUInteger)i];
        if (event.isFullTime) {
            height += 24 + 27.5 + 18.5;
        } else if ([event.type isEqualToString:@"halftime"]){
            height += 24 + 20 + 20;
        } else if (event.isGoal || event.isAssistEvent) {
            height += 5 + 33 + 12.5;
        } else height += 58.0f;
    }
    
    return height;
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.events.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.viewModel.events.count > 1) {
        Event *event = self.viewModel.events[(NSUInteger)indexPath.row];
        if (event.isFullTime) {
            return 24 + 27.5 + 18.5;
        } else if ([event.type isEqualToString:@"halftime"]){
            return 24 + 20 + 20;
        } else if (event.isGoal || event.isAssistEvent) {
            return 5 + 33 + 12.5;
        }
    }
    return 58.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *eventCellType;
    Event *event;

    if(self.viewModel.events.count > 1) {
        event = self.viewModel.events[(NSUInteger)indexPath.row];
    }

    if (event.isFullTime) {
        return [self getTextCell:@"FULL TIME"];
    } else if ([event.type isEqualToString:@"halftime"]) {
        SplitterEventCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"halftime"];
        
        if (!cell) {
            cell = [[SplitterEventCellView alloc] init];
            cell.splitterText.text = @"HALF TIME";
        }

        return cell;
//        return [self getSplitterCellWithString:@"HALF TIME"];
    } else if ([event.type isEqualToString:@"extratime1"]) {
        CenterTextCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"extratime1"];

        if (!cell) {
            cell = [[CenterTextCellView alloc] init];
            cell.userInteractionEnabled = NO;
//            cell.centerTextLabel.text = [NSString stringWithFormat:@"The %@ goes into extra time", [SimpleLocale USAlternative:@"game" forString:@"match"]];
            cell.centerTextLabel.text = @"EXTRA HALF";
        };

        return cell;
    } else if ([event.type isEqualToString:@"extratime2"]) {
        CenterTextCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"extratime2"];

        if (!cell) {
            cell = [[CenterTextCellView alloc] init];
            cell.userInteractionEnabled = NO;
            cell.centerTextLabel.text = @"PAUSE";
        }

        return cell;
    } else if ([event.type isEqualToString:@"penaltyShootout"]) {
        CenterTextCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"penaltyShootout"];
        
        if (!cell) {
            cell = [[CenterTextCellView alloc] init];
            cell.userInteractionEnabled = NO;
            cell.centerTextLabel.text = @"PENALTY SHOOTOUT";
        }
        
        return cell;
    } else {
        eventCellType = event.cellName;

        EventMatchCellView *cell = [tableView dequeueReusableCellWithIdentifier:eventCellType];

        if(cell == nil) {
            cell = [[EventMatchCellView alloc] initWithStyle:0 reuseIdentifier:eventCellType];
            [cell defineLayout:event];
        }

        [cell setupEvent:event];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = self.viewModel.events[(NSUInteger)indexPath.row];
    Player *player = event.playerInFocus;

    if (player) {
        PlayerViewModel *viewModel = [[PlayerViewModel alloc] initWithPlayer:player];
        PlayerViewController *playerViewController = [[PlayerViewController alloc] initWithViewModel:viewModel];

        CLS_LOG(@"Player: %@", player.objectId);

        [[Mixpanel sharedInstance] track:@"Player" properties:@{
            @"id": player.objectId ?: [NSNull null],
            @"name": player.name ?: [NSNull null],
            @"from": @"team"
        }];

        [self.navigationController pushViewController:playerViewController animated:YES];
    }
}

#pragma mark - TableView Other
- (void)refreshTable {
    // Stop load spinner if refresh spinner starts
    [self.spinner stopAnimating];

    [[self.viewModel fetchMatchDetailsSignal] subscribeError:^(NSError *error) {
        [self stopSpinners];
    } completed:^{
        [self stopSpinners];
    }];
}

- (void)stopSpinners {
    [self.refreshControl endRefreshing];
    [self.spinner stopAnimating];
}

#pragma mark - Views

- (UITableViewCell *)getSplitterCellWithString:(NSString *)string {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    }
    
    DefaultLabel *label = [DefaultLabel initWithBoldSystemFontSize:20 color:[UIColor primaryTextColor]];
    [label setText:string];
    label.numberOfLines = 0;
    [label sizeToFit];
    [cell.contentView addSubview:label];
    
    UIView *leftSplitter = UIView.new;
    UIView *rightSplitter = UIView.new;
    [leftSplitter setBackgroundColor:[UIColor lightBorderColor]];
    [rightSplitter setBackgroundColor:[UIColor lightBorderColor]];
    [cell.contentView addSubview:leftSplitter];
    [cell.contentView addSubview:rightSplitter];
    
    [@[label, leftSplitter, rightSplitter] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.centerY.equalTo(cell.contentView);
    }];
    
    [leftSplitter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView);
        make.right.equalTo(label).offset(-10);
        make.height.equalTo(@3);
    }];
    
    [rightSplitter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label).offset(10);
        make.right.equalTo(cell.contentView);
        make.height.equalTo(@3);
    }];
    
    return cell;
}

- (UITableViewCell *)getTextCell:(NSString *)string {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 24 + 27.5 + 18.5)];
    }
    
    DefaultLabel *label = [DefaultLabel initWithBoldSystemFontSize:20 color:[UIColor primaryTextColor]];
    [label setText:string];
    [cell.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.top.equalTo(@18.5);
    }];
    
    return cell;
}

- (MatchTopView *)matchTopView {
    if(!_matchTopView) {
        _matchTopView = [[MatchTopView alloc] initWithViewModel:self.viewModel frame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
    }

    return _matchTopView;
}

- (DefaultTableView *)tableView {
    // Init and something I don't know what do good for
    if (!_tableView) {
        _tableView = [[DefaultTableView alloc] initWithDelegate:self];
        _tableView.dataSource = self;
    }

    return _tableView;
}

- (DefaultLabel *)eventFooterView {
    if (!_eventFooterView) {
        _eventFooterView = [DefaultLabel initWithBoldSystemFontSize:20 color:[UIColor primaryColor]];
        _eventFooterView.text = @"KICK OFF";
        _eventFooterView.textAlignment = NSTextAlignmentCenter;
        _eventFooterView.numberOfLines = 2;
    }

    return _eventFooterView;
}

- (PreMatchView *)preMatchView {
    if (!_preMatchView) {
        _preMatchView = [[PreMatchView alloc] initWithViewModel:self.viewModel];
        _preMatchView.parentViewController = self;
    }

    return _preMatchView;
}

@end
