//
// Created by Anders Borre Hansen on 09/07/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Identification.h"
#import "HTTP.h"
#import "Utils.h"
#import "CKTextField.h"
#import "DefaultLabel.h"
#import "SCLAlertView.h"
#import "Mixpanel.h"
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import "FBSDKLoginButtonHelper.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "SpinnerHelper.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"
#import "HTTP+RAC.h"
#import "Answers.h"
#import "EditProfileTableViewCell.h"
#import "LogoutTableViewCell.h"


@interface EditProfileViewController ()
@property(nonatomic, strong) UIView *navigationBar;
@property(nonatomic, strong) FBSDKLoginButton *facebookLoginButton;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIButton *submitButton;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) NSArray *profileContent;
@property(nonatomic) User *user;
@property(nonatomic) User *changedUser;
@property(nonatomic) BOOL isEditing;
@end

static NSInteger navigationBarHeight = 64;

typedef NS_ENUM(NSInteger, ProfileSettingContent) {
    ProfileSettingName,
    ProfileSettingEmail,
    ProfileSettingPhoto,
    ProfileSettingNationality,
    ProfileSettingNotification,
    ProfileSettingSubscription,
    ProfileSettingRateUs,
    ProfileSettingAbout,
    ProfileSettingHelp
};


@implementation EditProfileViewController

- (instancetype)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.isEditing = false;
        self.user = user;
        self.changedUser = user;
        self.title = @"Edit User";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initProfileContent];
    [self setupNavigationBar];
    [self setupBottomView];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)initProfileContent {
    self.profileContent = @[
                            @{
                                @"type": @(ProfileSettingName),
                                @"control": @"input",
                                @"label": @"Name",
                                @"placeholder": @"Add your name",
                                @"separator": @"normal"
                                },
                            @{
                                @"type": @(ProfileSettingEmail),
                                @"control": @"input",
                                @"label": @"Email",
                                @"placeholder": @"Add your email",
                                @"separator": @"normal"
                                },
//                            THIS IS FOR LATER
//                            @{
//                                @"type": @(ProfileSettingPhoto),
//                                @"control": @"image",
//                                @"label": @"Profile Image",
//                                @"placeholder": @"playerPlaceholder",
//                                @"separator": @"normal"
//                                },
                            @{
                                @"type": @(ProfileSettingNationality),
                                @"control": @"select",
                                @"label": @"Nationality",
                                @"placeholder": @"Unknown",
                                @"separator": @"full"
                                },
//                            @{
//                                @"type": @(ProfileSettingNotification),
//                                @"control": @"pick",
//                                @"label": @"Notification",
//                                @"placeholder": @"",
//                                @"separator": @"normal"
//                                },
//                            @{
//                                @"type": @(ProfileSettingSubscription),
//                                @"control": @"pick",
//                                @"label": @"Subscription",
//                                @"placeholder": @"",
//                                @"separator": @"full"
//                                },
                            @{
                                @"type": @(ProfileSettingRateUs),
                                @"control": @"button",
                                @"label": @"Like the app? Rate us",
                                @"placeholder": @"",
                                @"separator": @"normal"
                                },
                            @{
                                @"type": @(ProfileSettingAbout),
                                @"control": @"button",
                                @"label": @"About",
                                @"placeholder": @"",
                                @"separator": @"normal"
                                },
                            @{
                                @"type": @(ProfileSettingHelp),
                                @"control": @"button",
                                @"label": @"Help",
                                @"placeholder": @"",
                                @"separator": @"normal"
                                },
                            ];
}

#pragma mark - Setup UI

- (void)setupNavigationBar {
    // Setup navigation bar
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], navigationBarHeight)];
    [self.navigationBar setBackgroundColor:[UIColor primaryColor]];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(navigationBarHeight);
    }];
    
    UILabel *navTitle = [[UILabel alloc] init];
    [navTitle setText:@"SETTINGS"];
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
        make.bottom.equalTo(self.navigationBar);
        make.width.equalTo(@54);
    }];
    
}

