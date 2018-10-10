//
// Created by Anders Hansen on 28/04/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultMASViewCell.h"


@implementation DefaultMASViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        [self defineLayout];
    }
    return self;
}

- (void)updateConstraints {
    [self defineLayout];
    [super updateConstraints];
}

- (void)addSubviews {
    NSAssert(NO, @"Must override");
}

- (void)defineLayout {
    NSAssert(NO, @"Must override");
}
@end