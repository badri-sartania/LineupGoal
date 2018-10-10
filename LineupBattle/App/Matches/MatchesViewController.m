//
// Created by Anders Borre Hansen on 26/11/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "MatchesViewController.h"
#import "CalendarCellView.h"
#import "Date.h"
#import "NSArray+BlocksKit.h"
#import "MatchesTableViewController.h"
#import "HTTP.h"
#import "NSDate+Lineupbattle.h"
#import "HexColors.h"
#import "HTTP+RAC.h"


@interface MatchesViewController () {
    NSDate *offsetZero;
    NSDateFormatter *dateFormatter;
    NSInteger _competitionDayCountOffsetStart;
    NSInteger _competitionDayCountOffsetEnd;
    CGFloat _lastContentOffsetXTitleCheck;
}

@property (nonatomic, strong) InfiniteScrollView *scrollView;
@property (nonatomic, strong) UIView *calendarView;
@property (nonatomic, strong) NSDictionary *competitionsDayCounts;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *todayButton;
@property (nonatomic, strong) NSDate *lastDay;
@end

@implementation MatchesViewController {
    BOOL calendarObserverIsLoaded;
}

- (id)init {
    self = [super init];
    if (self) {
        offsetZero = [NSDate date];
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        _competitionDayCountOffsetStart = -30;
        _competitionDayCountOffsetEnd = 30;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!calendarObserverIsLoaded) {
        @weakify(self);
        [RACObserve(self, competitionsDayCounts) subscribeNext:^(NSDictionary *counts) {
            @strongify(self);

            if (!counts) {
                [self loadCompetitionsDays];
                return;
            }

            NSArray *cells = [self.scrollView cachedCellsForIdentifier:@"calendarCell"];
            for (CalendarCellView *cell in cells) {
                NSString *dateStr = [[dateFormatter stringFromDate:cell.date] capitalizedString];
                NSNumber *competitionsCount = counts[dateStr];
                cell.competitionsCount = competitionsCount;
            }
        }];

        calendarObserverIsLoaded = true;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor hx_colorWithHexString:@"#ecf4e6"];

    // Navigationbar
    self.parentViewController.navigationItem.backBarButtonItem = self.backButton;
    self.parentViewController.navigationItem.rightBarButtonItem = self.todayButton;

    // Add Subviews
    [self.view addSubview:self.calendarView];

    MatchesTableViewController *initialPage = [[MatchesTableViewController alloc] initWithDate:[YLMoment now]];
    [self setup:initialPage];

    [self defineMASLayout];
    [self setNavBarTitleBasedOnDate:offsetZero];
}

- (void)loadCompetitionsDays {
    [self loadCompetitionDayCountsFrom:_competitionDayCountOffsetStart To:_competitionDayCountOffsetEnd];
}

- (void)loadCompetitionDayCountsFrom:(NSInteger)from To:(NSInteger)to {
    // Build request start and end date for calendar dates
    NSString *start = [Date getRequestDateFormat:[[YLMoment momentWithDate:offsetZero] addAmountOfTime:from forCalendarUnit:NSCalendarUnitDay].date];
    NSString *end   = [Date getRequestDateFormat:[[YLMoment momentWithDate:offsetZero] addAmountOfTime:to forCalendarUnit:NSCalendarUnitDay].date];

    @weakify(self);
    [[[[[HTTP instance] fetchLeagueCountByDayByRange:start endDateString:end] map:^id(NSArray *result) {
        @strongify(self);
        NSMutableDictionary *dict = [self.competitionsDayCounts mutableCopy] ?: [[NSMutableDictionary alloc] init];
        [result bk_each:^(NSDictionary *obj) {
            dict[obj[@"date"]] = obj[@"count"];
        }];
        return dict;
    }] catch:^RACSignal *(NSError *error) {
        return [RACSignal empty];
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.competitionsDayCounts = x;
    }];
}

- (void)fetchMoreDotsIfNecessaryAtOffset:(NSInteger)offset {
    // Check if the cache of competition day-counts should be updated
    if (offset < _competitionDayCountOffsetStart + 10) {
        _competitionDayCountOffsetStart -= 60;
        [self loadCompetitionDayCountsFrom:_competitionDayCountOffsetStart To:_competitionDayCountOffsetStart + 60];
    } else if (offset > _competitionDayCountOffsetEnd - 10) {
        _competitionDayCountOffsetEnd += 60;
        [self loadCompetitionDayCountsFrom:_competitionDayCountOffsetStart To:_competitionDayCountOffsetEnd + 60];
    }
}

- (void)defineMASLayout {
    UIView *superview = self.view;

    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@([CalendarCellView height]));
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.calendarView);
    }];

    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_bottom);
        make.bottom.equalTo(superview);
        make.left.equalTo(superview);
        make.right.equalTo(superview);
    }];
}

