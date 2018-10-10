//
// Created by Anders Hansen on 14/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//


#import "FieldView.h"

@implementation FieldView

- (void)reloadData {
    [self removeSubviews];
    [self loadFieldViewItems];
}

- (void)removeSubviews {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)loadFieldViewItems {
    BOOL reversed = NO;
    NSInteger numberOfSections = 1;

    if ([self.delegate respondsToSelector:@selector(fieldViewShouldBeReversed:)]) {
        reversed = [self.delegate fieldViewShouldBeReversed:self];
    }

    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInFieldView:)]) {
        numberOfSections = [self.dataSource numberOfSectionsInFieldView:self];
    }

    // Load each sections
    for (int sectionIndex = 0; sectionIndex < numberOfSections; ++sectionIndex) {
        [self loadSectionWithIndex:sectionIndex reversed:reversed];
    }
}

- (void)loadSectionWithIndex:(NSInteger)sectionIndex reversed:(BOOL)reversed {
    NSInteger numberOfItemsForSection = [self.dataSource numberOfItemsForSectionInFieldView:self section:sectionIndex];

    // Default values for optional delegates
    CGFloat sectionYMargin = 10.f;
    CGFloat sectionHeight = 40.f;
    CGFloat itemWidth = 62.f;
    CGFloat itemXMargin = 20.f;

    // Section data fetching and calculation before each item is positioned
    // Delegate methods with respondsToSelector is optional
    if ([self.delegate respondsToSelector:@selector(fieldView:marginForSection:)]) {
        sectionYMargin = [self.delegate fieldView:self marginForSection:sectionIndex];
    }

    if ([self.delegate respondsToSelector:@selector(fieldView:heightForSection:)]) {
        sectionHeight = [self.delegate fieldView:self heightForSection:sectionIndex];
    }

    if ([self.delegate respondsToSelector:@selector(fieldView:heightForSection:)]) {
        itemWidth = [self.delegate fieldView:self heightForSection:sectionIndex];
    }

    if ([self.delegate respondsToSelector:@selector(fieldView:marginBetweenItemsInSection:)]) {
        itemXMargin = [self.delegate fieldView:self marginBetweenItemsInSection:sectionIndex];
    }

    // Calculate item total height and width with margins
    CGFloat totalItemWidth = itemWidth + itemXMargin;
    CGFloat totalItemHeight = sectionYMargin + sectionHeight;

    // xCenterOffset is how far the first element need to go to the left to center section elements
    CGFloat xCenterOffset = [self calculateXOffsetWithNumberItemsOfSection:numberOfItemsForSection totalItemWidth:totalItemWidth];

    for (int itemIndex = 0; itemIndex < numberOfItemsForSection; ++itemIndex) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];

        // Required delegate. Should crash if not set
        FieldItemView *fieldViewItem = [self.dataSource fieldView:self cellForRowAtIndexPath:indexPath];
        fieldViewItem.delegate = self;
        fieldViewItem.indexPath = indexPath;
        [self addSubview:fieldViewItem];

        // Calculate x offset and y position
        CGFloat xCenterItemOffset = xCenterOffset + totalItemWidth * indexPath.row;
        CGFloat yPosition = totalItemHeight * indexPath.section;

        if (reversed) {
            [fieldViewItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(yPosition));
                make.centerX.equalTo(self).offset(xCenterItemOffset);
                make.height.equalTo(@(sectionHeight));
                make.width.equalTo(@(itemWidth));
            }];
        } else {
            [fieldViewItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@(-yPosition));
                make.centerX.equalTo(self).offset(xCenterItemOffset);
                make.height.equalTo(@(sectionHeight));
                make.width.equalTo(@(itemWidth));
            }];
        }
    }
}

- (CGFloat)calculateXOffsetWithNumberItemsOfSection:(NSInteger)numberOfItemsForSection totalItemWidth:(CGFloat)totalItemWidth {
    CGFloat xOffset = 0;

    switch (numberOfItemsForSection % 2) {
        // 0 is even number of items.
        // The two most centered items must not be in center, but equal offset from center in each direction.
        case 0:
            xOffset = -(numberOfItemsForSection - 1) * totalItemWidth / 2;
            break;
        // 1 is uneven number of items. Must be one item with xOffset of 0
        case 1:
            // Special case if numberOfItemsForSection is 1 xOffset should be 0
            if (numberOfItemsForSection > 1) {
                xOffset = -((numberOfItemsForSection * totalItemWidth) / 2) + totalItemWidth/2;
            }
            break;
        default: break;
    }

    return xOffset;
}

#pragma mark - FieldItemViewDelegate proxy
- (void)buttonWasPressed:(FieldItemView *)fieldViewItem {
    [self.delegate fieldView:self didSelectFieldItemView:fieldViewItem];
}

- (void)captainButtonWasPressed:(FieldItemView *)fieldViewItem {
    if (self.delegate != nil)
        [self.delegate fieldView:self didSelectCaptainFieldItemView:fieldViewItem];
}

@end
