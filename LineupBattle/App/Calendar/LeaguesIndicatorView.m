//
//  LeaguesIndicatorView.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 02/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import "LeaguesIndicatorView.h"
#import "HexColors.h"

@interface LeaguesIndicatorView ()
@property (nonatomic, strong) NSArray *dots;
@end

static UIColor *clearColor = nil;
static UIColor *grayColor = nil;

@implementation LeaguesIndicatorView

- (id)initWithCompetitionCount:(NSUInteger)count andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        clearColor = [UIColor clearColor];
        grayColor = [UIColor hx_colorWithHexString:@"#96a5a6"];
        self.backgroundColor = clearColor;

        [self setCompetitionCount:count];
    }

    return self;
}

- (void)setCompetitionCount:(NSUInteger)count {
    NSMutableArray *dots = [[NSMutableArray alloc] initWithCapacity:count];

    for (NSUInteger i = 0; i < count; i++) {
        [dots addObject:grayColor];
    }

    self.dots = dots;
}

- (void)updateCompetitionCount:(NSUInteger)count {
    if (self.dots.count == count) return;
    [self setCompetitionCount:count];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self drawDots];
}

- (void)drawDots {
    if (!self.dots.count) return;

    static NSUInteger const maxPerRow = 6;
    static CGFloat const rowMargin = 10.f;
    NSUInteger total = self.dots.count;
    NSUInteger rows = total / maxPerRow + 1;

    for (NSUInteger r = 0; r < rows; r++) {
        CGFloat topMargin = r * rowMargin;
        NSUInteger startIndex = r * maxPerRow;
        NSUInteger dotsOnRow = MIN(total - startIndex, maxPerRow);
        NSUInteger endIndex = startIndex + dotsOnRow - 1;
        [self drawRowWithTopMargin:topMargin from:startIndex to:endIndex];
    }
}

- (void)drawRowWithTopMargin:(CGFloat)topMargin from:(NSUInteger)from to:(NSUInteger)to {
    static CGFloat const size = 6.f;
    static CGFloat const margin = 2.f;
    static CGFloat const rectSize = size + margin;

    CGFloat superWidth = self.bounds.size.width;
    NSUInteger dotsOnRow = to - from + 1;
    CGFloat inset = (superWidth - rectSize * dotsOnRow - margin) / 2.f; // Finds where it should insert the first element to make the row centered
    CGFloat y = margin + topMargin;

    for (NSUInteger i = from; i <= to; i++) {
        CGFloat x = (i - from) * (size + margin) + margin + inset;
        CGRect rect = CGRectMake(x, y, size, size);
        [self drawRect:rect withColor:self.dots[i]];
    }
}

- (void)drawRect:(CGRect)rect withColor:(UIColor *)color {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:1.f];
    [color setFill];
    [rounded fill];
    [color setStroke];
    rounded.lineWidth = 1.f;
    [rounded stroke];
}

@end
