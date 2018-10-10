//
// Created by Thomas Watson on 20/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfiniteScrollView : UIScrollView
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) id dataSource;
- (id)initWithCellWidth:(CGFloat)cellWidth;
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forOffset:(NSInteger)offset;
- (NSArray *)cachedCellsForIdentifier:(NSString *)identifier;
- (id)objectAtVisibleIndex:(NSUInteger)index;
- (void)scrollToOffset:(NSInteger)offset animated:(BOOL)animated;
- (void)snapToCell;
@end

@protocol InfiniteScrollViewDelegate
- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView didSelectItemAtOffset:(NSInteger)offset;
@optional
- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@protocol InfiniteScrollViewDataSource
- (UIView *)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView cellForItemAtOffset:(NSInteger)offset;
@end
