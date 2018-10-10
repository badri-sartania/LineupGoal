//
// Created by Anders Borre Hansen on 20/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "BattleInviteTableViewCell.h"
#import "DefaultLabel.h"
#import "ImageViewWithBadge.h"
#import "UIImage+LineupBattle.h"
#import "UIColor+LineupBattle.h"


@implementation BattleInviteTableViewCell {
    DefaultImageView *_profileImageView;
    DefaultLabel *_profileNameLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _profileImageView = [[DefaultImageView alloc] init];
        _profileNameLabel = [DefaultLabel init];
        _profileNameLabel.font = [UIFont systemFontOfSize:16];
        _profileNameLabel.textColor = [UIColor actionColor];

        [self addSubview:_profileNameLabel];
        [self addSubview:_profileImageView];

        NSInteger edgeOffset = 10;

        [_profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(30);
            make.size.equalTo(@45);
        }];

        // Left
        [_profileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_profileImageView.mas_right).offset(edgeOffset);
        }];
    }

    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)markAsFull:(BOOL)isFull position:(NSInteger)position{
    if (isFull) {
        _profileImageView.image = [[UIImage imageNamed:@"addPlayerWhiteBG"] imageBlackAndWhite];
        _profileNameLabel.text = @"Battle full";
        _profileNameLabel.textColor = [UIColor grayColor];
    } else {
        _profileImageView.image = [UIImage imageNamed:@"addPlayerWhiteBG"];
        _profileNameLabel.text = @"Add friends to this battle";
        _profileNameLabel.textColor = [UIColor actionColor];
    }
    
    if (position % 2 == 1) {
        self.contentView.backgroundColor = [UIColor lightBackgroundColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}
@end
