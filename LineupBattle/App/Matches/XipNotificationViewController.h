//
// Created by Anders Hansen on 10/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultLabel.h"


@interface XipNotificationViewController : UIViewController
@property(nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic) BOOL visible;

- (id)initWithViewController:(UIViewController *)mainViewController;
- (void)openWithText:(NSString *)text animated:(BOOL)animated;
- (void)close;
@end
