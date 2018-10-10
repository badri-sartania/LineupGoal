//
// Created by Anders Borre Hansen on 03/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "SimpleTableSectionView.h"
#import "FlagImage.h"
#import "HexColors.h"

@interface SimpleTableSectionView ()
@property (nonatomic, strong) UILabel *name;
@end

@implementation SimpleTableSectionView {
    CGFloat _bottomTextCenter;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _bottomTextCenter = self.frame.size.height - 23.f;
        [self addSubview:self.flag];
        [self addSubview:self.name];
    }

    return self;
}

- (void)setSectionDataWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self.name.text = [title uppercaseString];
    if (!imageName) {
        self.name.frame = CGRectMake(7.F, _bottomTextCenter, self.frame.size.width, 30.f);
    } else {
        self.image.image = [UIImage imageNamed:imageName];
    }
}

- (void)setSectionDataWithTitle:(NSString *)title flagCode:(NSString *)flagCode countryCodeFormat:(CountryCodeFormat)format {
    self.name.text = [title uppercaseString];
    if (!flagCode) {
        self.name.frame = CGRectMake(7.F, _bottomTextCenter, self.frame.size.width, 4.f);
    } else {
        self.image.image = [FlagImage flagWithCode:flagCode countryCodeFormat:format];
    }
}

- (void)setFontWeightForTextToBeLight {
    self.name.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(48.5f, _bottomTextCenter, self.frame.size.width, 18.f)];
        
        _name.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size: 15];
        _name.textColor = [UIColor hx_colorWithHexString:@"#2C3E50"];
    }

    return _name;
}

- (UIImageView *)flag {
    if (!_image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(21.f, _bottomTextCenter-1.f, 20.f, 20.f)];
        [_image setContentMode:UIViewContentModeScaleAspectFit];
    }

    return _image;
}

- (void)setUnderlineToNormalPosition {
//    self.bottomBorder.frame = CGRectMake(9.0f, self.frame.size.height-1.f, self.frame.size.width-5.f, 0.5f);
}

@end
