//
// Created by Anders Hansen on 29/04/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "TrophiesView.h"
#import "TrophyView.h"


@implementation TrophiesView

- (void)setData:(NSArray *)trophies {
    // Remove all subviews
    if ([self subviews].count > 0) {
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    // Generate new ones
    NSArray *offsetDefinition = @[@(-100), @0, @100];
    NSUInteger trophyHeight = 0;

    for (NSUInteger i = 0; i < trophies.count; i++) {
        TrophyView *trophyView = [[TrophyView alloc] init];
        [trophyView setData:trophies[i]];
        [self addSubview:trophyView];

        NSUInteger line = i / 3;
        trophyHeight = (NSUInteger) (150 * line);
        NSUInteger offsetPosition = i % 3;

        NSNumber *offset = offsetDefinition[offsetPosition];

        [trophyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset([offset integerValue]);
            make.top.equalTo(@(trophyHeight));
            make.height.equalTo(@150);
            make.width.equalTo(@100);
        }];
    }

    // Adds extra 150 since array start at 0 and don't adds the first element
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(trophyHeight+150));
    }];
}

@end