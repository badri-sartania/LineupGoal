//
//  LeagueTableViewController.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 03/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "Crashlytics.h"
#import "LeagueTableViewController.h"
#import "LeagueCellView.h"
#import "LeagueTableSectionView.h"
#import "TeamViewController.h"
#import "SimpleTableSectionView.h"
#import "ExplainCellView.h"
#import "NSArray+BlocksKit.h"
#import "Competition.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"


@interface LeagueTableViewController ()
@property(nonatomic, strong) NSArray *trimmedGroupings;
@end

@implementation LeagueTableViewController

- (id)init {
    self = [super init];
    if (self) {
        @weakify(self);
        [[RACObserve(self, groupings) ignore:nil] subscribeNext:^(NSArray *groupings) {
            @strongify(self);

            if (self.groupings.count > 0) {
                self.trimmedGroupings = [groupings bk_select:^BOOL(Grouping *group) {
                    return group.teams.count > 0;
                }];

                NSArray *positionTypes = [self extractPositionTypesFromGroupings];

                [self.tableView.emptyStateView hideEmptyStateScreen];
                self.positionTypes = positionTypes;
            } else {
                [self.tableView enableEmptyState];
                [self.tableView.emptyStateView showEmptyStateScreen:@"No Table Avaliable"];
            }

            [self.tableView reloadData];
        }];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectCellSelection];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[DefaultTableView alloc] initWithDelegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSArray *)extractPositionTypesFromGroupings {
    NSMutableDictionary *positionTypes = [[NSMutableDictionary alloc] init];
    [self.trimmedGroupings bk_each:^(Grouping *grouping) {
        if (grouping.positionTypes) {
            NSDictionary *positionTypeObj = @{
              @"name": grouping.competition.name,
              @"types": grouping.positionTypes
            };
            NSString *init = grouping.competition.objectId ? grouping.competition.objectId : @"";
            NSString *key = [grouping.positionTypes bk_reduce:init withBlock:^NSString *(NSString *sum, NSDictionary *positionType) {
                NSArray *components = @[sum, positionType[@"id"], positionType[@"rgb"], positionType[@"name"]];
                return [components componentsJoinedByString:@"-"];
            }];
            positionTypes[key] = positionTypeObj;
        }

    }];
    return [positionTypes allValues];
}

#pragma mark - Section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect rect = CGRectMake(0.f, 0.f, tableView.frame.size.width, 50.f);

    if (section < self.trimmedGroupings.count) {
        Grouping *grouping = self.trimmedGroupings[(NSUInteger) section];
        LeagueTableSectionView *sectionView = [[LeagueTableSectionView alloc] initWithFrame:rect];
        [sectionView setGrouping:grouping];
        return sectionView;
    } else {
        NSDictionary *positionTypeObj = self.positionTypes[(NSUInteger) section - self.trimmedGroupings.count];
        NSString *title = [[NSString stringWithFormat:@"Explanation for %@", positionTypeObj[@"name"]] uppercaseString];
        SimpleTableSectionView *sectionView = [[SimpleTableSectionView alloc] initWithFrame:rect];
        [sectionView setSectionDataWithTitle:title imageName:nil];
        return sectionView;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.trimmedGroupings.count + self.positionTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.trimmedGroupings.count) {
        Grouping *grouping = self.trimmedGroupings[(NSUInteger) section];
        return grouping.teams.count + 1;
    } else {
        NSDictionary *positionTypeObj = self.positionTypes[(NSUInteger) section - self.trimmedGroupings.count];
        NSArray *positionTypes = positionTypeObj[@"types"];
        return positionTypes.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.trimmedGroupings.count) {
        Grouping *grouping = self.trimmedGroupings[(NSUInteger) indexPath.section];
        if (indexPath.row == grouping.teams.count) {
            return 145.0f;
        }
    }
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier;

    if (indexPath.section < self.trimmedGroupings.count) {
        Grouping *grouping = self.trimmedGroupings[(NSUInteger) indexPath.section];
        if (indexPath.row == grouping.teams.count) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 145)];
            UIView *contentView = cell.contentView;
            NSArray *standingInfoList = @[
                                      @{@"color" : [UIColor championsLeagueColor], @"text" : @"Champions League"},
                                      @{@"color" : [UIColor championsLeagueQualificationColor], @"text" : @"Champions League Qualification"},
                                      @{@"color" : [UIColor europaLeagueColor], @"text" : @"Europa League"},
                                      @{@"color" : [UIColor relegationColor], @"text" : @"Relegation"},
                                      ];
            int index = 1;
            for (NSDictionary *standingInfo in standingInfoList) {
                UIView *standing = UIView.new;
                [standing setBackgroundColor:standingInfo[@"color"]];
                DefaultLabel *label = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
                [label setText:standingInfo[@"text"]];
                [contentView addSubview:standing];
                [contentView addSubview:label];
                
                [standing mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(contentView);
                    make.top.equalTo(contentView).offset(index * 23);
                    make.width.equalTo(@4);
                    make.height.equalTo(@22);
                }];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(standing.mas_centerY);
                    make.left.equalTo(contentView).offset(15);
                }];
                
                index++;
            }
            return cell;
        } else {
            Team *team = grouping.teams[(NSUInteger)indexPath.row];
            NSString *color = [grouping colorByType:team.type];
            
            CellIdentifier = [NSString stringWithFormat:@"team-%@", color];
            LeagueCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil) {
                cell = [[LeagueCellView alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
            }
            
            [cell setData:team color:color position:indexPath.row];
            
            return cell;
        }
    } else {
        NSDictionary *positionTypeObj = self.positionTypes[(NSUInteger) indexPath.section - self.trimmedGroupings.count];
        NSArray *positionTypes = positionTypeObj[@"types"];
        CellIdentifier = @"Explain";
        ExplainCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[ExplainCellView alloc] initWithStyle:0 reuseIdentifier:CellIdentifier];
        }
        [cell setData:positionTypes[(NSUInteger)indexPath.row]];

        return cell;
    }
}

#pragma mark - Events
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Grouping *grouping = self.trimmedGroupings[(NSUInteger) indexPath.section];
    if (indexPath.row >= grouping.teams.count) {
        return;
    }
    
    Team *team = grouping.teams[(NSUInteger) indexPath.row];

    CLS_LOG(@"Team: %@", team.objectId);

    TeamViewController *teamViewController = [[TeamViewController alloc] initWithTeam:team];
    [self.navigationController pushViewController:teamViewController animated:YES];

    [[Mixpanel sharedInstance] track:@"Team" properties:@{
            @"id": team.objectId ?: [NSNull null],
            @"name": team.name ?: [NSNull null],
            @"origin": @"league table"
    }];
}

- (NSArray *)extractGroupingsForTeam:(NSString *)teamObjectId competitions:(NSArray *)competitions {
    if (!competitions) return @[];

    NSMutableArray *groupings = [[NSMutableArray alloc] init];
    [competitions bk_each:^(Competition *competition) {
        [groupings addObjectsFromArray:[competition.groupings bk_select:^BOOL(Grouping *grouping) {
            for (Team *team in grouping.teams) {
                if ([team.objectId isEqualToString:teamObjectId]) {
                    return YES;
                }
            }
            return NO;
        }]];
    }];

    return groupings;
}

@end
