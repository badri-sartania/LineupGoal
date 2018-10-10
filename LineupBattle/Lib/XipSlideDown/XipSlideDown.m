//
// Created by Anders Hansen on 05/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "XipSlideDownVCDelegate.h"
#import "XipSlideDown.h"

@interface XipSlideDown ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *overlayButton;

@end


@implementation XipSlideDown

- (void)setup {
    [self addViewController:self.mainViewController];
    [self addViewController:self.topViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildViewController:self.mainViewController];

    self.mainViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];

    self.overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.overlayButton];
    self.overlayButton.backgroundColor = [UIColor clearColor];
    [self.overlayButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
}

- (void)toggle {
    if (self.isOpen) {
        [self close];
    } else {
        [self open];
    }
}

- (void)setupTopViewController {
    [self addChildViewController:self.topViewController];
    [self.view insertSubview:self.topViewController.view aboveSubview:self.view];
    [self.topViewController didMoveToParentViewController:self];
}

- (void)open {
    
    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topWillOpen)])
        [self.slideVCDelegate topWillOpen];

    CGRect frame                = self.topViewController.view.frame;
    frame.origin.y              = 0;

    CGRect frame2                = self.view.frame;
    frame2.origin.y              = self.topViewController.view.bounds.size.height;


    [UIView animateWithDuration:0.3f
            delay:0
            options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent)
            animations:^{
                self.topViewController.view.frame = frame;
                self.mainViewController.view.frame = frame2;
            }
            completion:^(BOOL finished) {}];

    self.overlayButton.frame = frame2;
    self.isOpen = YES;
    self.overlayButton.hidden = NO;

    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topDidOpen)])
    [self.slideVCDelegate topDidOpen];
}

- (void)close {
    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topWillClose)])
    [self.slideVCDelegate topWillClose];

    CGRect frame                = self.topViewController.view.frame;
    frame.origin.y              = -self.topViewController.view.bounds.size.height;

    CGRect frame2                = self.view.frame;
    frame2.origin.y              = 0;

    [UIView animateWithDuration:0.3f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent)
                     animations:^{
                         self.topViewController.view.frame = frame;
                         self.mainViewController.view.frame = frame2;
                     }
                     completion:^(BOOL finished) {}];

    self.isOpen = NO;
    self.overlayButton.hidden = YES;

    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topDidClose)])
        [self.slideVCDelegate topDidClose];
}


@end
