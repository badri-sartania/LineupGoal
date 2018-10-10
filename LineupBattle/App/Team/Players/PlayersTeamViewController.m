//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "Crashlytics.h"
#import "PlayersTeamViewController.h"
#import "TeamTableCellView.h"
#import "TeamTableSectionView.h"
#import "PlayerViewController.h"
#import "DefaultTableView.h"
#import "PlayersHelper.h"

@interface PlayersTeamViewController ()
    @property (nonatomic, strong) DefaultTableView *tableView;
@end

@implementation PlayersTeamViewController

- (id)initWithViewModel:(TeamViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;

        [self updateData];
    }
    return self;
}

- (void)updateData {
    self.players = [PlayersHelper sortPlayers:self.viewModel.team.players];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectCellSelection];
}

- (void)viewDidLoad {
      [super viewDidLoad];
      [self.view addSubview:self.tableView];
      [self defineLayout];
}

- (void)defineLayout {
    UIView *superview = self.view;

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - Table View Section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TeamTableSectionView *sectionView = [[TeamTableSectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 30.f)];
    return sectionView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.players.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Player Cell";
    TeamTableCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Player *player = self.players[(NSUInteger)indexPath.row];

    if(cell == nil) {
        cell = [[TeamTableCellView alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        [cell setupCell];
    }

    [cell setData:player];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player = self.players[(NSUInteger)indexPath.row];

    if (player) {
        CLS_LOG(@"Player: %@", player.objectId);

        PlayerViewController *playerViewController = [PlayerViewController initWithPlayer:player];

        [[Mixpanel sharedInstance] track:@"Player" properties:@{
            @"id": player.objectId ?: [NSNull null],
            @"name": player.name ?: [NSNull null],
            @"from": @"team"
        }];

        [self.navigationController pushViewController:playerViewController animated:YES];
    }
}


#pragma mark - Views
- (DefaultTableView *)tableView {
    if(!_tableView) {
        // Init and something I don't know what do good for
        _tableView = [[DefaultTableView alloc] initWithDelegate:self];
        _tableView.dataSource = self;
        [_tableView enableRefreshControl];
    }

    return _tableView;
}

#pragma mark - Events
- (void)refreshTable {
    [self.viewModel fetchDetailsCatchError:NO success:^{
        [self.tableView stopSpinner];
    }];
}

@end
