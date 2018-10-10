//
// Created by Anders Hansen on 04/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "SubscriptionViewController.h"
#import "DefaultLabel.h"
#import "NotificationButtonView.h"
#import "Utils.h"
#import "NSArray+BlocksKit.h"
#import "APNHelper.h"
#import "UIColor+Lineupbattle.h"
#import "HexColors.h"


@interface SubscriptionViewController ()
@property (nonatomic, strong) DefaultLabel *header;
@property (nonatomic, strong) UIView *errorGlassPane;
@property (nonatomic, strong) DefaultLabel *errorHeader;
@property (nonatomic, strong) DefaultLabel *errorLabel;
@property (nonatomic, strong) DefaultLabel *target;
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, strong) UIButton *selectNoneButton;;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) id viewModel;
@end

@implementation SubscriptionViewController

- (id)initWithViewModel:(id)viewModel {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadView {
    [super loadView];

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.f, 325.f, self.view.frame.size.width, 1.5f);
    bottomBorder.backgroundColor = [UIColor actionColor].CGColor;
    [self.view.layer addSublayer:bottomBorder];

    [self setSubscriptionView];
    [self setErrorView];

    // manually run the method initially
    [self applicationBecameActive:nil];
    // then set up a listener
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationBecameActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationBecameActive:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self topDidClose];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationBecameActive:(NSNotification *)notification {
    [self setErrorViewHidden:[Utils APNAlertsEnabled]];
}

- (void)setHeaderLabel:(NSString *)targetString {
    self.header.text = targetString;
}

- (void)setSubscriptionView {
    [self.view addSubview:self.header];
    [self.view addSubview:self.selectAllButton];
    [self.view addSubview:self.selectNoneButton];

    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
    }];

    NSInteger offsetSize = 80;
    NSNumber *leftOffset = @(-offsetSize);
    NSNumber *rightOffset = @(offsetSize);

    NSDictionary *notifications = @{
        @"reminder":        @"Reminder",
        @"lineup":          @"Lineup",
        @"kickOff":         @"Kick off",
        @"goals":           @"Goals",
        @"redCards":        @"Red cards",
        @"ht":              @"Half Time",
        @"ft":              @"Full Time",
        @"substitutions":   @"Substitution",
        @"bench":           @"On Bench",
        @"assists":         @"Assists"
    };

    self.buttons = [[NSMutableArray alloc] init];

    NSArray *offsetDefinition = @[leftOffset, @0, rightOffset];

    // TODO: better to typecast it and call method directly
    NSArray *types = [[[self.viewModel valueForKey:@"subscription"] class] valueForKey:@"types"];

    if (types) {
        for (NSUInteger i = 0; i < types.count; i++) {
            NSString *key = types[i];
            NSString *buttonName = notifications[key];
            NotificationButtonView *notificationButtonView = [[NotificationButtonView alloc] initWithName:buttonName key:key viewModel:self.viewModel];
            [self.view addSubview:notificationButtonView];

            NSUInteger line = i / 3 + 1;
            NSUInteger height = (NSUInteger) (line == 1 ? 45 : 78 * line - 33);
            NSUInteger offsetPosition = i % 3;

            NSNumber *offset = offsetDefinition[offsetPosition];

            [notificationButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset([offset integerValue]);
                make.top.equalTo(@(height));
                make.size.equalTo(@80);
            }];

            [self.buttons addObject:notificationButtonView];
        }
    }

    [self.selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(((UIView *)[self.buttons lastObject]).mas_bottom).offset(-5);
        make.centerX.equalTo(self.view).offset(-60);
    }];

    [self.selectNoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(((UIView *)[self.buttons lastObject]).mas_bottom).offset(-5);
        make.centerX.equalTo(self.view).offset(60);
    }];
}

- (void)setErrorView {
    [self.view addSubview:self.errorGlassPane];
    [self.view addSubview:self.errorHeader];
    [self.view addSubview:self.errorLabel];

    [self.errorGlassPane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.errorHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
    }];

    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.right.equalTo(self.view).offset(-25);
        make.left.equalTo(self.view).offset(25);
    }];

    // start out as hidden
    [self setErrorViewHidden:YES];
}

