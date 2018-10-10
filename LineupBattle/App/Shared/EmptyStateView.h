//
// Created by Anders Borre Hansen on 27/08/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultLabel.h"

@interface EmptyStateView : UIView

@property(nonatomic, strong) DefaultLabel *headline;
@property(nonatomic, strong) DefaultLabel *desc;

- (void)showEmptyStateScreen:(NSString *)headline description:(NSString *)desc;

- (void)showEmptyStateScreen:(NSString *)headline;

- (void)hideEmptyStateScreen;
@end