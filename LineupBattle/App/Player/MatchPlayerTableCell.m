//
// Created by Anders Hansen on 14/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "MatchPlayerTableCell.h"
#import "DefaultLabel.h"
#import "Match.h"
#import "Date.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"

@interface MatchPlayerTableCell ()
@property (nonatomic, strong) DefaultLabel *date;
@property (nonatomic, strong) DefaultLabel *against;
@property (nonatomic, strong) DefaultLabel *result;
@property (nonatomic, strong) DefaultLabel *league;
@end

@implementation MatchPlayerTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {

        self.result = [DefaultLabel initWithCondensedBoldSystemFontSize:17];
        self.against = [DefaultLabel initWithCondensedBoldSystemFontSize:14 color:[UIColor primaryTextColor]];
        self.date = [DefaultLabel initWithSystemFontSize:12 color:[UIColor primaryColor]];
        self.date.alpha = 0.6;
        self.league = [DefaultLabel initWithSystemFontSize:12 color:[UIColor primaryColor]];

        [self addSubview:self.result];
        [self addSubview:self.against];
        [self addSubview:self.date];
        [self addSubview:self.league];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.result mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self);
       make.left.equalTo(@20);
    }];

    [self.against mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(@55);
       make.centerY.equalTo(self).offset(-8);
    }];

    [self.league mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@55);
        make.centerY.equalTo(self).offset(8);
    }];

    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.league.mas_right).offset(3);
        make.centerY.equalTo(self).offset(8);
    }];

    [super layoutSubviews];
}

- (void)setData:(NSDictionary *)match withPlaceIndex:(NSUInteger)index{
    if (index % 2 == 0) {
        [self setBackgroundColor:[UIColor lightBackgroundColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    YLMoment *moment = [Date stringToYLMoment:match[@"kickOff"]];
    self.against.text = [NSString stringWithFormat:@"vs. %@", match[@"opponent"]];
    self.result.text  = [NSString stringWithFormat:@"%@-%@", match[@"score"][@"own"], match[@"score"][@"opponent"]];

    if (moment.year < [YLMoment now].year) {
        self.date.text = [moment format:@"d MMM YY"];
    } else {
        self.date.text = [moment format:@"d MMM"];
    }

    self.league.text = match[@"competition"];

    NSInteger ownScore = [match[@"score"][@"own"] integerValue];
    NSInteger opponentScore = [match[@"score"][@"opponent"] integerValue];

    if (match[@"score"][@"own"] && match[@"score"][@"opponent"]) {
        if (ownScore < opponentScore) {
            self.result.textColor = [UIColor hx_colorWithHexString:@"e64b3b"];
        } else if (ownScore == opponentScore) {
            self.result.textColor = [UIColor hx_colorWithHexString:@"95a5a5"];
        } else {
            self.result.textColor = [UIColor hx_colorWithHexString:@"2dcb71"];
        }
    }

    static NSArray *events = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        events = @[
                @[@"goals", [UIImage imageNamed:@"goal"]],
                @[@"assists", [UIImage imageNamed:@"shoe"]],
                @[@"yellowCards", [UIImage imageNamed:@"yellowcard"]],
                @[@"redCards", [UIImage imageNamed:@"red"]]
        ];
    });

    NSInteger placement = -7;

    for (NSArray *eventArr in events) {
        NSString *event = eventArr[0];
        UIImage *img = eventArr[1];
        for (int i = 0; i < [match[event] integerValue]; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            [self addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(placement);
                make.centerY.equalTo(self);
            }];
            placement -= 22;
        }
    }
}

@end
