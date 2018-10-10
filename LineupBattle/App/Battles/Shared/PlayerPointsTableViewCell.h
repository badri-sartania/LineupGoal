//
// Created by Anders Borre Hansen on 03/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "DefaultViewCell.h"


@interface PlayerPointsTableViewCell : DefaultViewCell
- (void)setPoint:(NSDictionary *)point badge:(BOOL)badge timeString:(NSString *)string;
@end
