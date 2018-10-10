//
// Created by Anders Borre Hansen on 28/10/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "InfoTableViewCell.h"


@implementation InfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.descLabel = [DefaultLabel initWithBoldSystemFontSize:14];
        [self addSubview:self.descLabel];
        self.dataLabel = [DefaultLabel init];
        [self addSubview:self.dataLabel];

        [@[self.descLabel, self.dataLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
        }];
        
        [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-10);
        }];
        
        [self.dataLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(10);
        }];
    }

    return self;
}

@end