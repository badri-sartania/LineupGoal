//
// Created by Anders Borre Hansen on 17/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import "ChallengesTableViewController.h"
#import "BattleButtonView.h"
#import "Utils.h"
#import "BattleShopTableViewController.h"
#import "OAStackView.h"
#import "FBSDKLoginButtonHelper.h"
#import "HTTP.h"
#import "BattlesTableViewCell.h"
#import "DefaultNavigationController.h"
#import "BattleViewModel.h"
#import "BattleViewController.h"
#import "SimpleLocale.h"
#import "Wallet.h"
#import "HexColors.h"
#import "HTTP+RAC.h"
#import "Answers.h"


@implementation ChallengesTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Challenge Friends";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }

    return self;
}

- (id)initWithInvites:(NSArray *)invites {
    self = [self init];

    if (self) {
        self.invites = invites;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    BattleButtonView *buttonView = [[BattleButtonView alloc] initWithImage:[UIImage imageNamed:@"challengeFriend"] title:@"Start an Invite-Only Battle\nand Challenge Friends"];
    UIButton *buttonOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonView.frame = CGRectMake(0.f, 0.f, [Utils screenWidth], 70.f);
    [buttonView addSubview:buttonOverlay];
    buttonOverlay.frame = buttonView.frame;
    [buttonOverlay addTarget:self action:@selector(battleShopAction) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView registerClass:[BattlesTableViewCell class] forCellReuseIdentifier:@"challengeCell"];
    self.tableView.tableHeaderView = buttonView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Table
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];

    [self refreshData];
}

- (void)refreshData {
    @weakify(self);
    [[[HTTP instance] battlesSignal] subscribeNext:^(NSDictionary *dic) {
        @strongify(self);

        User *user = dic[@"user"];
        if (user.wallet) {
            [[Wallet instance] setCredits:[user.wallet integerValue] timestamp:user.walletUpdatedAt];
        }

        self.invites = dic[@"invited"];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);

        [self.refreshControl endRefreshing];
    }];
}


- (void)battleShopAction {
    BattleShopTableViewController *battleShopTableViewController = [[BattleShopTableViewController alloc] initWithInviteOnly:YES];
    [self.navigationController pushViewController:battleShopTableViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.invites.count == 0 ? 1 : self.invites.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.invites.count == 0) return 170.f;
    return 115.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.f)];

    sectionView.backgroundColor = [UIColor hx_colorWithHexString:@"f2f2f2"];

    DefaultLabel *label = [DefaultLabel initWithCenterText:@"Friend Challenges"];
    label.font = [UIFont boldSystemFontOfSize:14.f];
    [sectionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView);
        make.left.equalTo(sectionView).offset(15);
    }];

    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.invites.count == 0) {
        if ([FBSDKAccessToken currentAccessToken]) {
            return [self noInvitesCell];
        } else {
            return [FBSDKLoginButtonHelper loginWithFacebookViewCellWithTopText:@"See challenges by friends,\nconnect with Facebook" withDelegate:self];
        }
    } else {
        Battle *invite = self.invites[(NSUInteger)indexPath.row];
        BattlesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"challengeCell" forIndexPath:indexPath];
        [cell setData:invite.template :(int)(indexPath.row)];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.invites.count == 0) return;
    
    Battle *invite = self.invites[(NSUInteger) indexPath.row];
    CreateLineupViewController *lineupController = [[CreateLineupViewController alloc] initJoinInvitedBattle:invite delegate:self];
    DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:lineupController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (UITableViewCell *)noInvitesCell {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UIView *hightlightView = [[UIView alloc] init];
    hightlightView.backgroundColor = [UIColor whiteColor];
    hightlightView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:hightlightView];
    
    DefaultLabel *topText = [DefaultLabel initWithText:@"No invites"];
    topText.font = [UIFont systemFontOfSize:16];
    topText.textColor = [UIColor hx_colorWithHexString:@"727272"];
    topText.numberOfLines = 2;
    topText.textAlignment = NSTextAlignmentCenter;
    
    OAStackView *stackView = [[OAStackView alloc] initWithArrangedSubviews:@[topText]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.spacing = 12.f;
    
    [cell addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell);
    }];
    
    return cell;
}

- (void)createTeamViewController:(CreateLineupViewController *)controller doneWithReturnObj:(NSDictionary *)dic withPlayers:(id) players{
    if (dic) {
        BattleViewModel *viewModel = [[BattleViewModel alloc] initWithModelDictionary:dic];
        BattleViewController *gameView = [[BattleViewController alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:gameView animated:NO];

        @weakify(viewModel)
        [APNHelper showBattleNotificationControlsFor:gameView type:^(BattleNotificationControl state) {
            @strongify(viewModel);
            [viewModel handleSubscriptionChoice:state];
        } title:@"Battle Joined" message:[NSString stringWithFormat:@"Receive notifications on %@ events so you're updated on the action.", [SimpleLocale USAlternative:@"game" forString:@"match"]]];
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    @weakify(self);
    [FBSDKLoginButtonHelper registerFacebookLogin:result success:^{
        @strongify(self);

        [Answers logLoginWithMethod:@"Facebook" success:@YES customAttributes:@{
            @"location": @"Challenges"
        }];

        [self refreshData];
    }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [FBSDKLoginButtonHelper trackLogout];
}

@end
