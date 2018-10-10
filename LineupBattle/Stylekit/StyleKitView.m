//
//  StyleKitView.m
//  Champion
//
//  Created by Anders Borre Hansen on 27/04/15.
//  Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "StyleKitView.h"


@implementation StyleKitView {
    BlockType _styleKitBlock;
}

- (instancetype)initWithStyleKitBlock:(BlockType)block {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _styleKitBlock = block;
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    _styleKitBlock(rect);
}

@end
