//
// Created by Anders Borre Hansen on 04/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "ChooseCaptainTableViewController.h"
#import "ImageTextViewCell.h"
#import "UIColor+LineupBattle.h"


@interface ChooseCaptainTableViewController ()
@property(nonatomic, strong) NSArray *players;
@end

@implementation ChooseCaptainTableViewController

- (instancetype)initWithPlayers:(NSArray *)players {
    self = [super init];
    if (self) {
        self.title = @"Select Captain";
        self.players = players;
        [self.tableView registerClass:[ImageTextViewCell class] forCellReuseIdentifier:@"playerSelector"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (players.count == 0) {
            DefaultLabel *noPlayerWarningLabel = [DefaultLabel initWithCenterText:@"You need players in your lineup before you can choose a captain"];
            noPlayerWarningLabel.numberOfLines = 0;
            noPlayerWarningLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
            noPlayerWarningLabel.textColor = [UIColor actionColor];

            [self.view addSubview:noPlayerWarningLabel];
            [noPlayerWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.centerY.equalTo(self.view).offset(-50);
                make.size.equalTo(@250);
            }];
        }
    }

    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.players.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player = self.players[(NSUInteger)indexPath.row];
    [self.delegate captainSelected:player];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTextViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"playerSelector" forIndexPath:indexPath];
    Player *player = self.players[(NSUInteger)indexPath.row];
    [cell setData:player position:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
