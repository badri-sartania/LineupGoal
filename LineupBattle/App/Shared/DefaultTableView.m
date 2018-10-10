//
// Created by Anders Hansen on 26/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "DefaultTableView.h"
#import "NotificationOverlayView.h"
#import "Utils.h"


@interface DefaultTableView ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NotificationOverlayView *overlayView;
@end

@implementation DefaultTableView

@synthesize refreshControl = _refreshControl;

- (id)initWithDelegate:(id)delegate {
    self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self) {
        self.delegate = delegate;
        self.dataSource = delegate;
        self.defaultTableViewDelegate = delegate;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.separatorInset = UIEdgeInsetsZero;

        self.overlayView = [[NotificationOverlayView alloc] init];
        [self addSubview:self.overlayView];
        self.overlayView.hidden = YES;

        // Reload table if connected appears again
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadTableAfterNoInternetConnection)
                                                     name:@"RefreshData"
                                                   object:nil];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTableAfterNoInternetConnection {
    // This method should only call refreshTable is the overlay is visible.
    // The reason for this is that else it will be called when the application starts
    if (!self.overlayView.isHidden) {
        [self refreshTable];
    }
}

- (void)enableSpinner {
    [self addSubview:self.tableLoadingSpinner];
    [self startSpinner];
}

- (void)enableRefreshControl {
    [self addSubview:self.refreshControl];
}

#pragma mark - Refresh
- (void)refreshTable {
    if (self.defaultTableViewDelegate && [self.defaultTableViewDelegate respondsToSelector:@selector(refreshTable)])
        [self.defaultTableViewDelegate refreshTable];
}

#pragma mark - Spinner
- (void)startSpinner {
    [self.tableLoadingSpinner startAnimating];
}

- (void)stopSpinner {
    if([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }

    if (self.tableLoadingSpinner) [self.tableLoadingSpinner stopAnimating];
}

#pragma mark - Deselect selected cell
- (void)deselectCellSelection {
    NSIndexPath *indexPath = [self indexPathForSelectedRow];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark  - Views
- (UIActivityIndicatorView *)tableLoadingSpinner {
    if (!_tableLoadingSpinner) {
        _tableLoadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _tableLoadingSpinner.frame = CGRectMake(0, 20.f, [Utils screenWidth], 50.f);
    }

    return _tableLoadingSpinner;
}

- (UIRefreshControl *)refreshControl {
   if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
       [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
   }

   return _refreshControl;
}

- (void)setTableHeightBasedOnScrollView {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.contentSize.height));
    }];
}

- (void)setTableHeightBasedOnScrollViewWithFrame {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentSize.height);
}

- (void)enableNotificationOverlayWithImage:(UIImage *)image text:(NSString *)text {
    [self.overlayView setText:text image:image];
    self.overlayView.frame = self.bounds;
    self.overlayView.hidden = NO;
    [self.overlayView fadeIn];
}

- (void)disableNotificationOverlay {
    if (![self.overlayView isHidden]) {
        self.overlayView.hidden = YES;
    }
}

#pragma mark - Empty State

- (void)enableEmptyState {
    if (!self.emptyStateView) {
        self.emptyStateView = [[EmptyStateView alloc] init];
        self.emptyStateView.frame = CGRectMake(0, self.frame.size.height/3.f, self.frame.size.width, 100);
        [self addSubview:self.emptyStateView];
        self.emptyStateView.hidden = YES;
    }
}

@end
