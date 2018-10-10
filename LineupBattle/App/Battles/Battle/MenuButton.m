//
// Created by Anders Borre Hansen on 04/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "MenuButton.h"
#import "DefaultImageView.h"
#import "HexColors.h"


@implementation MenuButton {
    UIButton *_button;
    DefaultImageView *_imageView;
    UIImage *_image;
    UIImage *_imageHighlighted;
    UILabel *_title;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _button = [[UIButton alloc] init];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        _imageView = [[DefaultImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        _title = [[UILabel alloc] init];
        _title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
        _title.textColor = [UIColor whiteColor];
        [_title setTextAlignment:NSTextAlignmentCenter];

        [self addSubview:_button];
        [self addSubview:_imageView];
        [self addSubview:_title];

        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.height.equalTo(@(60));
            make.width.equalTo(@(60));
        }];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom);
            make.bottom.left.right.equalTo(self);
        }];
    }

    return self;
}

- (instancetype)initWithDelegate:(id)delegate index:(NSInteger)index image:(UIImage *)image imageHighlighted:(UIImage *)imageHightlighted title:(NSString *)title {
    self = [self init];
    if (self) {
        self.delegate = delegate;
        self.index = index;
        _image = image;
        _imageHighlighted = imageHightlighted;
        _imageView.image = _image;
        _title.text = title;
    }

    return self;
}

- (void)buttonPressed:(id)buttonPressed {
    [self.delegate menuButtonPressed:self];
}

- (void)setHighlighted:(BOOL)highlight {
    _imageView.image = highlight ? _imageHighlighted : _image;
    _title.textColor = highlight ? [UIColor hx_colorWithHexString:@"2ECC71"] : [UIColor whiteColor];
}

@end
