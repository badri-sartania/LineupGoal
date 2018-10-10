//
// Created by Anders Borre Hansen on 17/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "Crashlytics.h"
#import "LineupMatchViewController.h"
#import "TeamTableCellView.h"
#import "TeamTableSectionView.h"
#import "SimpleTableSectionView.h"
#import "PlayerViewController.h"
#import "ImageTextViewCell.h"
#import "PlayerSectionView.h"
#import "FieldPlayerView.h"
#import "Utils.h"
#import "Event.h"
#import "UIColor+LineupBattle.h"

typedef NS_ENUM(NSInteger, LineupEventType)
{
    GOAL,
    PS_GOAL,
    OWN_GOAL,
    MISSED_PENALTY,
    SUBSTITUTION,
    YELLOW_CARD,
    YELLOW_CARD_AGAIN,
    RED_CARD,
    ASSIST,
};

#define lineupEventString(eventType) [@[@"goal", @"ps-goal", @"own-goal", @"missed-penalty", @"substitution", @"yellow-card", @"2nd-yellow-card", @"red-card", @"assist"] objectAtIndex:eventType]

@interface LineupMatchViewController ()
@property(nonatomic, strong) FieldView *fieldViewHome;
@property(nonatomic, strong) FieldView *fieldViewAway;
@property(nonatomic, strong) MatchViewModel *matchViewModel;
@property(nonatomic, strong) PlayerSectionView *awayFormationView;
@property(nonatomic, strong) PlayerSectionView *homeFormationView;
@end

@implementation LineupMatchViewController
- (id)initWithViewModel:(MatchViewModel *)matchViewModel {
    self = [super init];

    if (self) {
        self.matchViewModel = matchViewModel;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.tableView registerClass:[ImageTextViewCell class] forCellReuseIdentifier:@"playerCell"];
        [self.tableView setSeparatorColor:[UIColor clearColor]];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], (340.f*2.f)+(30.f*2.f))];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field"]];

    [headerView addSubview:imageView];
    [headerView addSubview:self.homeFormationView];
    [headerView addSubview:self.fieldViewHome];
    [headerView addSubview:self.fieldViewAway];
    [headerView addSubview:self.awayFormationView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30));
        make.centerX.equalTo(headerView);
        make.width.equalTo(@([Utils screenWidth] - 10));
        make.height.equalTo(@(683));
    }];

    self.tableView.tableHeaderView = headerView;

    [self updateView];
}

- (void)updateView {
    if (self.matchViewModel.model.homeSubstitutes || self.matchViewModel.model.awaySubstitutes) {
        self.homeSubstitutes = @{
            @"name": self.matchViewModel.model.home.name,
            @"substitutions": self.matchViewModel.model.homeSubstitutes
        };

        self.awaySubstitutes = @{
            @"name": self.matchViewModel.model.away.name,
            @"substitutions": self.matchViewModel.model.awaySubstitutes
        };

        if (self.matchViewModel.model.homeFormation) {
            NSString *formation = [self.matchViewModel.model.homeFormation componentsJoinedByString:@"-"];
            [self.homeFormationView setSectionLastText:formation];
        }

        if (self.matchViewModel.model.awayFormation) {
            NSString *formation = [self.matchViewModel.model.awayFormation componentsJoinedByString:@"-"];
            [self.awayFormationView setSectionLastText:formation];
        }

        [self reloadSubstitutes];
    }

    [self.fieldViewHome reloadData];
    [self.fieldViewAway reloadData];

    [self.homeFormationView setSectionTitle:[self.matchViewModel.model.home.name uppercaseString]];
    [self.awayFormationView setSectionTitle:[self.matchViewModel.model.away.name uppercaseString]];
}

- (void)reloadSubstitutes {
    if (!self.homeSubstitutes) self.homeSubstitutes = @{ @"name": self.matchViewModel.model.home.name, @"substitutes": @[] };
    if (!self.awaySubstitutes) self.awaySubstitutes = @{ @"name": self.matchViewModel.model.away.name, @"substitutes": @[] };

    self.substitutes = @[self.homeSubstitutes, self.awaySubstitutes];
    [self.tableView reloadData];
}

#pragma mark - Table View Section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *team = self.substitutes[(NSUInteger)section];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 60)];
    sectionView.backgroundColor = [UIColor whiteColor];
    DefaultLabel *sectionLabel = [DefaultLabel initWithBoldSystemFontSize:15 color:[UIColor primaryColor]];
    sectionLabel.text = [NSString stringWithFormat:@"%@ BENCH", [team[@"name"] uppercaseString]];
    [sectionView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView);
        make.centerY.equalTo(sectionView);
    }];
    return sectionView;
}

