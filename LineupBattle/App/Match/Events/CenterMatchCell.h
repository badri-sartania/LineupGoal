//
// Created by Anders Hansen on 08/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"
#import "DefaultMASViewCell.h"
#import "Match.h"


@interface CenterMatchCell : DefaultMASViewCell

- (void)setData:(Match *)match;

@end