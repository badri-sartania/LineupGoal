//
//  AppDelegate.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 25/11/13.
//  Copyright (c) 2013 xip. All rights reserved.
//

#import "AppDelegate.h"
#import "MatchesTableViewController.h"
#import "HTTP.h"
#import "Mixpanel.h"
#import "XipSlideDown.h"
#import "Identification.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Utils.h"
#import "UIAlertView+BlocksKit.h"
#import "NSDate+LineupBattle.h"
#import "HelpshiftCore.h"
#import "Configuration.h"
#import "DefaultNavigationController.h"
#import "Date.h"
#import "MoreTableViewController.h"
#import "RewardsCollectionViewController.h"
#import "MatchPageViewController.h"
#import "Fabric.h"
#import "Crashlytics.h"
#import "BattlesTableViewController.h"
#import "BattleViewModel.h"
#import "BattleViewController.h"
#import "OnboardingPageViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <StoreKit/StoreKit.h>
#import "UIColor+Lineupbattle.h"
#import "Shop.h"
#import "SimpleLocale.h"
#import "ChallengesTableViewController.h"
#import "HTTP+LineupBattle.h"
#import "HelpshiftSupport.h"
#import "LeaderboardViewController.h"

#ifdef STAGING
    #import <BuddyBuildSDK/BuddyBuildSDK.h>
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #ifdef STAGING
        [BuddyBuildSDK setup];
    #endif

    /***************************/
    /** External plugin setup **/
    /***************************/

	#ifdef DEBUG
		Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:@"47b99a12dd9b62c5c58a893ea5821fae"];
	#else
        Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:[Utils stringInMainBundleForKey:@"MixpanelAccessToken"]];
    #endif

    BOOL newUser = ![mixpanel.distinctId isEqualToString:[Identification userId]];

    #if !TARGET_IPHONE_SIMULATOR
        [Fabric with:@[CrashlyticsKit]];
        [[Crashlytics sharedInstance] setUserIdentifier:[Identification userId]];
        [[Crashlytics sharedInstance] setObjectValue:[Date timezone] forKey:@"timezone"];
        [[Crashlytics sharedInstance] setObjectValue:[[YLMoment now] format] forKey:@"localtime"];
    #endif

    [HelpshiftCore initializeWithProvider:[HelpshiftSupport sharedInstance]];
    [HelpshiftCore installForApiKey:@"818319b3767a570a6255f27aaf07dfdd" domainName:@"champion.helpshift.com" appID:@"champion_platform_20150411212946267-c3de365df30ebf4"];
    [HelpshiftSupport setUserIdentifier:[Identification userId]];

    [mixpanel identify:[Identification userId]];
    [mixpanel.people set:@{
        @"$username": [Identification userId]
    }];
    if (newUser) {
      [mixpanel track:@"First App Open"];
    }

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    /***************************/
    /**        Settings       **/
    /***************************/
    [Configuration clearConfigurationIfAppUpdated];

    /***************************/
    /** Navigationbar styling **/
    /***************************/

    [[UITabBar appearance] setTintColor:[UIColor primaryColor]];

    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [UIColor tabColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10.0]
                                 };
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *selectedAttributes = @{NSForegroundColorAttributeName: [UIColor primaryColor]};
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    /***************************/
    /**        Window         **/
    /***************************/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Add Main stack
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController.tabBar.layer setBorderWidth:1.0];
    [self.tabBarController.tabBar.layer setBorderColor:[UIColor tabColor].CGColor];
    [self.tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
    
    self.window.rootViewController = self.tabBarController;
    
    BOOL onboardingCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"OnboardingCompleted"];
    
    if (!onboardingCompleted && ![self isRunningTests]) {
        OnboardingPageViewController *onboarding = [[OnboardingPageViewController alloc] init];
        [self.window.rootViewController presentViewController:onboarding animated:NO completion:^{
           self.tabBarController.viewControllers = [self initializeTabBarItems];
        }];
    } else {
        self.tabBarController.viewControllers = [self initializeTabBarItems];
    }

    /***************************/
    /**          APN          **/
    /***************************/
    [self validateApnSettings];

    if ([Identification apnDeviceToken]) {
        [[HTTP instance] sendAPNDeviceToken:[Identification apnDeviceToken]];
    }

    /***************************/
    /**       Payments        **/
    /***************************/
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[Shop instance]];

    // If the user tabbed a Push Notification to open the app, handle it accordingly
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }

    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSArray *)initializeTabBarItems {

    // Initialize view controllers
//    LeaderboardTableViewController *leaderboardTableViewController = [[LeaderboardTableViewController alloc] init];
    LeaderboardViewController *leaderboardTableViewController = [[LeaderboardViewController alloc] init];
    BattlesTableViewController *gamesTableViewController = [[BattlesTableViewController alloc] init];
    RewardsCollectionViewController *rewardsViewController = [[RewardsCollectionViewController alloc] init];
//    UltimateXIViewController * ultimateXIViewController = [UltimateXIViewController controller];

    // Initialize navigation controllers
//    DefaultNavigationController *ultimateXINavigationController = [[DefaultNavigationController alloc] initWithRootViewController:ultimateXIViewController];
    UltimateXINavigationController * ultimateXINavigationController = [[UIStoryboard storyboardWithName:@"UltimateXI" bundle:nil] instantiateInitialViewController];
    
    DefaultNavigationController *leaderboardNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:leaderboardTableViewController];
    DefaultNavigationController *gamesNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:gamesTableViewController];
    DefaultNavigationController *rewardsNavigationController = [[DefaultNavigationController alloc] initWithRootViewController:rewardsViewController];

    gamesNavigationController.tabBarItem.title = @"Games";
    gamesNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_game"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gamesNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_game_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [gamesNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];

    leaderboardNavigationController.tabBarItem.title = @"Leaderboard";
    leaderboardNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_leaderboard"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    leaderboardNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_leaderboard_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leaderboardNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];

