//
// Created by Anders Borre Hansen on 06/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "SMPageControl.h"
#import "PageNavigationTitleView.h"
#import "FadeView.h"
#import "Utils.h"
#import "UIColor+Lineupbattle.h"
#import "HexColors.h"

@interface PageNavigationTitleView ()
@property (nonatomic, strong) UIScrollView *title;
@property (nonatomic, assign) NSInteger titleCount;
@end

@implementation PageNavigationTitleView {
    CGFloat offset;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        FadeView *fadeView = [[FadeView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height - 14)];
        [self addSubview:self.pageControl];
        [self addSubview:fadeView];
        [fadeView addSubview:self.title];
        self.title.userInteractionEnabled = NO;
        self.titleCount = 0;
        offset = 320.f;
    }

    return self;
}

#pragma mark - Views

- (UIScrollView *)title {
    if (!_title) {
        _title = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height - 14.f)];
        [_title setContentSize:CGSizeMake(200.f, self.bounds.size.height)];
    }

    return _title;
}

- (void) addTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([Utils screenWidth]/2.f * self.titleCount), 0.f, _title.bounds.size.width, _title.bounds.size.height)];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.titleCount = self.titleCount + 1;
    [_title addSubview:label];
}

- (SMPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[SMPageControl alloc] init];
        _pageControl.frame = CGRectMake((self.bounds.size.width/2.f)-25.f, 20.f, 50.f, 20.f);
        _pageControl.currentPage = 0;
        _pageControl.indicatorDiameter = 4.0f;
        _pageControl.indicatorMargin = 4.0f;
        _pageControl.pageIndicatorTintColor = [UIColor hx_colorWithHexString:@"#aaaaaa"];
        _pageControl.currentPageIndicatorTintColor = [UIColor actionColor];
    }

    return _pageControl;
}

- (void)setScrollContentOffset:(CGFloat)x {
    CGFloat contentOffset = ((320 * self.page) + x)/2.f;
    [self.title setContentOffset:CGPointMake(contentOffset, 0.f)];
}

@end