- (void)setupBottomView {
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    
    [self updateBottomViewConstraints: false];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, [Utils screenWidth], 1.0f);
    topBorder.backgroundColor = [UIColor highlightColor].CGColor;
    [self.bottomView.layer addSublayer:topBorder];
    
    self.submitButton = [[UIButton alloc] init];
    [self.bottomView addSubview:self.submitButton];
    
    [self.submitButton setTitle:@"SAVE CHANGES" forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[UIColor championsLeagueColor]];
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView);
    }];
    [self.submitButton addTarget:self
                          action:@selector(onSaveChanges)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerClass:[EditProfileTableViewCell class] forCellReuseIdentifier:@"editProfileTVCell"];
    [self.tableView registerClass:[LogoutTableViewCell class] forCellReuseIdentifier:@"logoutCell"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self setupConnectFbSection:self.tableView];
}

- (void)setupConnectFbSection:(UITableView*)containerView {
    UIView *fbSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, navigationBarHeight, [Utils screenWidth], 287)];
    self.headerView = fbSectionView;
    
    [fbSectionView setBackgroundColor:[UIColor primaryColor]];
    
    UIImageView *imageConnect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_cloud_join"]];
    [fbSectionView addSubview: imageConnect];
    [imageConnect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fbSectionView).offset(20);
    }];
    
    DefaultLabel *lbSyncDescription = [DefaultLabel initWithMediumSystemFontSize:15 color:[UIColor whiteColor]];
    lbSyncDescription.numberOfLines = 2;
    lbSyncDescription.textAlignment = NSTextAlignmentCenter;
    [fbSectionView addSubview:lbSyncDescription];
    lbSyncDescription.text = @"Save your achievements and sync your\nprogress across devices!";
    [lbSyncDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageConnect.mas_bottom).offset(8);
    }];
    
    self.facebookLoginButton = [FBSDKLoginButtonHelper createButtonWithDelegate:self];
    UIButton *fbLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth] * 0.75, 50)];
    [fbSectionView addSubview:fbLoginButton];
    [fbLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbSyncDescription.mas_bottom).offset(10);
        make.width.equalTo(@([Utils screenWidth] * 0.75));
        make.height.equalTo(@50);
    }];
    fbLoginButton.clipsToBounds = YES;
    fbLoginButton.layer.cornerRadius = 25;//half of the width
    fbLoginButton.layer.borderWidth=0.0f;
    fbLoginButton.backgroundColor = [UIColor europaLeagueColor];
    [fbLoginButton setTitle:@"   Connect with facebook" forState:UIControlStateNormal];
    fbLoginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    fbLoginButton.titleLabel.textColor = [UIColor whiteColor];
    fbLoginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [fbLoginButton addTarget:self
                      action:@selector(onFacebookConnect)
            forControlEvents:UIControlEventTouchUpInside];
    
    DefaultLabel *lbFacebookLogo = [DefaultLabel initWithSystemFontSize:30 color:[UIColor whiteColor]];
    [fbSectionView addSubview:lbFacebookLogo];
    lbFacebookLogo.text = @"f";
    [lbFacebookLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fbLoginButton.mas_centerY);
        make.left.equalTo(fbLoginButton.mas_left).offset(20);
    }];
    
    UIView *statusView = [[UIView alloc] init];
    [fbSectionView addSubview:statusView];
    statusView.backgroundColor = [UIColor relegationColor];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(fbSectionView.mas_bottom);
        make.left.equalTo(fbSectionView);
        make.height.equalTo(@57);
    }];
    
    UIButton *btnStatus = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [statusView addSubview:btnStatus];
    [btnStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusView).offset(20);
        make.centerY.equalTo(statusView);
        make.size.equalTo(@30);
    }];
    btnStatus.clipsToBounds = YES;
    btnStatus.layer.cornerRadius = 15;//half of the width
    btnStatus.layer.borderWidth=0.0f;
    btnStatus.backgroundColor = [UIColor whiteColor];
    [btnStatus setTitle:@"!" forState:UIControlStateNormal];
    [btnStatus setTitleColor:[UIColor relegationColor] forState:UIControlStateNormal];
    btnStatus.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    btnStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    DefaultLabel *lbStatus = [DefaultLabel initWithMediumSystemFontSize:15 color:[UIColor whiteColor]];
    lbStatus.numberOfLines = 0;
    [statusView addSubview:lbStatus];
    lbStatus.text = @"If not connected, all achievements and bolts are lost if app is deleted";
    [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(statusView);
        make.left.equalTo(btnStatus.mas_right).offset(20);
        make.right.equalTo(statusView.mas_right).offset(-20);
    }];
    
    [@[imageConnect, lbSyncDescription, fbLoginButton, statusView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fbSectionView);
    }];
}

