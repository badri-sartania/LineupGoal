//
// Created by Anders Hansen on 12/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "NotificationOverlayView.h"


@interface NotificationOverlayView ()
@property(nonatomic, strong) DefaultImageView *imageView;
@property(nonatomic, strong) DefaultLabel *textLabel;
@end

@implementation NotificationOverlayView

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image  {
    self = [self init];
    if (self) {
        [self setText:text image:image];
    }

    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageView = [[DefaultImageView alloc] init];
        self.textLabel = [DefaultLabel initWithAlignment:NSTextAlignmentCenter];
        self.textLabel.numberOfLines = 0;
        self.alpha = 0.f;
        self.backgroundColor = [UIColor whiteColor];

        [self addSubviews];
        [self layoutSubviews];
    }

    return self;
}

- (void)addSubviews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-self.frame.size.height/3.f);
        make.centerX.equalTo(self);
    }];

    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.width.equalTo(@(self.frame.size.width/1.5f));
    }];

    [super layoutSubviews];
}

- (void)setText:(NSString *)text image:(UIImage *)image {
    self.imageView.image = image;
    self.textLabel.text = text;

    [self layoutSubviews];
}

#pragma mark - Action
- (void)fadeIn {
    [UIView beginAnimations:nil context:nil];
    [self setAlpha:1.f];
    [UIView commitAnimations];
}

@end
