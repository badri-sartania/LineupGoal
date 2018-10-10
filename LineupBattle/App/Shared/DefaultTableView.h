//
// Created by Anders Hansen on 26/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultTableViewDelegate.h"
#import "EmptyStateView.h"


@interface DefaultTableView : UITableView
@property (weak, nonatomic) id <DefaultTableViewDelegate> defaultTableViewDelegate;
@property (nonatomic, strong) UIActivityIndicatorView *tableLoadingSpinner;
@property(nonatomic) EmptyStateView *emptyStateView;

- (id)initWithDelegate:(id)delegate;
- (void)enableSpinner;
- (void)enableRefreshControl;
- (void)deselectCellSelection;
- (void)setTableHeightBasedOnScrollView;
- (void)setTableHeightBasedOnScrollViewWithFrame;
- (void)enableNotificationOverlayWithImage:(UIImage *)image text:(NSString *)text;
- (void)disableNotificationOverlay;

- (void)enableEmptyState;
- (void)startSpinner;
- (void)stopSpinner;

@end