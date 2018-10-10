//
// Created by Anders Borre Hansen on 15/06/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "NoBattlesTemplatesViewCell.h"
#import "DefaultImageView.h"
#import "Utils.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"


@implementation NoBattlesTemplatesViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        DefaultImageView *noBattleImageView = [[DefaultImageView alloc] initWithImage:[UIImage imageNamed:@"no_battles"]];
        [noBattleImageView setContentMode:UIViewContentModeScaleAspectFit];
        self.noBattleLabel = [DefaultLabel initWithText:@"Sorry, no Battles"];
        self.noBattleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        self.noBattleLabel.textColor = [UIColor darkGrayTextColor];
        self.noBattleLabel.numberOfLines = 0;
        self.noBattleLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:noBattleImageView];
        [self addSubview:self.noBattleLabel];

        [@[noBattleImageView, self.noBattleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
        }];

        // Special for less than iphone 6
        if ([Utils screenHeight] < 667) {
            [self.noBattleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(30);
            }];
            noBattleImageView.hidden = YES;
        } else {
            [noBattleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(30);
                make.size.equalTo(@120);
            }];

            [self.noBattleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(noBattleImageView.mas_bottom).offset(10);
            }];
        }
    }

    return self;
}


@end
