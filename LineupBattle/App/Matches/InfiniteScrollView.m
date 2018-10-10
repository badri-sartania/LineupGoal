//
// Created by Thomas Watson on 20/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "InfiniteScrollView.h"

@interface InfiniteScrollView () {
    NSMutableDictionary *_negativeCellCaches;
    NSMutableDictionary *_positiveCellCaches;
    NSMutableDictionary *_cellCachesClasses;
    NSMutableArray *_visibleCells;
    NSInteger _offsetAtFirstVisibleCell;
    CGFloat _contentWidth;
    CGFloat _cellWidth;
    CGFloat _optimalCenterOffsetX;
    CGFloat _maxAllowedDistanceFromCenter;
}

@end

static NSUInteger const MAX_CACHE_SIZE = 100;

// Note: The factor must be an equal number.
// This makes it easy to find an approximate horizontal content view center position that is
// still dividable by the width of the cell without having to resort to modulus calculations.
static CGFloat const WIDTH_FACTOR = 100.f;

@implementation InfiniteScrollView

- (id)initWithCellWidth:(CGFloat)cellWidth {
    self = [super init];

    if (self) {
        _cellWidth = cellWidth;
        _negativeCellCaches = [[NSMutableDictionary alloc] init];
        _positiveCellCaches = [[NSMutableDictionary alloc] init];
        _cellCachesClasses = [[NSMutableDictionary alloc] init];
        _visibleCells = [[NSMutableArray alloc] init];
        _offsetAtFirstVisibleCell = 0;
        _contentWidth = _cellWidth * WIDTH_FACTOR;
        _optimalCenterOffsetX = _contentWidth / 2.f;
        _maxAllowedDistanceFromCenter = _contentWidth / 4.f;

        self.contentSize = CGSizeMake(_contentWidth, _cellWidth);
        self.showsHorizontalScrollIndicator = NO;

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [self addGestureRecognizer:singleTap];
    }

    return self;
}

- (void)recenterIfNecessary {
    CGPoint currentOffset = self.contentOffset;
    CGFloat distanceFromCenter = fabs(currentOffset.x - _optimalCenterOffsetX);

    if (distanceFromCenter > _maxAllowedDistanceFromCenter) {
        // calculate best case left edge if we want to move cells by multitudes of the cell width
        CGFloat offsetOverage = fmodf(distanceFromCenter, _cellWidth);
        CGFloat centerOffsetX;

        // Determine the direction and apply the offset correctly
        if (_optimalCenterOffsetX - currentOffset.x > 0) {
            centerOffsetX = _optimalCenterOffsetX - offsetOverage;
        } else {
            centerOffsetX = _optimalCenterOffsetX + offsetOverage;
        }

        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);

        // move context by the same amount so it appears to stay still
        CGFloat movedDistanceX = centerOffsetX - currentOffset.x;
        for (UIView *cell in _visibleCells) {
            CGPoint center = cell.center;
            center.x += movedDistanceX;
            cell.center = center;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self recenterIfNecessary];

    // tile content in visible bounds
    CGRect visibleBounds = self.bounds;
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);

    [self tileCellsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}

#pragma mark - Cell cache
- (NSMutableArray *)createEmptyCache {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:MAX_CACHE_SIZE];
    for (NSUInteger i = 0; i < MAX_CACHE_SIZE; i++) {
        [arr addObject:[NSNull null]];
    }
    return arr;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    if (!_cellCachesClasses[identifier]) {
        _cellCachesClasses[identifier] = cellClass;
        _negativeCellCaches[identifier] = [self createEmptyCache];
        _positiveCellCaches[identifier] = [self createEmptyCache];
    }
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forOffset:(NSInteger)offset {
    NSMutableDictionary *caches = offset < 0 ? _negativeCellCaches : _positiveCellCaches;
    NSMutableArray *cache = caches[identifier];
    NSUInteger index = ((NSUInteger) ABS(offset)) % MAX_CACHE_SIZE;
    UIView *cell = cache[index];

    if ([cell isKindOfClass:[NSNull class]]) {
        Class cellClass = _cellCachesClasses[identifier];
        cell = (UIView *) [[cellClass alloc] init];
        cell.tag = INT_MAX;
        cache[index] = cell;
    }

    return cell;
}

- (NSArray *)cachedCellsForIdentifier:(NSString *)identifier {
    return [[_negativeCellCaches[identifier] arrayByAddingObjectsFromArray:_positiveCellCaches[identifier]] bk_reject:^BOOL(id obj) {
        return [obj isKindOfClass:[NSNull class]];
    }];
}

#pragma mark - Querying

- (id)objectAtVisibleIndex:(NSUInteger)index {
    CGFloat lower = self.contentOffset.x + _cellWidth * index;
    CGFloat upper = self.contentOffset.x + _cellWidth * (index + 1);
    CGPoint center = CGPointMake(_cellWidth / 2.f, 0.f);
    CGPoint centerPos;
    for (UIView *cell in _visibleCells) {
        centerPos = [self convertPoint:center fromView:cell];
        if (centerPos.x >= lower && centerPos.x < upper) return cell;
    }
    return nil;
}