- (void)setNavBarTitleBasedOnDate:(NSDate *)date {
    self.parentViewController.navigationItem.title = [[YLMoment momentWithDate:date] format:@"MMMM yyyy"];
}

- (void)todayButtonAction {
    if (![self.currentPage.date.date isToday]) {
        NSDate *today = [NSDate date];
        [self scrollToDate:today];
        [self removeAndAddNewPageViewWithDate:today];
    }
}

#pragma mark - PageController overrides

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    YLMoment *newDate = [[YLMoment momentWithDate:self.currentPage.date.date] addAmountOfTime:-1 forUnitKey:@"d"];
    return [[MatchesTableViewController alloc] initWithDate:newDate];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    YLMoment *newDate = [[YLMoment momentWithDate:self.currentPage.date.date] addAmountOfTime:+1 forUnitKey:@"d"];
    return [[MatchesTableViewController alloc] initWithDate:newDate];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        MatchesTableViewController *currentPage = [pageViewController.viewControllers lastObject];
        [self scrollToDate:currentPage.date.date];
    }
}

#pragma mark - Infinite Scroll View data source

- (UIView *)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView cellForItemAtOffset:(NSInteger)offset {
    CalendarCellView *cell = [infiniteScrollView dequeueReusableCellWithReuseIdentifier:@"calendarCell" forOffset:offset];

    if (cell.tag != offset) {
        cell.tag = offset;

        NSTimeInterval seconds = 60 * 60 * 24 * (offset-1); // -1 because we want today to be the 2nd cell
        NSDate *date = [offsetZero dateByAddingTimeInterval:seconds];
        [cell setDate:date];

        NSString *dateStr = [[dateFormatter stringFromDate:date] capitalizedString];
        NSNumber *competitionsCount = self.competitionsDayCounts[dateStr];
        cell.competitionsCount = competitionsCount;
    }

    [self fetchMoreDotsIfNecessaryAtOffset:offset];

    return cell;
}

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // If a user hinders the scroll view in snapping to a cell by pressing down while it's snapping,
    // but doesn't initiate a new scroll (i.e. just releasing the press), the scroll view stays
    // un-snapped. Let's handle that edge case.
    [self.scrollView snapToCell];
}

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Some times the cancelled event triggers even though we're still dragging the scroll view.
    // In that case we just ignore it as we don't want to snap while the user is dragging.
    if (!infiniteScrollView.dragging)
        // If a user hinders the scroll view in snapping to a cell by pressing down while it's snapping,
        // but doesn't initiate a new scroll (i.e. just releasing the press), the scroll view stays
        // un-snapped. Let's handle that edge case.
        [self.scrollView snapToCell];
}

#pragma mark - Collection View config

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView didSelectItemAtOffset:(NSInteger)offset {
    [self.scrollView scrollToOffset:offset animated:YES];

    NSTimeInterval seconds = 60 * 60 * 24 * (offset-1);
    NSDate *date = [offsetZero dateByAddingTimeInterval:seconds];
    [self removeAndAddNewPageViewWithDate:date];
}

