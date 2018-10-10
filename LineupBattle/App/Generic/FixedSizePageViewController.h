//
// Created by Anders Hansen on 21/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractPageViewController.h"
#import "PageNavigationTitleView.h"
#import "TTSlidingPagesDataSource.h"
#import "TTSliddingPageDelegate.h"


@interface FixedSizePageViewController : UIViewController <TTSlidingPagesDataSource, TTSliddingPageDelegate>
@property(nonatomic, strong) NSArray *viewControllersCache;
@property(nonatomic, strong) PageNavigationTitleView *pageNavigation;
@property(nonatomic, strong) TTScrollSlidingPagesController *slider;

- (void)addSubPageControllers:(NSArray *)controllers;

- (UIViewController *)getCurrentViewController;
@end