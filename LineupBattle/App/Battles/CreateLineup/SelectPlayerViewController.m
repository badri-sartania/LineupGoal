//
// Created by Anders Borre Hansen on 16/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
//#import "SCLAlertView-Objective-C/SCLAlertView.h"
#import "SCLAlertView.h"
#import "SelectPlayerViewController.h"
#import "TeamTableSectionView.h"
#import "TeamTableCellView.h"
#import "PlayersHelper.h"
#import "TeamCollectionViewCell.h"
#import "BattleHelper.h"
#import "Match.h"
#import "PlayerViewController.h"
#import "DefaultImageView.h"
#import "Utils.h"
#import "ForceTouchGestureRecognizer.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"

@interface SelectPlayerViewController ()
@property(nonatomic, strong) BattleTemplateViewModel *viewModel;
@property(nonatomic, strong) NSArray *selectedPlayers;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) InfiniteScrollView *infiniteScrollView;
@property(nonatomic, strong) Team *currentTeam;
@property(nonatomic, strong) NSDictionary *selectPlayerStructure;
@property(nonatomic) NSUInteger currentOffset; // InfiniteScrollView offset
@property(nonatomic) NSUInteger lastTeamOffset; // Team array offset
@property(nonatomic) NSUInteger teamCount;
@property(nonatomic, strong) Player *currentPlayer;

@property(nonatomic, strong) UIView *navigationBar;

@end

static NSInteger navigationBarHeight = 64;

@implementation SelectPlayerViewController

- (id)initWithViewModel:(BattleTemplateViewModel *)viewModel positionType:(NSString *)positionType lastTeamOffset:(NSUInteger)lastTeamOffset positionPlayer:(Player *)player {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;
        self.navigationItem.title = [NSString stringWithFormat:@"Select %@", [BattleHelper playerPositionNameByPositionType:positionType]];
        self.positionType = positionType;
        self.selectPlayerStructure = viewModel.selectPlayerStructure;
        self.selectedPlayers = viewModel.lineup.players;
        self.currentOffset = lastTeamOffset + 1; // To put it in second position
        self.currentTeam = self.viewModel.teamsInMatchOrder[self.currentOffset];
        self.lastTeamOffset = lastTeamOffset;
        self.playersPerTeam = [viewModel.model.perTeam integerValue] ?: 2;
        self.teamCount = self.viewModel.teamsInMatchOrder.count;
        self.currentPlayer = player;
    }

    return self;
}

- (Team *)teamForIndex:(NSUInteger)index {
    Team *team = self.viewModel.teamsInMatchOrder[index];
    NSDictionary *teamDic = self.viewModel.selectPlayerStructure[team.objectId];
    return teamDic[@"team"];
}

