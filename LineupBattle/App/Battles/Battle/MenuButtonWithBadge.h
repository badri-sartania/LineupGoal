//
// Created by Anders Borre Hansen on 11/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuButton.h"

@class CustomBadge;


@interface MenuButtonWithBadge : MenuButton

- (void)setBadgeCounter:(NSInteger)count;
@end