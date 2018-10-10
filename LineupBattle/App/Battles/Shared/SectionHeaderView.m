//
//  SectionHeaderView.m
//  LineupBattle
//
//  Created by Tomasz Przybyl on 1/23/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import "SectionHeaderView.h"
#import "UIColor+LineupBattle.h"

@implementation SectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){4.0, 4.0}].CGPath;

        self.layer.mask = maskLayer;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 14, 20)];
        _titleLabel.textColor = [UIColor primaryTextColor];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.f];

        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(7);
            make.top.equalTo(self);
            make.right.equalTo(self).offset(-7);
            make.bottom.equalTo(self);
        }];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    [_titleLabel setText:title];
}

- (void)setTitleColor:(UIColor *)color {
    [_titleLabel setTextColor:color];
}

@end
