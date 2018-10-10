//
// Created by Anders Hansen on 28/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultViewCell.h"
#import "UIColor+Lineupbattle.h"


@implementation DefaultViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        UIView *hightlightView = [[UIView alloc] init];
        hightlightView.backgroundColor = [UIColor highlightColor];
        hightlightView.layer.masksToBounds = YES;
        [self setSelectedBackgroundView:hightlightView];
        
    }

    return self;
}
@end