- (void)setErrorViewHidden:(BOOL)hidden {
    [self.errorGlassPane setHidden:hidden];
    [self.errorHeader setHidden:hidden];
    [self.errorLabel setHidden:hidden];
}

#pragma mark - views
- (UIView *)errorGlassPane {
    if (!_errorGlassPane ) {
        _errorGlassPane = [[UIView alloc] init];
        _errorGlassPane.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8f];
    }

    return _errorGlassPane;
}

- (DefaultLabel *)errorHeader {
    if (!_errorHeader ) {
        _errorHeader = [DefaultLabel initWithSystemFontSize:22];
        _errorHeader.text = @"Notifications are disabled!";
    }

    return _errorHeader;
}

- (DefaultLabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [DefaultLabel initWithAlignment:NSTextAlignmentCenter];
        _errorLabel.text = @"To receive alerts, go to 'Notification Center' in the Settings app and enable alerts for the Lineupbattle app.";
        _errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _errorLabel.numberOfLines = 0;
    }

    return _errorLabel;
}

- (DefaultLabel *)header {
    if (!_header ) {
        _header = [DefaultLabel initWithSystemFontSize:13];
    }

    return _header;
}

- (UIButton *)selectAllButton {
    if (!_selectAllButton ) {
        _selectAllButton = [[UIButton alloc] init];

        [_selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
        [_selectAllButton setTitleColor:[UIColor actionColor] forState:UIControlStateNormal];
        [_selectAllButton setTitleColor:[UIColor hx_colorWithHexString:@"#000"] forState:UIControlStateHighlighted];

        @weakify(self);
        _selectAllButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
            @strongify(self);

            [self.buttons bk_each:^(NotificationButtonView *obj) {
                [obj setState:YES];
            }];

            return [RACSignal empty];
        }];
    }

    return _selectAllButton;
}

- (UIButton *)selectNoneButton {
    if (!_selectNoneButton) {
        _selectNoneButton = [[UIButton alloc] init];

        [_selectNoneButton setTitle:@"Unselect All" forState:UIControlStateNormal];
        [_selectNoneButton setTitleColor:[UIColor actionColor] forState:UIControlStateNormal];
        [_selectNoneButton setTitleColor:[UIColor hx_colorWithHexString:@"#000"] forState:UIControlStateHighlighted];

        @weakify(self);
        _selectNoneButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
            @strongify(self);

            [self.buttons bk_each:^(NotificationButtonView *obj) {
                [obj setState:NO];
            }];

            return [RACSignal empty];
        }];
    }

    return _selectNoneButton;
}

#pragma mark - XipSlideDownActions
- (void)topDidOpen {
    self.initialBitMask = [self getCurrentBitMask];
    self.initialSubscriptionCount = [self getSubscriptionCount];

    [APNHelper doubleConfirmationWithTitle:@"Improve your experience" message:@"You are about to choose notifications. Would you like us to activate that?" accepted:^{
        [Utils registerForAPN];
    }];
}

- (void)topDidClose {
    if (self.initialBitMask != [self getCurrentBitMask]) {

        [[Mixpanel sharedInstance] track:@"Submit subscription" properties:@{
                @"initialBitMask": @(self.initialBitMask),
                @"initialSubscriptionCount": @([self initialSubscriptionCount]),
                @"submitBitMask": @([self getCurrentBitMask]),
                @"submitSubscriptionCount": @([self getSubscriptionCount]),
                @"type": [self.viewModel classNameAsString],
                @"id": [self.viewModel valueForKey:@"objectId"] ?: [NSNull null]
        }];

        self.initialBitMask = [self getCurrentBitMask];

        [self.viewModel submitSubscription];
    }
}

#pragma mark - Stats
- (NSUInteger)getCurrentBitMask {
    return [(Subscription *) [self.viewModel valueForKey:@"subscription"] toBitMask];
}

- (NSInteger)getSubscriptionCount {
    return [(Subscription *) [self.viewModel valueForKey:@"subscription"] count];
}

@end
