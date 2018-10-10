//
// Created by Anders Hansen on 23/06/14.
// Copyright (c) 2014 e-conomic. All rights reserved.
//

#import "UIView+Border.h"


@implementation UIView (Border)

- (CALayer *)borderCALayer:(UIColor *)color {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer:border];

    return border;
}

- (UIView *)bottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset {
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(offset, self.bounds.size.height - borderWidth, self.frame.size.width-offset, borderWidth)];
    borderView.backgroundColor = color;
    [self addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self).offset(offset);
        make.height.equalTo(@(borderWidth));
    }];
    
    return borderView;
}

- (UIView *)topBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset {
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(offset, 0, self.frame.size.width-offset, borderWidth)];
    borderView.backgroundColor = color;
    [self addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self).offset(offset);
        make.height.equalTo(@(borderWidth));
    }];
    
    return borderView;
}

- (CALayer *)addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset {
    CALayer *border = [self borderCALayer:color];
    border.frame = CGRectMake(offset, self.bounds.size.height - borderWidth, self.frame.size.width-offset, borderWidth);
    
    return border;
}

- (CALayer *)addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset {
    CALayer *border = [self borderCALayer:color];
    border.frame = CGRectMake(offset, 0, self.frame.size.width-offset, borderWidth);
    return border;
}

- (CALayer *)addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset {
    CALayer *border = [self borderCALayer:color];
    border.frame = CGRectMake(self.frame.size.width-borderWidth-offset, 0, borderWidth, self.frame.size.height);
    return border;
}

// Left vertical border with top and bottom indentation equal to the border width
- (CALayer *)addLeftIndentedBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth offset:(CGFloat)offset {
    CALayer *border = [self borderCALayer:color];
    border.frame = CGRectMake(borderWidth, offset, borderWidth, self.frame.size.height-(2*borderWidth));
    return border;
}

@end