//
// Created by Anders Borre Hansen on 08/10/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultImageViewCell.h"


@implementation DefaultImageViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.defaultImage = [[DefaultImageView alloc] init];
        self.defaultImage.contentMode = UIViewContentModeScaleAspectFit;
        self.defaultLabel = DefaultLabel.new;

        [self addSubview:self.defaultImage];
        [self addSubview:self.defaultLabel];

        [self.defaultImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@30);
            make.centerY.equalTo(self);
            make.left.equalTo(@15);
        }];

        [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(@55);
        }];
    }

    return self;
}


@end