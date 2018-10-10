//
// Created by Anders Hansen on 07/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "CircleWithTextView.h"
#import "DefaultLabel.h"
#import "HexColors.h"

@interface CircleWithTextView ()
@property (nonatomic, strong) DefaultLabel *textLabel;
@end

@implementation CircleWithTextView

- (id)init {
    self = [super init];
    if (self) {
        [self addSubview:self.textLabel];

        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];

        self.layer.cornerRadius = 10.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }

    return self;
}

- (void)setText:(NSString *)text {
    UIColor *color = [self colorFromText:text];
    self.textLabel.text = [text uppercaseString];
    self.layer.backgroundColor = color.CGColor;
    self.layer.borderColor = color.CGColor;
}

- (UIColor *)colorFromText:(NSString *)text {
    if ([text isEqualToString:@"W"]) {
        return [UIColor hx_colorWithHexString:@"#2ECC71"];
    } else if ([text isEqualToString:@"L"]) {
        return [UIColor hx_colorWithHexString:@"#E74C3C"];
    } else if ([text isEqualToString:@"D"]) {
        return [UIColor hx_colorWithHexString:@"#95A5A6"];
    } else {
        return [UIColor hx_colorWithHexString:@"#FFFFFF"];
    }
}

- (DefaultLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor whiteColor]];
    }

    return _textLabel;
}

@end
