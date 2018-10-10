//
// Created by Anders Borre Hansen on 17/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/UIAlertView+BlocksKit.h>
#import "SCLAlertView.h"
#import "APNHelper.h"
#import "Identification.h"
#import "SimpleLocale.h"
#import "HexColors.h"


@implementation APNHelper
+ (void)doubleConfirmationWithTitle:(NSString *)title message:(NSString *)message accepted:(void (^)())success {
	[self doubleConfirmationWithTitle:title message:message accepted:success declined:nil];
}

+ (void)doubleConfirmationWithTitle:(NSString *)title message:(NSString *)message accepted:(void (^)())success declined:(void (^)())declined {
	if (![Identification APNDialogShown]) {
		UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:title message:message];
		[alert bk_addButtonWithTitle:@"No" handler:^{
			if (declined) declined();
		}];
		[alert bk_addButtonWithTitle:@"Yes, thanks!" handler:^{
			if (success) success();
		}];
		[alert show];
	}
}

+ (void)showBattleNotificationControlsFor:(id)sself type:(void (^)(BattleNotificationControl))state title:(NSString *)title message:(NSString *)message {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = FadeIn;
    [alert setShouldDismissOnTapOutside:NO];
    [alert setCustomViewColor:[UIColor hx_colorWithHexString:@"#00711F"]];
    [alert addButton:[NSString stringWithFormat:@"All %@ in battle", [SimpleLocale USAlternative:@"games" forString:@"matches"]] actionBlock:^{
        state(BattleNotificationControlAllMatches);
    }];
    [alert addButton:[NSString stringWithFormat:@"%@ regarding my players", [SimpleLocale USAlternative:@"Games" forString:@"Matches"]] actionBlock:^{
        state(BattleNotificationControlLineupMatches);
    }];
    [alert addButton:[SimpleLocale USAlternative:@"No game notification" forString:@"No match notification"] actionBlock:^{
        state(BattleNotificationControlNoMatches);
    }];

    [alert showNotice:sself title:title subTitle:message closeButtonTitle:nil duration:0];
}

@end
