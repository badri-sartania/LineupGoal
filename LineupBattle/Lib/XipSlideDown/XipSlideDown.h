//
// Created by Anders Hansen on 05/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XipSlideDownVCDelegate.h"

@interface XipSlideDown : UIViewController

@property (weak, nonatomic) id<XipSlideDownVCDelegate> slideVCDelegate;

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIViewController *mainViewController;
@property(nonatomic, assign) BOOL isOpen;

- (void)setup;
- (void)open;
- (void)toggle;
- (void)close;
- (void)setupTopViewController;
@end
