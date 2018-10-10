//
// Created by Anders Borre Hansen on 04/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultImageView.h"
#import "DefaultLabel.h"
#import "Player.h"


@protocol CaptainButtonDelegate;

@interface CaptainButton : UIView
@property (nonatomic, weak) id <CaptainButtonDelegate> delegate;
- (void)setPlayer:(Player *)player;
@end

@protocol CaptainButtonDelegate
- (void)captainButtonAction:(CaptainButton *)captainButton;
@end