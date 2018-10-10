//
// Created by Anders Borre Hansen on 25/12/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "PrizeTableViewCell.h"
#import "UIColor+LineupBattle.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "Utils.h"

@implementation PrizeTableViewCell {
    DefaultLabel *_prizeLabel;
    DefaultImageView *_prizeImage;
    UIImageView *_boltImage;
    DefaultLabel *_boltLabel;
    UIButton *_btnVisit;
    NSString *urlString;
};

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _prizeLabel = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor whiteColor]];
        [_prizeLabel setBackgroundColor:[UIColor primaryColor]];
        _prizeImage = [[DefaultImageView alloc] init];
        
        UIView *boltWrapper = [[UIView alloc] init];
        boltWrapper.backgroundColor = [UIColor whiteColor];
        _boltImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_bolt_big"]];
        _boltLabel = [DefaultLabel initWithCondensedBoldSystemFontSize:43 color:[UIColor primaryTextColor]];
        _btnVisit = [[UIButton alloc] init];
        [_btnVisit setImage:[UIImage imageNamed:@"ic_visit"] forState:UIControlStateNormal];
        [_btnVisit addTarget:self action:@selector(onVisit:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_prizeLabel];
        [self addSubview:_prizeImage];
        [self addSubview:boltWrapper];
        [boltWrapper addSubview:_boltImage];
        [boltWrapper addSubview:_boltLabel];
        [self addSubview:_btnVisit];
        
        [_prizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@26);
        }];
        
        [_prizeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(_prizeLabel.mas_bottom);
            make.height.equalTo(@([Utils screenWidth] * 100 / 360));
        }];
        
        [boltWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_prizeImage.mas_bottom).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];
        
        [_boltImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(boltWrapper);
            make.width.equalTo(@(29));
            make.height.equalTo(@(42));
        }];
        [_boltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_boltImage.mas_right).offset(5);
            make.centerY.equalTo(_boltImage);
            make.right.equalTo(boltWrapper);
        }];
        [_btnVisit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_prizeImage);
        }];
    }
    return self;
}

- (void)setUser:(NSDictionary *)prize position:(NSInteger)position {
    NSArray *images = [prize objectForKey:@"images"];
    NSString *pos = [self stringForObjectValue:[prize objectForKey:@"position"]];
    NSString *bolts = [NSString stringWithFormat:@"%d", [[prize objectForKey:@"bolts"] intValue]];
    NSString *url = [images objectAtIndex:0];
    [_prizeImage loadImageWithUrlString:url placeholder:@""];
    _prizeLabel.text = [NSString stringWithFormat:@" %@ PRIZE", pos];
    _boltLabel.text = bolts;
    urlString = [prize objectForKey:@"link"];
    
    if (position % 2 == 0) {
        [self setBackgroundColor:[UIColor lightBackgroundColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (NSString *)stringForObjectValue:(id)anObject {
    if (![anObject isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    NSString *strRep = [anObject stringValue];
    NSString *lastDigit = [strRep substringFromIndex:([strRep length]-1)];
    
    NSString *ordinal;
    
    
    if ([strRep isEqualToString:@"11"] || [strRep isEqualToString:@"12"] || [strRep isEqualToString:@"13"]) {
        ordinal = @"TH";
    } else if ([lastDigit isEqualToString:@"1"]) {
        ordinal = @"ST";
    } else if ([lastDigit isEqualToString:@"2"]) {
        ordinal = @"ND";
    } else if ([lastDigit isEqualToString:@"3"]) {
        ordinal = @"RD";
    } else {
        ordinal = @"TH";
    }
    
    return [NSString stringWithFormat:@"%@%@", strRep, ordinal];
}

- (void)onVisit:(UIButton *)button {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
