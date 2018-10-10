//
// Created by Anders Borre Hansen on 06/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPageControl.h"


@interface AbstractPageViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageController;

// Required
- (void)setup:(UIViewController *)initialViewController;

@end