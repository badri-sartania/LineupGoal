//
// Created by Anders Hansen on 19/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "DefaultSubscriptionViewController.h"
#import "SubscriptionViewController.h"
#import "Identification.h"


@interface DefaultSubscriptionViewController ()
@property(nonatomic, strong) ViewModelWithSubscriptions *viewModel;
@end

@implementation DefaultSubscriptionViewController

- (id)initWithViewModel:(ViewModelWithSubscriptions *)viewModel mainViewController:(UIViewController *)mainController {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;
        self.mainViewController = mainController;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"bell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(bellButtonPressed:)];
    }

    return self;
}

- (void)setUpSubscriptionViewController {
    SubscriptionViewController *subscriptionViewController = [[SubscriptionViewController alloc] initWithViewModel:self.viewModel];

    self.topViewController = subscriptionViewController;

    subscriptionViewController.view.frame = CGRectMake(0.f, -340.f, subscriptionViewController.view.bounds.size.width, 340.f);

    [subscriptionViewController setHeaderLabel:@"Select notifications"];

    [self setup];

    self.slideVCDelegate = subscriptionViewController;
}

- (void)updateBellIcon:(Subscription *)subscription {
    static UIImage *normal;
    static UIImage *highlighted;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        normal = [[UIImage imageNamed:@"bell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        highlighted = [[UIImage imageNamed:@"bell_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    });
    self.navigationItem.rightBarButtonItem.image = subscription.count > 0 ? highlighted : normal;
}

- (void)bellButtonPressed:(id)sender {
    if (!self.topViewController) {
        [self setUpSubscriptionViewController];
        [self setupTopViewController];
    }

    [self toggle];

    if (self.isOpen) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"APNDialogShown"]) {
            NSMutableDictionary *meta = [[NSMutableDictionary alloc] initWithDictionary:@{
               @"type": [self.viewModel classNameAsString],
               @"disabled": @([Identification isAPNDisabled])
            }];

            if ([self.viewModel valueForKey:@"objectId"]) meta[@"id"] = [self.viewModel valueForKey:@"objectId"];
            if ([self.viewModel valueForKey:@"name"]) meta[@"name"] = [self.viewModel valueForKey:@"name"];

            [[Mixpanel sharedInstance] track:@"Open Subscription" properties:meta];
        }

    }

    [self updateBellIcon:self.viewModel.subscription];
}

@end
