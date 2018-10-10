//
// Created by Anders Borre Hansen on 06/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PageNavigationTitleView : UIView
@property (nonatomic, strong) SMPageControl *pageControl;
@property(assign) NSInteger page;

- (void)addTitle:(NSString *)title;

- (void)setScrollContentOffset:(CGFloat)y;
@end