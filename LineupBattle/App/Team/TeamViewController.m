//
// Created by Anders Borre Hansen on 06/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "TeamViewController.h"
#import "PlayersTeamViewController.h"
#import "MatchesTeamViewController.h"
#import "TableTeamViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "SimpleLocale.h"

@interface TeamViewController ()
@property(nonatomic, strong) MatchesTeamViewController *matchesController;
@property(nonatomic, strong) PlayersTeamViewController *playerController;
@property(nonatomic, strong) TableTeamViewController *tableController;
@end

@implementation TeamViewController

- (id)initWithTeam:(Team *)team {
    return [self initWithViewModel:[[TeamViewModel alloc] initWithTeam:team]];
}

- (id)initWithViewModel:(TeamViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        @weakify(self);
        [self.viewModel fetchDetailsCatchError:YES success:^{
            @strongify(self);
            [self.matchesController updateData];
            [self.playerController updateData];
            [self.tableController updateData];
        }];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.slider.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.matchesController = [[MatchesTeamViewController alloc] initWithViewModel:self.viewModel];
    self.playerController = [[PlayersTeamViewController alloc] initWithViewModel:self.viewModel];
    self.tableController = [[TableTeamViewController alloc] initWithViewModel:self.viewModel];

    [self addSubPageControllers:@[
        @{
            @"title" : [SimpleLocale USAlternative:@"Games" forString:@"Matches"],
            @"controller" : self.matchesController,
        },
        @{
            @"title": @"Squad",
            @"controller": self.playerController
        },
        @{
            @"title": @"Table",
            @"controller": self.tableController
        }
    ]];
}

@end
