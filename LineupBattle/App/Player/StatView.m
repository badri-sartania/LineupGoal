//
// Created by Anders Hansen on 13/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "StatView.h"
#import "DefaultImageView.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"

@interface StatView ()
@property (nonatomic, strong) DefaultImageView *statImageView;
@property (nonatomic, strong) DefaultLabel *stat;
@property (nonatomic, strong) DefaultLabel *statDescription;
@end

@implementation StatView

#pragma mark - Views

- (id)init {
    self = [super init];

    if (self) {
        self.statDescription = [DefaultLabel init];
        self.statDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        self.statDescription.textColor = [UIColor highlightColor];
        self.statImageView = [[DefaultImageView alloc] init];
        self.stat = [DefaultLabel initWithSystemFontSize:18 weight:UIFontWeightLight];
        self.stat.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.stat.textColor = [UIColor primaryColor];
        
        [self addSubview:self.statDescription];
        [self addSubview:self.statImageView];
        [self addSubview:self.stat];
    }

    return self;
}

- (void)setStat:(NSString *)stat imageName:(NSString *)imageName description:(NSString *)description {
    self.statDescription.text = [description uppercaseString];
    self.statImageView.image = [UIImage imageNamed:imageName];
    self.stat.text = stat;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.stat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(10);
        make.top.equalTo(self);
    }];

    [self.statImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stat.mas_left).offset(-3);
        make.centerY.equalTo(self.stat);
        make.width.equalTo(@22);
        make.height.equalTo(@20);
    }];

    // Description
    [self.statDescription mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self);
       make.centerX.equalTo(self);
    }];

    [super layoutSubviews];
}

@end