- (NSInteger)offsetOfFirstCellWithinContentOffset {
    NSInteger offset = _offsetAtFirstVisibleCell;
    for (UIView *cell in _visibleCells) {
        bool visible = CGRectContainsPoint(cell.frame, self.contentOffset);
        if (visible) break;
        offset++;
    }
    return offset;
}

#pragma mark - cell math

- (CGFloat)normalizeContentOffset:(CGFloat)offset {
    CGFloat overage = fmodf(offset, _cellWidth);
    if (overage == 0.f) return offset;
    return [self roundContentOffset:offset fromOverage:overage];
}

- (CGFloat)roundContentOffset:(CGFloat)offset fromOverage:(CGFloat)overage {
    if (overage >= _cellWidth / 2.f)
        return offset + (_cellWidth - overage);
    else
        return offset - overage;
}

#pragma mark - Scroll actions

- (void)scrollToOffset:(NSInteger)offset animated:(BOOL)animated {
    CGFloat diff = (offset - [self offsetOfFirstCellWithinContentOffset] - 1) * _cellWidth;
    CGFloat newOffsetX = [self normalizeContentOffset:self.contentOffset.x + diff];
    CGPoint point = CGPointMake(newOffsetX, 0);
    [self setContentOffset:point animated:animated];
}

- (void)snapToCell {
    CGFloat offsetOverage = fmodf(self.contentOffset.x, _cellWidth);
    if (offsetOverage > 0.f) {
        CGFloat newOffset = [self roundContentOffset:self.contentOffset.x fromOverage:offsetOverage];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self setContentOffset:CGPointMake(newOffset, 0.f) animated:YES];
        [UIView commitAnimations];
    }
}

#pragma mark - Delegate

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    NSAssert(self.delegate, @"delegate not provided");

    CGPoint touchPoint = [gesture locationInView:self];

    NSInteger index = 0;
    for (UIView *cell in _visibleCells) {
        if (CGRectContainsPoint(cell.frame, touchPoint)) {
            CGFloat visualOffsetPx = cell.frame.origin.x - self.contentOffset.x;
            NSInteger visualOffset = (NSInteger)(visualOffsetPx / _cellWidth);
            NSInteger offset = [self offsetOfFirstCellWithinContentOffset] + visualOffset;
            [self.delegate infiniteScrollView:self didSelectItemAtOffset:offset];
            return;
        }
        index++;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:touchesEnded:withEvent:)]) {
        [self.delegate infiniteScrollView:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:touchesCancelled:withEvent:)]) {
        [self.delegate infiniteScrollView:self touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - Data

- (UIView *)insertCellAt:(NSInteger)offset {
    NSAssert(self.dataSource, @"dataSource not provided");

    UIView *cell = [self.dataSource infiniteScrollView:self cellForItemAtOffset:offset];
    [self addSubview:cell];

    return cell;
}

- (CGFloat)placeNewCellOnRight:(CGFloat)rightEdge {
    NSInteger offsetAtLastObject = _offsetAtFirstVisibleCell + _visibleCells.count;
    UIView *cell = [self insertCellAt:offsetAtLastObject];
    [_visibleCells addObject:cell];

    CGRect frame = cell.frame;
    frame.origin.x = rightEdge;
    frame.origin.y = self.bounds.size.height - frame.size.height;
    cell.frame = frame;

    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewCellOnLeft:(CGFloat)leftEdge {
    _offsetAtFirstVisibleCell--;
    UIView *cell = [self insertCellAt:_offsetAtFirstVisibleCell];
    [_visibleCells insertObject:cell atIndex:0];

    CGRect frame = cell.frame;
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = self.bounds.size.height - frame.size.height;
    cell.frame = frame;

    return CGRectGetMinX(frame);
}

- (void)tileCellsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    // make sure there's at least one cell
    if (_visibleCells.count == 0) {
        [self placeNewCellOnRight:minimumVisibleX];
    }

    // add cells that are missing on right side
    UIView *lastCell = [_visibleCells lastObject];
    CGFloat rightEdge = CGRectGetMaxX(lastCell.frame);
    while (rightEdge < maximumVisibleX) {
        rightEdge = [self placeNewCellOnRight:rightEdge];
    }

    // add cells that are missing on left side
    UIView *firstCell = _visibleCells[0];
    CGFloat leftEdge = CGRectGetMinX(firstCell.frame);
    while (leftEdge > minimumVisibleX) {
        leftEdge = [self placeNewCellOnLeft:leftEdge];
    }

    // remove cells that have fallen off right edge
    lastCell = [_visibleCells lastObject];
    while (lastCell.frame.origin.x > maximumVisibleX) {
        [lastCell removeFromSuperview];
        [_visibleCells removeLastObject];
        lastCell = [_visibleCells lastObject];
    }

    // remove cells that have fallen off left edge
    firstCell = _visibleCells[0];
    while (CGRectGetMaxX(firstCell.frame) < minimumVisibleX) {
        [firstCell removeFromSuperview];
        _offsetAtFirstVisibleCell++;
        [_visibleCells removeObjectAtIndex:0];
        firstCell = _visibleCells[0];
    }
}

@end