//
//  DefaultNavigationController.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 01/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import "DefaultNavigationController.h"
#import "HTTP.h"
#import "UIColor+Lineupbattle.h"

@interface DefaultNavigationController ()
@property(nonatomic, strong) XipNotificationViewController *notificationViewController;
@end

@implementation DefaultNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];

    if (self) {
        self.delegate = self;
        self.navigationBar.tintColor = [UIColor actionColor];
        self.navigationBar.translucent = NO;

        [self setNotificationObservers];
    }
    return self;
}

- (void)setNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNotification:)
                                                 name:@"NoInternet"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideNotification:)
                                                 name:@"InternetAvailable"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification methods
- (void)showNotification:(NSNotification *)showNotification {
    [self displayNotification:showNotification.userInfo[@"message"] animated:YES];
}

#pragma mark - View actions
- (void)hideNotification:(NSNotification *)hideNotification {
    if (!self.notificationViewController.visible) return;

    // TODO Enable this again and find the issue that make it load again, again and again
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:self];

    [self.notificationViewController close];
}

- (void)displayNotification:(NSString *)text animated:(BOOL)animated {
    if (self.notificationViewController.visible) return;
    [self.notificationViewController openWithText:text animated:animated];
}

#pragma mark - Overrides
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.notificationViewController = [[XipNotificationViewController alloc] initWithViewController:viewController];
    [super pushViewController:self.notificationViewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(![[HTTP instance] isConnectionAvailable]) {
        [(DefaultNavigationController *)navigationController displayNotification:@"No internet connection" animated:NO];
    }
}

@end
