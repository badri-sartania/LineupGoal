//
// Created by Anders Hansen on 21/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <UIScrollSlidingPages/TTScrollSlidingPagesController.h>
#import <UIScrollSlidingPages/TTSlidingPage.h>
#import "BlocksKit/NSArray+BlocksKit.h"
#import "FixedSizePageViewController.h"


@implementation FixedSizePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerHidden = YES;
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.disableUIPageControl = YES;
    self.slider.zoomOutAnimationDisabled = YES;
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.hideStatusBarWhenScrolling = YES;

    self.slider.dataSource = self;

    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];

    [self.slider setPageControl:(UIPageControl *)self.pageNavigation.pageControl];

    self.parentViewController.navigationItem.titleView = self.pageNavigation;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.slider triggerScrollViewRecalculation];
}

- (void)addSubPageControllers:(NSArray *)controllers {
    self.viewControllersCache = [controllers bk_map:^id(NSDictionary *controller) {
        [self.pageNavigation addTitle:controller[@"title"]];
        return controller[@"controller"];
    }];

    self.pageNavigation.pageControl.numberOfPages = self.viewControllersCache.count;
    self.pageNavigation.pageControl.currentPage = 0;

    [self.slider reloadPages];
}

#pragma mark TTSlidingPagesDataSource methods

- (TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index {

    UIViewController *controller = self.viewControllersCache[(NSUInteger)index];

    controller.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    TTSlidingPage *slide = [[TTSlidingPage alloc] initWithContentViewController:controller];

    return slide;
}

// ScrollView
- (int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return (int)self.viewControllersCache.count;
}

- (void)scrollViewDidScroller:(UIScrollView *)scrollView {
    [self.pageNavigation setScrollContentOffset:scrollView.contentOffset.x];
}

- (void)didScrollToViewAtIndex:(NSUInteger)index {
    // For some reason this method isn't optional, so lest just keep it as a no-op
}

- (UIViewController *)getCurrentViewController {
    return self.viewControllersCache[(NSUInteger)[self.slider getCurrentDisplayedPage]];
}

#pragma mark - View
- (PageNavigationTitleView *)pageNavigation {
    if (!_pageNavigation) {
        _pageNavigation = [[PageNavigationTitleView alloc] initWithFrame:CGRectMake(0,0,160,40)];
    }

    return _pageNavigation;
}

@end
