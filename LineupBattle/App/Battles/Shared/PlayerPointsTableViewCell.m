//
// Created by Anders Borre Hansen on 03/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "PlayerPointsTableViewCell.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "PointsView.h"
#import "ImageUrlGenerator.h"
#import "ImageWithCaptainBadgeView.h"
#import "UIColor+LineupBattle.h"


@implementation PlayerPointsTableViewCell {
    ImageWithCaptainBadgeView *_pointsPlayerImageView;
    DefaultLabel *_pointsPlayerLabel;
    DefaultLabel *_pointsTypeLabel;
    DefaultLabel *_pointsTimeLabel;
    PointsView *_pointsView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _pointsPlayerImageView = [[ImageWithCaptainBadgeView alloc] init];
        _pointsPlayerImageView.imageView.image = [UIImage imageNamed:@"playerPlaceholder"];
        [_pointsPlayerImageView.imageView circleWithBorder:[UIColor whiteColor] diameter:34 borderWidth:0];
        _pointsPlayerLabel = [DefaultLabel initWithSystemFontSize:14];
        _pointsTypeLabel = [DefaultLabel initWithSystemFontSize:12 color:[UIColor darkGrayTextColor]];
        _pointsTimeLabel = [DefaultLabel initWithSystemFontSize:11];
        _pointsView = [[PointsView alloc] initWithPoints:22];
        _pointsView.pointsLabel.font = [UIFont boldSystemFontOfSize:16];

        [self addSubview:_pointsPlayerLabel];
        [self addSubview:_pointsTypeLabel];
        [self addSubview:_pointsPlayerImageView];
        [self addSubview:_pointsView];
        [self addSubview:_pointsTimeLabel];

        NSInteger centerOffset = 8;
        NSInteger edgeOffset = 10;

        [_pointsPlayerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(edgeOffset);
            make.size.equalTo(@33);
        }];

        // Top
        [@[_pointsPlayerLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-centerOffset);
        }];

        // Left
        [@[_pointsPlayerLabel, _pointsTypeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_pointsPlayerImageView.mas_right).offset(edgeOffset);
        }];

        // Right
        [@[_pointsView, _pointsTimeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-edgeOffset);
        }];

        // Bottom
        [@[_pointsTypeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(centerOffset);
        }];

        [@[_pointsView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(centerOffset-4);
        }];

        [_pointsTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_pointsView.mas_top).offset(-8);
        }];


    }

    return self;
}

- (void)setPoint:(NSDictionary *)point badge:(BOOL)badge timeString:(NSString *)string {
    NSInteger points = [point[@"points"] integerValue];
    [_pointsView setPoints:points];
    _pointsTypeLabel.text = [self niceType:point[@"type"]];
    _pointsPlayerLabel.text = point[@"name"];
    _pointsTimeLabel.text = string;

    [_pointsPlayerImageView showBadge:badge];

    NSString *imageUrlString = [ImageUrlGenerator playerPhotoImageUrlStringBySize:@"34" photoToken:point[@"photoToken"] objectId:point[@"_id"]];
    [_pointsPlayerImageView.imageView loadImageWithUrlString:imageUrlString placeholder:@"playerPlaceholder"];
}

- (NSString *)niceType:(NSString *)string {
    NSString *better = [string stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    NSString *best = [better capitalizedString];

    return best;
}

@end