#pragma mark - Table Cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.substitutes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.substitutes[(NSUInteger) section][@"substitutions"]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ImageTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playercell"];
    }
    Player *player = self.substitutes[(NSUInteger) indexPath.section][@"substitutions"][(NSUInteger)indexPath.row];
    player.events = [self getPlayerEvents:player.objectId];
    [cell setData:player position:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player = self.substitutes[(NSUInteger) indexPath.section][@"substitutions"][(NSUInteger)indexPath.row];

    if (player) {
        CLS_LOG(@"Player: %@", player.objectId);

        PlayerViewController *playerViewController = [PlayerViewController initWithPlayer:player];

        [[Mixpanel sharedInstance] track:@"Player" properties:@{
            @"id": player.objectId ?: [NSNull null],
            @"name": player.name ?: [NSNull null],
            @"from": @"substitutions"
        }];

        [self.navigationController pushViewController:playerViewController animated:YES];
    }
}

#pragma mark - FieldView Delegate
- (CGFloat)fieldView:(FieldView *)fieldView marginBetweenItemsInSection:(NSInteger)section {
    if ([Utils screenWidth] <= 320) {
        return [self section:section fieldView:fieldView].count == 5 ? 4.f : 22.f;
    } else {
        return [self section:section fieldView:fieldView].count == 5 ? 15.f : 30.f;
    }
}

- (CGFloat)fieldView:(FieldView *)fieldView heightForSection:(NSInteger)section {
    return 60.f;
}

- (CGFloat)fieldView:(FieldView *)fieldView marginForSection:(NSInteger)section {
    NSInteger sectionCount = [self sectionCountForFieldView:fieldView];
    CGFloat heightForSections = sectionCount*60.f;
    CGFloat heightLeftForMargin = 340.f-heightForSections;

    return heightLeftForMargin/sectionCount;
}

- (void)fieldView:(FieldView *)fieldView didSelectFieldItemView:(FieldItemView *)fieldItemView {
    FieldPlayerView *fieldPlayerView = (FieldPlayerView *)fieldItemView;
    Player *player = fieldPlayerView.player;

    if (player) {
        CLS_LOG(@"Player: %@", player.objectId);

        [[Mixpanel sharedInstance] track:@"Player" properties:@{
            @"id": player.objectId ?: [NSNull null],
            @"name": player.name ?: [NSNull null],
            @"from": @"lineup"
        }];

        [self.navigationController pushViewController:[PlayerViewController initWithPlayer:player] animated:YES];
    }
}

#pragma mark - FieldView Data Source
- (FieldItemView *)fieldView:(FieldView *)fieldView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player = [self playerForIndexPath:indexPath fieldView:fieldView];
    player.events = [self getPlayerEvents:player.objectId];

    FieldPlayerView *fieldPlayerView = [FieldPlayerView initWithPlayer:player];

    return fieldPlayerView;
}

- (NSInteger)numberOfItemsForSectionInFieldView:(FieldView *)fieldView section:(NSInteger)section {
    return [self section:section fieldView:fieldView].count;
}

- (NSInteger)numberOfSectionsInFieldView:(FieldView *)fieldView {
    return [self sectionCountForFieldView:fieldView];
}

- (BOOL)fieldViewShouldBeReversed:(FieldView *)fieldView {
    return fieldView.tag == 1;
}

#pragma mark - Field Helpers
- (NSInteger)sectionCountForFieldView:(FieldView *)fieldView {
    if (fieldView.tag == 1) {
        return [self.matchViewModel formatedHomeLineup].count;
    } else {
        return [self.matchViewModel formatedAwayLineup].count;
    }
}

- (NSArray *)section:(NSInteger)section fieldView:(FieldView *)fieldView {
    if (fieldView.tag == 1) {
        return [self.matchViewModel formatedHomeLineup][(NSUInteger)section];
    } else {
        return [self.matchViewModel formatedAwayLineup][(NSUInteger)section];
    }
}

- (Player *)playerForIndexPath:(NSIndexPath *)indexPath fieldView:(FieldView *)fieldView {
    NSArray *section = [self section:indexPath.section fieldView:fieldView];
    Player *player = section[(NSUInteger)indexPath.row];

    return player;
}

