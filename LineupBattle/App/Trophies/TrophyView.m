//
// Created by Anders Hansen on 29/04/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "TrophyView.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"

@interface TrophyView ()
@property (nonatomic, strong) DefaultLabel *count;
@property (nonatomic, strong) DefaultLabel *name;
@property (nonatomic, strong) DefaultImageView *trophy;
@end

@implementation TrophyView

- (id)init {
    self = [super init];
    if (self) {
        self.count = [DefaultLabel init];
        self.count.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        self.name = [DefaultLabel initWithAlignment:NSTextAlignmentCenter];
        self.name.numberOfLines = 0;
        self.trophy = [[DefaultImageView alloc] init];

        [self addSubview:self.trophy];
        [self addSubview:self.name];
        [self addSubview:self.count];

        [@[self.trophy, self.name, self.count] mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self);
        }];

        [self.trophy mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self).offset(10);
        }];

        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.trophy.mas_bottom).offset(10);
           make.width.equalTo(@100);
        }];

        [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.name.mas_bottom).offset(5);
        }];
    }

    return self;
}

- (void)setData:(NSDictionary *)trophy {
    self.trophy.image = [UIImage imageNamed:trophy[@"type"]];
    self.name.text = trophy[@"name"];
    self.count.text = [trophy[@"count"] stringValue];
}

@end