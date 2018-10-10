//
// Created by Anders Borre Hansen on 16/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleFieldPlayerView.h"
#import "SelectPlayerViewController.h"
#import "FieldView.h"
#import "BattleTemplateViewModel.h"
#import "Player.h"
#import "Team.h"
#import "MZTimerLabel.h"
#import "CaptainButton.h"
#import "ChooseCaptainTableViewController.h"


@protocol CreateLineupViewControllerDelegate;

@interface CreateLineupViewController : UIViewController<FieldViewDataSource, FieldViewDelegate, SelectPlayerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, CaptainButtonDelegate, ChooseCaptainDelegate, MZTimerLabelDelegate>
@property (nonatomic, weak) id <CreateLineupViewControllerDelegate> delegate;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) NSString *buildMode;
@property (nonatomic) BOOL isEditingExistingLineup;
@property(nonatomic, strong) User *user;

- (instancetype)initCreateInviteOnlyBattleWithDelegate:(id <CreateLineupViewControllerDelegate>)delegate battleTemplateId:(NSString *)battleTemplateId;

- (instancetype)initJoinInvitedBattle:(Battle *)battle delegate:(id <CreateLineupViewControllerDelegate>)delegate;
- (instancetype)initPublicBattleWithDelegate:(id <CreateLineupViewControllerDelegate>)delegate battleTemplateId:(NSString *)battleTemplateId;
- (instancetype)initEditBattleWithDelegate:(id <CreateLineupViewControllerDelegate>)delegate battle:(Battle *)battle;
- (void)setSubmitButtonColor;
@end

@protocol CreateLineupViewControllerDelegate
- (void)createTeamViewController:(CreateLineupViewController *)controller doneWithReturnObj:(id)dic withPlayers:(id)players;
@end
