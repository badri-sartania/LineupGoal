//
// Created by Anders Borre Hansen on 26/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AbstractPageViewController.h"
#import "InfiniteScrollView.h"

@interface MatchesViewController : AbstractPageViewController <InfiniteScrollViewDelegate, InfiniteScrollViewDataSource, UIScrollViewDelegate>
@end