- (NSArray *)playerPositionsForTeamId:(NSString *)teamId position:(NSString *)position {
    NSDictionary *teamDic = self.viewModel.selectPlayerStructure[teamId];
    NSDictionary *positions = teamDic[@"playersByPosition"];
    return positions[position];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TeamTableCellView class] forCellReuseIdentifier:@"player"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor hx_colorWithHexString:@"ff0000"];

    [self setupTableFooter];

    UIView *calendarView = [[UIView alloc] init];
    calendarView.backgroundColor = [UIColor hx_colorWithHexString:@"#ecf0f1"];
    UIView *selectionColorView = [[UIView alloc] initWithFrame:CGRectMake([TeamCollectionViewCell width] + 0.5f, 0.f, [TeamCollectionViewCell width] - 0.5f, [TeamCollectionViewCell height] + 1.f)];
    selectionColorView.backgroundColor = [UIColor whiteColor];
    [calendarView addSubview:selectionColorView];

    self.infiniteScrollView = [[InfiniteScrollView alloc] initWithCellWidth:75];
    self.infiniteScrollView.delegate = self;
    self.infiniteScrollView.dataSource = self;
    [self.infiniteScrollView registerClass:[TeamCollectionViewCell class] forCellWithReuseIdentifier:@"teamCell"];

    [self.view addSubview:calendarView];
    [self.view addSubview:self.infiniteScrollView];
    [self.view addSubview:self.tableView];

    NSNumber *calendarHeight = @92;

    [@[calendarView, self.infiniteScrollView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(calendarHeight);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset([calendarHeight floatValue]);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}


#pragma mark - Setup UI
- (void)setupNavigationBar {
    // Setup navigation bar
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], navigationBarHeight)];
    [self.navigationBar setBackgroundColor:[UIColor hx_colorWithHexString:@"34495e"]];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(navigationBarHeight);
    }];
    
    UILabel *navTitle = [[UILabel alloc] init];
    [navTitle setText:@"PICK PLAYER"];
    navTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    navTitle.textColor = [UIColor whiteColor];
    [self.navigationBar addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar).offset(20);
        make.centerX.equalTo(self.navigationBar);
        make.height.mas_equalTo(@44);
    }];
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [navButton setImage:[UIImage imageNamed:@"ic_back"]
               forState:UIControlStateNormal];
    [navButton setContentMode:UIViewContentModeCenter];
    [navButton addTarget:self
                  action:@selector(goBack)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:navButton];
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBar);
        make.top.equalTo(self.navigationBar).offset(20);
        make.width.equalTo(@54);
        make.height.equalTo(@44);
    }];
}

- (void) setupTableFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0,0, [Utils screenWidth], 204)];
    
    UIImageView *icLineup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_in_lineup"]];
    UIImageView *icBench = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_on_bench"]];
    UIImageView *icNotInTeam = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_not_in_team"]];
    
    UIFont *icFont = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    UIColor *icColor = [UIColor hx_colorWithHexString:@"95A5A6"];
    
    UILabel *lblLineup = [[UILabel alloc] init];
    lblLineup.font = icFont;
    lblLineup.textColor = icColor;
    lblLineup.text = @"In lineup";
    
    UILabel *lblBench = [[UILabel alloc] init];
    lblBench.font = icFont;
    lblBench.textColor = icColor;
    lblBench.text = @"On bench";
    
    UILabel *lblNotTeam = [[UILabel alloc] init];
    lblNotTeam.font = icFont;
    lblNotTeam.textColor = icColor;
    lblNotTeam.text = @"Not in team";
    
    UIImageView *imgLongPress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_long_press"]];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    label.textColor = [UIColor hx_colorWithHexString:@"BDC3C7"];
    label.numberOfLines = 2;
    [label setTextAlignment:NSTextAlignmentCenter];
    if ([SDKTraits hasForceTouchForView:self.tableView]) {
        label.text = @"Force press for\n player profile";
    } else {
        label.text = @"Long press for\n player profile";
    }
    
    [footer addSubview:icLineup];
    [footer addSubview:lblLineup];
    [footer addSubview:icBench];
    [footer addSubview:lblBench];
    [footer addSubview:icNotInTeam];
    [footer addSubview:lblNotTeam];
    [footer addSubview:imgLongPress];
    [footer addSubview:label];
    
    [@[icLineup, icBench, icNotInTeam] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(10);
    }];
    [icLineup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(8.5);
    }];
    [icBench mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(28.5);
    }];
    [icNotInTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(48.5);
    }];
    
    [@[lblLineup, lblBench, lblNotTeam] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(32);
        make.height.equalTo(@15);
    }];
    [lblLineup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(10);
    }];
    [lblBench mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(30);
    }];
    [lblNotTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(50);
    }];
    
    [imgLongPress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(81);
        make.width.equalTo(@52);
        make.height.equalTo(@82);
        make.centerX.equalTo(footer);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgLongPress.mas_bottom);
        make.width.mas_equalTo([Utils screenWidth]);
        make.height.equalTo(@50);
        make.centerX.equalTo(footer);
    }];
    
    [self.tableView setTableFooterView:footer];
}

