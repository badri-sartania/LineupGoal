//
// Created by Anders Borre Hansen on 13/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <UIScrollSlidingPages/TTScrollSlidingPagesController.h>
#import "FixedSizePageViewController.h"
#import "OnboardingPageViewController.h"
#import "PlayOnboardingViewController.h"
#import "SelectOnboardingViewController.h"
#import "WinningOnboardingViewController.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"
#import "SMPageControl.h"

@interface OnboardingPageViewController ()
@property(nonatomic, strong) UIImageView *imageChevronRight;
@property(nonatomic, strong) UIButton *buttonAdvance;
@property(nonatomic) int screenIndex;
@end

@implementation OnboardingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self.slider.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addSubPageControllers:@[
        @{
            @"controller": [[SelectOnboardingViewController alloc] init]
        },
        @{
            @"controller" : [[PlayOnboardingViewController alloc] init]
        },
        @{
            @"controller": [[WinningOnboardingViewController alloc] init]
        }
    ]];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView setBackgroundColor:[UIColor championsLeagueColor]];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@60);
    }];
    
    self.buttonAdvance = [[UIButton alloc] init];
    [bottomView addSubview:self.buttonAdvance];
    [self.buttonAdvance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomView);
    }];
    [self.buttonAdvance setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.buttonAdvance.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
    [self.buttonAdvance setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonAdvance addTarget:self
                           action:@selector(onAdvance)
                 forControlEvents:UIControlEventTouchUpInside];
    
    self.imageChevronRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_right_arrow_white"]];
    [self.buttonAdvance addSubview:self.imageChevronRight];
    [self.imageChevronRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonAdvance);
        make.right.equalTo(self.buttonAdvance).offset(-20);
    }];

    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"img_page_indicator"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"img_active_page_indicator"];
    [pageControl sizeToFit];
    [self.view addSubview:pageControl];

    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-110);
        make.width.equalTo(@120);
    }];

    [self.slider setPageControl:(UIPageControl *)pageControl];
    self.slider.delegate = self;
    self.screenIndex = 0;
}

#pragma mark - Button Action
-(void) onAdvance {
    if (self.screenIndex > 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OnboardingCompleted"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.slider scrollToPage:self.screenIndex + 1 animated:YES];
    }
}

#pragma mark - Scroll delegate

-(void)didScrollToViewAtIndex:(NSUInteger)index {
    self.screenIndex = (int)index;
    self.imageChevronRight.hidden = index > 1;
    if (index > 1) {
        [self.buttonAdvance setTitle:@"LET'S GO" forState:UIControlStateNormal];
    } else {
        [self.buttonAdvance setTitle:@"NEXT" forState:UIControlStateNormal];
    }
}

@end