- (void)updateBottomViewConstraints:(BOOL)show {
    CGFloat bottomHeight = show ? 60 : 0;
    if (@available(iOS 11.0, *)) {
        bottomHeight += self.view.safeAreaInsets.bottom;
    }
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(bottomHeight));
    }];
}

- (void)showSaveButton:(BOOL) show animated: (BOOL)animated {
    [self updateBottomViewConstraints: show];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration: animated ? 0.5 : 0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSaveChanges {
    NSLog(@"Save Changes");
    [self save];
}

- (void)onLogout {
    NSLog(@"Logout");
    [[[FBSDKLoginManager alloc] init] logOut];
    [FBSDKLoginButtonHelper trackLogout];
    [self.tableView reloadData];
}

- (void)onFacebookConnect {
    [self.facebookLoginButton sendActionsForControlEvents: UIControlEventTouchUpInside];
}

- (void)save {
    @weakify(self);

    __block JGProgressHUD *hud = [SpinnerHelper JGProgressHUDLoadingSpinnerInView:self.view];
    
    [[[HTTP instance] updateUser: self.changedUser] subscribeNext:^(id x) {
        @strongify(self);
        [Identification setUserNameAsSet];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[Mixpanel sharedInstance] track:@"Profile save success"];
        [hud dismissAnimated:YES];
        [self showSaveButton:false animated:true];
    } error:^(NSError *error) {
        @strongify(self);
        [hud dismissAnimated:YES];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = FadeIn;
        [alert setShouldDismissOnTapOutside:YES];
        [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];

        [[Mixpanel sharedInstance] track:@"Profile save error"];
        [alert showNotice:self title:@"Couldn't save profile" subTitle:@"Changes to profile couldn't no be saved. Try again later" closeButtonTitle:@"Ok" duration:0];
    }];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    @weakify(self);
    [FBSDKLoginButtonHelper registerFacebookLogin:result success:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];

        [Answers logLoginWithMethod:@"Facebook" success:@YES customAttributes:@{
            @"location": @"Edit profile"
        }];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Table view datasource and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([FBSDKAccessToken currentAccessToken] && self.profileContent.count == indexPath.row) {

        LogoutTableViewCell *cell = (LogoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"logoutCell" forIndexPath:indexPath];

        [cell.logoutButton addTarget:self
                              action:@selector(onLogout)
                    forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        EditProfileTableViewCell *cell = (EditProfileTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"editProfileTVCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupCell:self.user cellTemplate:self.profileContent[indexPath.row]];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(![FBSDKAccessToken currentAccessToken]) {
        return _headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(![FBSDKAccessToken currentAccessToken]) {
        return 287;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int logoutButton = [FBSDKAccessToken currentAccessToken] ? 1 : 0;
    return self.profileContent.count + logoutButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - Profile tableview cell delegate


- (void)onChangeText:(NSString *)text type:(NSInteger)type {
    NSLog(@"TextChanged - %@", text);
    if (self.isEditing == false) {
        self.isEditing = true;
        [self showSaveButton:true animated:true];
    }
    
    switch (type) {
        case ProfileSettingName:
            self.changedUser.name = [text isEqualToString:@""] ? nil : text;
            break;
        case ProfileSettingEmail:
            self.changedUser.email = [text isEqualToString:@""] ? nil : text;
            break;
        default:
            break;
    }
}

- (void)onSelect:(EditProfileTableViewCell *)cell type:(NSInteger)type {
    
}

- (void)onUpdateContent:(id)content type:(NSInteger)type {
    
}

@end
