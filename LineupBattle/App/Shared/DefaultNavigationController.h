//
//  DefaultNavigationController.h
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 01/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XipNotificationViewController.h"

@interface DefaultNavigationController : UINavigationController <UINavigationControllerDelegate>

- (void)displayNotification:(NSString *)text animated:(BOOL)animated;
@end
