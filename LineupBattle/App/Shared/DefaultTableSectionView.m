//
//  DefaultTableSectionView.m
//  Lineupbattle
//
//  Created by Anders Borre Hansen on 02/01/14.
//  Copyright (c) 2014 xip. All rights reserved.
//

#import "DefaultTableSectionView.h"
#import "HexColors.h"

@implementation DefaultTableSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
//        [self.layer addSublayer:self.bottomBorder];
    }
    return self;
}

#pragma mark - Views

- (CALayer *)bottomBorder {
    if (!_bottomBorder) {
        _bottomBorder = [CALayer layer];
        _bottomBorder.frame = CGRectMake(25.0f, self.frame.size.height-1.f, self.frame.size.width-25, 0.5f);
        _bottomBorder.backgroundColor = [UIColor hx_colorWithHexString:@"#383534"].CGColor;
    }

    return _bottomBorder;
}

@end