- (NSInteger)getOffsetFromDate:(NSDate *)date {
    NSTimeInterval seconds = [[[YLMoment momentWithDate:date] startOf:@"d"].date timeIntervalSinceDate:[[YLMoment momentWithDate:offsetZero] startOf:@"d"].date];
    return (NSInteger)(seconds / 60 / 60 / 24) + 1; // +1 because we want to target the 2nd cell
}

- (void)scrollToDate:(NSDate *)date {
    NSInteger offset = [self getOffsetFromDate:date];
    [self.scrollView scrollToOffset:offset animated:YES];
}

- (MatchesTableViewController *)currentPage {
    return (MatchesTableViewController *)[self.pageController.viewControllers lastObject];
}

- (void)fetchSelectedDate {
    CalendarCellView *cell = [self.scrollView objectAtVisibleIndex:1];
    if (cell && ![[[YLMoment momentWithDate:cell.date] startOf:@"d"].date isEqualToDate:self.lastDay])
        [self removeAndAddNewPageViewWithDate:cell.date];
}

- (void)removeAndAddNewPageViewWithDate:(NSDate *)date {
    MatchesTableViewController *matchesTableViewController = [[MatchesTableViewController alloc] initWithDate:[YLMoment momentWithDate:date]];
    [self.pageController setViewControllers:@[matchesTableViewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}

#pragma mark - Scroll Events for InfiniteScrollView

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // if decelerate is YES, we don't need to take care of it here.
    // It will instead be handled in `scrollViewDidEndDecelerating:`
    if (!decelerate) {
        [self.scrollView snapToCell];
        [self performSelector:@selector(fetchSelectedDate) withObject:nil afterDelay:0.3];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.x != 0.f) {
        CGFloat unguidedOffset = targetContentOffset->x;
        CGFloat guidedOffset;
        CGFloat cellWidth = [CalendarCellView width];
        CGFloat remainder = fmodf(unguidedOffset, cellWidth);

        if (remainder < cellWidth / 2.f)
            guidedOffset = unguidedOffset - remainder;
        else
            guidedOffset = unguidedOffset - remainder + cellWidth;

        targetContentOffset->x = guidedOffset;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self fetchSelectedDate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // check if we have moved more than half the width of a cell since last
    if (fabs(_lastContentOffsetXTitleCheck - scrollView.contentOffset.x) > [CalendarCellView width] / 2.f) {
        _lastContentOffsetXTitleCheck = scrollView.contentOffset.x;
        CalendarCellView *cell = [self.scrollView objectAtVisibleIndex:1];
        if (cell) [self setNavBarTitleBasedOnDate:cell.date];
    }
}

#pragma mark - Views

- (UIView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[UIView alloc] init];
        _calendarView.backgroundColor = [UIColor hx_colorWithHexString:@"#ecf4e6"];

        UIView *selectionColorView = [[UIView alloc] initWithFrame:CGRectMake([CalendarCellView width] + 0.5f, 0.f, [CalendarCellView width] - 0.5f, [CalendarCellView height] + 1.f)];
        selectionColorView.backgroundColor = [UIColor whiteColor];
        [_calendarView addSubview:selectionColorView];

        [_calendarView addSubview:self.scrollView];
    }

    return _calendarView;
}

- (InfiniteScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[InfiniteScrollView alloc] initWithCellWidth:[CalendarCellView width]];
        _scrollView.dataSource = self;
        _scrollView.delegate = self;

        [_scrollView registerClass:[CalendarCellView class] forCellWithReuseIdentifier:@"calendarCell"];
    }

    return _scrollView;
}

- (UIBarButtonItem *)backButton {
    if (!_backButton) {
        _backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }

    return _backButton;
}

- (UIBarButtonItem *)todayButton {
    if (!_todayButton) {
        _todayButton = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(todayButtonAction)];
    }

    return _todayButton;
}

@end
