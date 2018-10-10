//
// Created by Anders Borre Hansen on 19/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <JGProgressHUD/JGProgressHUD.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "InviteFriendsTableViewController.h"
#import "SelectViewCell.h"
#import "HTTP.h"
#import "PlayerSectionView.h"
#import "SCLAlertView.h"
#import "FBSDKLoginButtonHelper.h"
#import "OAStackView.h"
#import "SpinnerHelper.h"
#import "Mixpanel.h"
#import "NSObject+isNull.h"
#import "HexColors.h"
#import "HTTP+RAC.h"
#import "Answers.h"


@interface InviteFriendsTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *invites;
@property (nonatomic, strong) NSMutableDictionary *unInvites;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) BattleViewModel *viewModel;

@property(nonatomic, strong) JGProgressHUD *hud;
@end

@implementation InviteFriendsTableViewController

static NSString *cellIdentifier = @"selectCell";

- (id)initWithBattleViewModel:(BattleViewModel *)viewModel {
    self = [super init];
    
    if (self) {

        self.viewModel = viewModel;
        self.title = @"Invite Friends";
        self.tableView.separatorColor = [UIColor clearColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.tableView registerClass:[SelectViewCell class] forCellReuseIdentifier:cellIdentifier];

        // Done button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];

        // Data
        self.invites = [[NSMutableDictionary alloc] init];
        self.unInvites = [[NSMutableDictionary alloc] init];

        // Loading indicator until data has arrived
        self.hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];
    }

    return self;
}

- (void)refreshData {
    @weakify(self);
    [[[[HTTP instance] get:@"/me/friends"] ignore:nil] subscribeNext:^(NSArray *friends) {
        @strongify(self);

        // Don't show friends without name
        self.friends = [friends bk_reject:^BOOL(NSDictionary *friend) {
            return !friend || [friend isNull] || !friend[@"name"] || [friend[@"name"] isEqualToString:@""];
        }];

        // Track friends count
        [[Mixpanel sharedInstance].people set:@"friends" to:@(friends.count)];

        [self.refreshControl endRefreshing];
        [self.hud dismiss];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);

        [self.hud dismiss];
        [self.tableView reloadData];
    }];
}

- (void)showInviteError {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = FadeIn;
    [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
    [alert showNotice:self title:@"Error inviting friends" subTitle:@"An error occured while inviting friends to this battle. Try again" closeButtonTitle:@"Got it" duration:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Table
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];

    [self refreshData];
}

#pragma mark - Section
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlayerSectionView *sectionView = [[PlayerSectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 30.f)];
    [sectionView setSectionTitle:@"Friends"];
    [sectionView setSectionLastText:@"Selection"];

    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

#pragma mark - Data delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count ?: 1;
}

#pragma mark - Cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.friends.count == 0) return 170.f;
    return 52.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.friends.count == 0) {
        if ([FBSDKAccessToken currentAccessToken]) {
            return [self noFriendsCell];
        } else {
            return [FBSDKLoginButtonHelper loginWithFacebookViewCellWithTopText:@"You need to login to see your friends" withDelegate:self];
        }
    } else {
        SelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        NSDictionary *user = self.friends[(NSUInteger) indexPath.row];
        cell.logo.image = [UIImage imageNamed:@"playerPlaceholder"];
        cell.name.text = user[@"name"];

        return cell;
    }
}

- (UITableViewCell *)noFriendsCell {
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    // Hightlight
    UIView *hightlightView = [[UIView alloc] init];
    hightlightView.backgroundColor = [UIColor whiteColor];
    hightlightView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:hightlightView];

    DefaultLabel *topText = [DefaultLabel initWithText:@"No friends has joined the app yet.\nGet them to join and connect with facebook"];
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

#pragma mark - Events
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.friends.count == 0) return;

    SelectViewCell *cell = (SelectViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *friend = self.friends[(NSUInteger)indexPath.row];

    BOOL isSelected = [cell toggleSelection];
    if (isSelected) {
        [self addSelection:friend];
    } else {
        [self removeSelection:friend];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addSelection:(NSDictionary *)friend {
    self.invites[friend[@"_id"]] = friend;
}

- (void)removeSelection:(NSDictionary *)friend {
    [self.invites removeObjectForKey:friend[@"_id"]];
    self.unInvites[friend[@"_id"]] = friend;
}

- (void)doneButtonAction:(id)doneButtonAction {
    if (self.invites.count > 0 || self.unInvites.count > 0) {
        [self.hud showInView:self.view];

        @weakify(self);
        [[self.viewModel addInvites:[self.invites allKeys] unInvite:[self.unInvites allKeys]] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate friendsSelected:self];
        } error:^(NSError *error) {
            @strongify(self);
            [self showInviteError];
        }];
    }
}

#pragma mark - Facebook
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    @weakify(self);
    [FBSDKLoginButtonHelper registerFacebookLogin:result success:^{
        @strongify(self);

        [Answers logLoginWithMethod:@"Facebook" success:@YES customAttributes:@{
            @"location": @"Invite"
        }];

        [self refreshData];
    }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [FBSDKLoginButtonHelper trackLogout];
}

@end