#pragma mark - Views
- (PlayerSectionView *)homeFormationView {
    if (!_homeFormationView) {
        _homeFormationView = [[PlayerSectionView alloc] init];
        _homeFormationView.frame = CGRectMake(-10.f, 0.f, self.view.frame.size.width+10.f, 30.f);
        _homeFormationView.name.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0f];
        _homeFormationView.name.textColor = [UIColor primaryTextColor];
        _homeFormationView.rightLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0f];
        _homeFormationView.rightLabel.textColor = [UIColor primaryTextColor];
    }

    return _homeFormationView;
}

- (FieldView *)fieldViewHome {
    if (!_fieldViewHome) {
        _fieldViewHome = [[FieldView alloc] initWithFrame:CGRectMake(1.5f, 30.f, self.view.frame.size.width-5.f, 340.f)];
        _fieldViewHome.delegate = self;
        _fieldViewHome.dataSource = self;
        _fieldViewHome.tag = 1;
    }

    return _fieldViewHome;
}

- (FieldView *)fieldViewAway {
    if (!_fieldViewAway) {
        _fieldViewAway = [[FieldView alloc] initWithFrame:CGRectMake(1.5f, 370.f, self.view.frame.size.width-5.f, 340.f)];
        _fieldViewAway.delegate = self;
        _fieldViewAway.dataSource = self;
        _fieldViewAway.tag = 2;
    }

    return _fieldViewAway;
}

- (PlayerSectionView *)awayFormationView {
    if (!_awayFormationView) {
        _awayFormationView = [[PlayerSectionView alloc] init];
        _awayFormationView.frame = CGRectMake(-10.f, 710.f, self.view.frame.size.width+10.f, 30.f);
        _awayFormationView.name.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0f];
        _awayFormationView.name.textColor = [UIColor primaryTextColor];
        _awayFormationView.rightLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0f];
        _awayFormationView.rightLabel.textColor = [UIColor primaryTextColor];
    }

    return _awayFormationView;
}

#pragma mark - Player Helper
- (NSArray *)getPlayerEvents:(NSString *)playerId{
    NSMutableArray *events = NSMutableArray.new;
    for (Event *event in self.matchViewModel.model.events) {
        NSString *eventType = event.type;
        if ([event.type isEqualToString:@"ps-goal"]) eventType = @"goal";
        if ([eventType isEqualToString: lineupEventString(SUBSTITUTION)]) {
            if ([event.in.objectId isEqualToString:playerId] || [event.out.objectId isEqualToString:playerId]) {
                BOOL existEvent = NO;
                for (NSMutableDictionary *regEvent in events) {
                    if ([[regEvent objectForKey:@"type"] isEqualToString: eventType]) {
                        existEvent = YES;
                        break;
                    }
                }
                if (!existEvent) {
                    [events addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"type": eventType,
                                                                                      @"count": @1
                                                                                      }]];
                }
            }
        } else if (event.player.objectId != nil){
            if ([event.player.objectId isEqualToString:playerId]) {
                BOOL existEvent = NO;
                for (NSMutableDictionary *regEvent in [events copy]) {
                    if ([[regEvent objectForKey:@"type"] isEqualToString: eventType]) {
                        existEvent = YES;
                        NSMutableDictionary *updateEvent = [regEvent mutableCopy];
                        [updateEvent setObject:@([regEvent[@"count"] integerValue] + 1) forKey:@"count"];
                        [events replaceObjectAtIndex:[events indexOfObject:regEvent] withObject:updateEvent];
                    }
                }
                if (!existEvent) {
                    [events addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"type": eventType,
                                                                                      @"count": @1
                                                                                      }]];
                }
            } else if ([eventType isEqualToString: lineupEventString(GOAL)] && [event hasAssist]) {
                if ([event.assist.objectId isEqualToString:playerId]) {
                    BOOL existEvent = NO;
                    for (NSMutableDictionary *regEvent in [events copy]) {
                        if ([[regEvent objectForKey:@"type"] isEqualToString: @"assist"]) {
                            existEvent = YES;
                            NSMutableDictionary *updateEvent = [regEvent mutableCopy];
                            [updateEvent setObject:@([regEvent[@"count"] integerValue] + 1) forKey:@"count"];
                            [events replaceObjectAtIndex:[events indexOfObject:regEvent] withObject:updateEvent];
                        }
                    }
                    if (!existEvent) {
                        [events addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                          @"type": @"assist",
                                                                                          @"count": @1
                                                                                          }]];
                    }
                }
            }
        }
    }
    
    return events;    
}


@end
