//
// Created by Anders Hansen on 10/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "XipNotificationViewController.h"
#import "HexColors.h"


@interface XipNotificationViewController ()
@property(nonatomic, strong) UIView *notificationView;
@property(nonatomic, strong) DefaultLabel *notificationLabel;
@end

@implementation XipNotificationViewController

- (id)initWithViewController:(UIViewController *)mainViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        self.mainViewController = mainViewController;
        [self addViewController:self.mainViewController];

        self.notificationView = UIView.new;
        self.notificationView.backgroundColor = [UIColor hx_colorWithHexString:@"#333"];
        self.notificationLabel = [DefaultLabel initWithText:@""];
        self.notificationLabel.font = [UIFont systemFontOfSize:12.f];
        self.notificationLabel.textColor = [UIColor whiteColor];

        self.navigationItem.leftBarButtonItem = mainViewController.navigationItem.leftBarButtonItem;
        self.navigationItem.rightBarButtonItem = mainViewController.navigationItem.rightBarButtonItem;
        self.navigationItem.title = mainViewController.navigationItem.title;
        self.navigationItem.titleView = mainViewController.navigationItem.titleView;
        self.navigationItem.backBarButtonItem = mainViewController.navigationItem.backBarButtonItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildViewController:self.mainViewController];

    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];

    self.mainViewController.view.frame = CGRectMake(0.f,0.f, self.view.frame.size.width, self.view.frame.size.height);

    [self.view addSubview:self.notificationView];
    self.notificationView.frame = CGRectMake(0.f,-20.f, self.view.frame.size.width, 20.f);

    [self.notificationView addSubview:self.notificationLabel];

    [self.notificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.equalTo(self.notificationView);
    }];
}

- (void)addViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
}

- (void)openWithText:(NSString *)text animated:(BOOL)animated {
    self.visible = YES;

    self.notificationLabel.text = text;

    CGRect frame        = CGRectMake(0.f, 0.f, self.view.frame.size.width, 20.f);
    CGRect frame2       = self.view.frame;
    frame2.origin.y     = self.notificationView.frame.size.height;
    frame2.size.height  = self.view.frame.size.height - self.notificationView.frame.size.height;

    @weakify(self);

    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent)
                         animations:^{
            @strongify(self);
            self.notificationView.frame = frame;
            self.mainViewController.view.frame = frame2;
        } completion:^(BOOL finished) {}];
    } else {
        self.notificationView.frame = frame;
        self.mainViewController.view.frame = frame2;
    }
}

- (void)close {
    self.visible = NO;

    CGRect frame        = self.notificationView.frame;
    frame.origin.y      = -self.notificationView.frame.size.height;

    CGRect frame2       = self.view.frame;
    frame2.origin.y     = 0.f;

    @weakify(self);
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent)
                     animations:^{
        @strongify(self);
        self.notificationView.frame = frame;
        self.mainViewController.view.frame = frame2;
    } completion:^(BOOL finished) {}];
}

@end