#pragma mark - Infinite Scroll View data source
- (UIView *)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView cellForItemAtOffset:(NSInteger)offset {
    TeamCollectionViewCell *cell = [infiniteScrollView dequeueReusableCellWithReuseIdentifier:@"teamCell" forOffset:offset];
    NSUInteger teamIndex = [self teamIndexWithOffset:offset];
    NSInteger homeOrAway = (NSInteger)fmodl(teamIndex, 2);
    Team *team = self.viewModel.teamsInMatchOrder[teamIndex];

    if (cell.tag != offset) {
        cell.tag = offset;
        [cell setTeam:team];

        if (homeOrAway == 1) {
            [cell addAwayTeamStyle];
        } else {
            [cell addHomeTeamStyle];
        }
    }

    NSInteger playerCount = [self.selectedPlayers bk_reduceInteger:0 withBlock:^NSInteger (NSInteger result, Player *player) {
        return [team.objectId isEqualToString:player.team.objectId] ? ++result : result;
    }];
    [cell setCount:playerCount];

    return cell;
}

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // If a user hinders the scroll view in snapping to a cell by pressing down while it's snapping,
    // but doesn't initiate a new scroll (i.e. just releasing the press), the scroll view stays
    // un-snapped. Let's handle that edge case.
    [self.infiniteScrollView snapToCell];
}

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Some times the cancelled event triggers even though we're still dragging the scroll view.
    // In that case we just ignore it as we don't want to snap while the user is dragging.
    if (!infiniteScrollView.dragging)
        // If a user hinders the scroll view in snapping to a cell by pressing down while it's snapping,
        // but doesn't initiate a new scroll (i.e. just releasing the press), the scroll view stays
        // un-snapped. Let's handle that edge case.
        [self.infiniteScrollView snapToCell];
}

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView didSelectItemAtOffset:(NSInteger)offset {
    [self.infiniteScrollView scrollToOffset:offset animated:YES];

    NSUInteger teamIndex = [self teamIndexWithOffset:offset];
    
    self.currentOffset = teamIndex;

    Team *team = [self teamForIndex:teamIndex];
    [self setNewTeam:team];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // if decelerate is YES, we don't need to take care of it here.
    // It will instead be handled in `scrollViewDidEndDecelerating:`
    if (!decelerate) {
        [self.infiniteScrollView snapToCell];
        TeamCollectionViewCell *cell = [self.infiniteScrollView objectAtVisibleIndex:1];
        [self setNewTeam:cell.team];

        NSUInteger offset = [self.viewModel.teamsInMatchOrder indexOfObject:cell.team];

        self.currentOffset = offset;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.x != 0.f) {
        CGFloat unguidedOffset = targetContentOffset->x;
        CGFloat guidedOffset;
        CGFloat cellWidth = 75;
        CGFloat remainder = fmodf(unguidedOffset, cellWidth);

        if (remainder < cellWidth / 2.f) {
            guidedOffset = unguidedOffset - remainder;
        } else {
            guidedOffset = unguidedOffset - remainder + cellWidth;
        }

        targetContentOffset->x = guidedOffset;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    TeamCollectionViewCell *cell = [self.infiniteScrollView objectAtVisibleIndex:1];

    if (!cell) {
        NSLog(@"no cell");
        return;
    }
    [self setNewTeam:cell.team];

    NSUInteger offset = [self.viewModel.teamsInMatchOrder indexOfObject:cell.team];

    self.currentOffset = offset;
}

#pragma mark - Scrollview helpers
- (void)setNewTeam:(Team *)currentTeam {
    self.currentTeam = currentTeam;
    [self.tableView reloadData];
}

- (NSUInteger)teamIndexWithOffset:(NSInteger)offset {
    NSInteger uOffset = offset + self.lastTeamOffset;

    if (uOffset < 0) {
        uOffset = (NSInteger)(fmod(uOffset, self.teamCount) + self.teamCount);
    }

    NSUInteger teamIndex = (NSUInteger)fmod(uOffset, self.teamCount);

    return teamIndex;
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TeamTableSectionView *sectionView = [[TeamTableSectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 35.f)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
//    [sectionView setHeadlineText:self.currentTeam.name];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self playerPositionsForTeamId:self.currentTeam.objectId position:self.positionType].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamTableCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"player" forIndexPath:indexPath];

    if (cell.tag != 1) {
        [cell setupCell];
        cell.tag = 1;

        if ([SDKTraits hasForceTouchForView:cell]) {
            ForceTouchGestureRecognizer *forceGesture = [[ForceTouchGestureRecognizer alloc] initWithTarget:self action:@selector(forceTouched:)];
            forceGesture.forceSensitivity = 0.5;
            [cell addGestureRecognizer:forceGesture];
        } else {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressCell:)];
            [cell addGestureRecognizer:longPress];
        }

        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];

        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [singleTap requireGestureRecognizerToFail:doubleTap];

        [cell addGestureRecognizer:singleTap];
        [cell addGestureRecognizer:doubleTap];
    }

    Player *player = [self playerForIndexPath:indexPath];

    [cell setData:player];
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor lightBackgroundColor]];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }

    if ([_selectedPlayers containsObject:player]) {
        [cell setAsDisabled];
    }

    return cell;
}