//    ultimateXINavigationController.tabBarItem.title = [SimpleLocale USAlternative:@"Ultimate XI" forString:@"Ultimate XI"];
//    ultimateXINavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_xi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    ultimateXINavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_xi_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [ultimateXINavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];

//    moreNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
    rewardsNavigationController.tabBarItem.title = @"Rewards";
    rewardsNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_rewards"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    rewardsNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_rewards_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [rewardsNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];

    return @[
       gamesNavigationController,
       ultimateXINavigationController,
       leaderboardNavigationController,
       rewardsNavigationController
    ];
}

- (void)validateApnSettings {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL apnDialogShown = [settings boolForKey:@"APNDialogShown"];
    BOOL apnDisabled = [settings boolForKey:@"APNDisabled"];
    NSDate *apnRemindMeAfter = [settings objectForKey:@"APNRemindMeAfter"];

    if ((NSInteger)[Utils remoteNotificationLevel] >= 4) {
        // APN alerts is currently enabled
        if (apnDisabled)
            // APN have previously been disabled - let's remove that fact
            [settings removeObjectForKey:@"APNDisabled"];

        // Let's check for a new device-token
        [Utils registerForAPN];
    } else if (apnDialogShown && !apnDisabled && [apnRemindMeAfter isInThePast]) {
        // APN have been disabled in system settings and the user haven't confirmed that this is intentional - Notify
        // the user of this newly discovered issue
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"Notifications Are Disabled"
                                                        message:
                                                        [NSString stringWithFormat:@"To receive %@ alerts, go to 'Notification Center' in the Settings app and enable alerts for the Lineupbattle app", [SimpleLocale USAlternative:@"game" forString:@"match"]]];
        [alert bk_addButtonWithTitle:@"Dismiss" handler:^{
            [settings setBool:YES forKey:@"APNDisabled"];
        }];
        [alert bk_addButtonWithTitle:@"Remind me later" handler:^{
            NSTimeInterval twoDays = 60*60*24*2;
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:twoDays];
            [settings setObject:date forKey:@"APNRemindMeAfter"];
        }];
        [alert show];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"App Open"];
    [mixpanel.people increment:@"App Opens" by:@1];

    [FBSDKAppEvents activateApp];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *newToken = [[[[deviceToken description]
            stringByReplacingOccurrencesOfString: @"<" withString: @""]
            stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *oldToken = [settings objectForKey:@"APNDeviceToken"];

    if (![newToken isEqualToString:oldToken]) {
        [[HTTP instance] sendAPNDeviceToken:newToken];
        [HelpshiftCore registerDeviceToken:deviceToken];
        [[Mixpanel sharedInstance].people addPushDeviceToken:deviceToken];

        [settings setBool:YES forKey:@"APNEnabledOnce"];
        [settings setObject:newToken forKey:@"APNDeviceToken"];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL apnEnabledOnce = [settings boolForKey:@"APNEnabledOnce"];

    // We only want to show an error message if the request for APN was initiated by the user. Since we cannot tell that
    // inside this method, we have to rely on the absence of the `APNEnabledOnce` setting, in which case the failed
    // request most likely was initiated by the user
    if (!apnEnabledOnce) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Push Notifications Error"
                                                        message:
                                                        [NSString stringWithFormat:@"Failed to register for Push Notitications. This means that we unfortunately cannot send you any %@ alerts at the moment. Please try again later.", [SimpleLocale USAlternative:@"game" forString:@"match"]]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        CLS_LOG(@"Failed to register for Push Notitications dialog");
        [alert show];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    CLS_LOG(@"didReceiveRemoteNotification");
    if ([userInfo[@"origin"] isEqualToString:@"helpshift"]) {
        [HelpshiftCore handleRemoteNotification:userInfo withController:self.window.rootViewController];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    } else if ((userInfo[@"match"] || userInfo[@"battle"] || [userInfo[@"type"] isEqualToString:@"invite"]) && application.applicationState != UIApplicationStateActive) {
        [self loadAPNDestination:userInfo];
    } else {
        NSString *message = [userInfo[@"type"] isEqualToString:@"match"] ? [SimpleLocale USAlternative:@"Game update" forString:@"Match update"] : @"Battle update";

        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:message message:userInfo[@"aps"][@"alert"]];
        [alert bk_addButtonWithTitle:@"Show me" handler:^{
            [self loadAPNDestination:userInfo];
        }];
        [alert bk_addButtonWithTitle:@"Dismiss" handler:^{}];
        [alert show];
    }
}

- (void)loadAPNDestination:(NSDictionary *)userInfo {
    CLS_LOG(@"loadAPNDestination %@", userInfo);

    if ([userInfo[@"type"] isEqualToString:@"invite"]) {
        // Step 1: Dismiss all presented viewControllers
        [self.tabBarController dismissViewControllerAnimated:NO completion:nil];
        
        // Step 2: Ensure we are on the match tab
        [self.tabBarController setSelectedIndex:0];
        
        DefaultNavigationController *visibleViewController = (DefaultNavigationController *) [self.tabBarController selectedViewController];
        [visibleViewController pushViewController:[[ChallengesTableViewController alloc] init] animated:NO];
    } else if (userInfo[@"battle"]) {
        [self trackAPN:userInfo];

        // Step 1: Dismiss all presented viewControllers
        [self.tabBarController dismissViewControllerAnimated:NO completion:nil];

        // Step 2: Ensure we are on the battle tab
        [self.tabBarController setSelectedIndex:0];

        // Step 3: Load battle
        DefaultNavigationController *visibleViewController = (DefaultNavigationController *)[self.tabBarController selectedViewController];
        BattleViewModel *viewModel = [[BattleViewModel alloc] initWithBattleId:userInfo[@"battle"]];
        BattleViewController *battleViewController = [[BattleViewController alloc] initWithViewModel:viewModel];

        // Step 4: Remove battle if visible
        if ([[visibleViewController visibleViewController] isKindOfClass:[XipNotificationViewController class]]) {
            XipNotificationViewController *notificationViewController = ((XipNotificationViewController *)[visibleViewController visibleViewController]);

            if ([notificationViewController.mainViewController isKindOfClass:[BattleViewController class]]) {
                [visibleViewController popViewControllerAnimated:NO];
            }
        }

        // Step 5: Push battle
        [visibleViewController pushViewController:battleViewController animated:NO];

        // Step 5: Show match
        if (userInfo[@"match"]) {
            Match *match = [Match dictionaryTransformer:@{@"_id" : userInfo[@"match"]}];
            [visibleViewController pushViewController:[self matchPageControllerWithMatch:match] animated:NO];
        }
    } else if (userInfo[@"match"]) {
        [self trackAPN:userInfo];

        // Step 1: Dismiss all presented viewControllers
        [self.tabBarController dismissViewControllerAnimated:NO completion:nil];

        // Step 2: Ensure we are on the match tab
        [self.tabBarController setSelectedIndex:0];

        // Step 3: Load match
        Match *match = [Match dictionaryTransformer:@{@"_id" : userInfo[@"match"]}];
        DefaultNavigationController *visibleViewController = [self.tabBarController selectedViewController];

        // Step 4: Remove match if visible
        if ([[visibleViewController visibleViewController] isKindOfClass:[XipNotificationViewController class]]) {
            XipNotificationViewController *notificationViewController = (XipNotificationViewController *)[visibleViewController visibleViewController];

            if ([notificationViewController.mainViewController isKindOfClass:[DefaultSubscriptionViewController class]]) {
                DefaultSubscriptionViewController *subscriptionViewController = (DefaultSubscriptionViewController *)notificationViewController.mainViewController;

                if ([subscriptionViewController.mainViewController isKindOfClass:[MatchPageViewController class]]) {
                    [visibleViewController popViewControllerAnimated:NO];
                }
            }
        }

        // Step 5: Push match
        [visibleViewController pushViewController:[self matchPageControllerWithMatch:match] animated:NO];
    }
}

- (void)trackAPN:(NSDictionary *)userInfo {
    [[Mixpanel sharedInstance] track:@"APN" properties:@{
        @"type" : userInfo[@"type"] ?: [NSNull null],
        @"battleId" : userInfo[@"battle"] ?: [NSNull null],
        @"matchId" : userInfo[@"match"] ?: [NSNull null]
    }];
    
#if !TARGET_IPHONE_SIMULATOR
    [Answers logCustomEventWithName:@"APN" customAttributes:@{
        @"type" : userInfo[@"type"] ?: [NSNull null],
        @"battleId" : userInfo[@"battle"] ?: [NSNull null],
        @"matchId" : userInfo[@"match"] ?: [NSNull null]
    }];
#endif
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];

    return handled;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    return handled;
}

- (DefaultSubscriptionViewController *)matchPageControllerWithMatch:(Match *)match {
    return [[[MatchPageViewController alloc] initWithMatch:match] wrapInSubscriptionViewController];
}

-(void)onConversionDataRequestFailure:(NSError *) error {
    CLS_LOG(@"%@",error);
}

- (BOOL)isRunningTests {
    static BOOL runningTests;
    static dispatch_once_t onceToken;
    
    // Only check once
    dispatch_once(&onceToken, ^{
        NSDictionary* environment = [[NSProcessInfo processInfo] environment];
        runningTests = environment[@"isUITest"];
    });
    return runningTests;
}

@end
