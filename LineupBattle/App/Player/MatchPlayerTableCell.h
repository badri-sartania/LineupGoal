//
// Created by Anders Hansen on 14/03/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultViewCell.h"


@interface MatchPlayerTableCell : DefaultViewCell
- (void)setData:(NSDictionary *)match withPlaceIndex:(NSUInteger)index;
@end