- (void)forceTouched:(UIGestureRecognizer *)gesture {
    TeamTableCellView *cell = ((TeamTableCellView *)gesture.view);
    [self gestureAction:cell];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    TeamTableCellView *cell = ((TeamTableCellView *)gesture.view);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    cell.highlighted = YES;
	[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)didLongPressCell:(UIGestureRecognizer *)gesture {
	TeamTableCellView *cell = ((TeamTableCellView *)gesture.view);

    BOOL isBeganGesture = gesture.state == UIGestureRecognizerStateBegan;
    [cell setHighlighted:isBeganGesture animated:YES];

    if (!isBeganGesture) return;
    [self gestureAction:cell];
}

- (void)gestureAction:(TeamTableCellView *)cell {
    Player *player = cell.player;
    PlayerViewModel *viewModel = [[PlayerViewModel alloc] initWithPlayer:player];
    PlayerViewController *playerViewController = [[PlayerViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:playerViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player = [self playerForIndexPath:indexPath];

    BOOL playerAllReadyChoosen = [[self.selectedPlayers bk_map:^id(Player* player) {
        return player.objectId;
    }] containsObject:player.objectId];

    if (playerAllReadyChoosen && player.objectId != self.currentPlayer.objectId) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = FadeIn;
        [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
        [alert addButton:@"Okay" actionBlock:^() {
            [self.tableView cellForRowAtIndexPath:indexPath].highlighted = NO;
        }];
        [alert showNotice:self title:@"Player already in lineup " subTitle:@"You have already added this player to your lineup" closeButtonTitle:nil duration:0];

    } else if (![self.delegate selectedPlayer:player forTeam:self.currentTeam offset:self.currentOffset - 1]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = FadeIn;
        [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
        [alert addButton:@"Okay" actionBlock:^() {
            [self.tableView cellForRowAtIndexPath:indexPath].highlighted = NO;
        }];
        [alert showNotice:self title:[NSString stringWithFormat:@"%li player team limit", (long)self.playersPerTeam]  subTitle:[NSString stringWithFormat:@"You can only choose %li players per team", (long)self.playersPerTeam] closeButtonTitle:nil duration:0];
    }
}

#pragma mark - IndexPath helpers
- (Player *)playerForIndexPath:(NSIndexPath *)indexPath {
    NSArray *players = [self playerPositionsForTeamId:self.currentTeam.objectId position:self.positionType];
    Player *player = players[(NSUInteger)indexPath.row];

    return player;
}

@end
