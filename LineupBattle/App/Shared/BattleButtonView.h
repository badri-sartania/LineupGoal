//
// Created by Anders Borre Hansen on 14/08/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BattleButtonView : UIView
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (void)setInviteBadgeCount:(NSUInteger)count;
@end