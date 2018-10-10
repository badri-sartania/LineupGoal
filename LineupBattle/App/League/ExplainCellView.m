//
// Created by Anders Hansen on 17/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "ExplainCellView.h"
#import "DefaultLabel.h"
#import "HexColors.h"

@interface ExplainCellView ()
//@property(nonatomic, strong) DefaultImageView *icon;
@property (nonatomic, strong) DefaultLabel *explanation;

@end

@implementation ExplainCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;

        // TODO: self.icon disabled until league logos is supported in the backend
        //[self addSubview:self.icon];
        [self addSubview:self.explanation];

        //  [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        //    make.centerY.equalTo(self);
        //    make.left.equalTo(self).offset(5);
        //    make.size.equalTo(@20);
        //  }];

        [self.explanation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];
    }
    return self;
}

- (void)setData:(NSDictionary *)typeData {
    self.explanation.text = typeData[@"name"];

    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 5.f, self.frame.size.height+2);
    leftBorder.backgroundColor = typeData[@"rgb"] ? [UIColor hx_colorWithHexString:[NSString stringWithFormat:@"#%@", typeData[@"rgb"]]].CGColor : [UIColor whiteColor].CGColor;
    [self.layer addSublayer:leftBorder];


}

#pragma views

// TODO: icon disabled until league logos is supported in the backend
//- (DefaultImageView *)icon {
//   if (!_icon) {
//      _icon = [[DefaultImageView alloc] init];
//   }
//
//   return _icon;
//}

- (DefaultLabel *)explanation {
   if (!_explanation) {
        _explanation = [[DefaultLabel alloc] init];
   }

   return _explanation;
}




@end
