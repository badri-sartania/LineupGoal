//
// Created by Anders Hansen on 19/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "LBMTLModel.h"
#import "Player.h"


@interface Event : LBMTLModel
@property(assign, readonly) BOOL home;
@property(nonatomic, copy, readonly) NSString *type;
@property(nonatomic, strong, readonly) NSDictionary *time;
@property(nonatomic, strong, readonly) Player *in;
@property(nonatomic, strong, readonly) Player *out;
@property(nonatomic, strong, readonly) Player *player;
@property(nonatomic, strong, readonly) Player *assist;

// Calculated property
@property(nonatomic, strong) NSDictionary *scoreAtEvent;
@property(nonatomic, strong) NSDictionary *score;
@property(nonatomic, copy) NSString *cellName;
@property(assign) BOOL isAssistEvent;

- (Player *)playerInFocus;
- (BOOL)isGoal;
- (BOOL)isPenaltyShootoutGoal;
- (BOOL)isOwnGoal;
- (BOOL)isSubstitution;
- (BOOL)isFullTime;
- (BOOL)isYellowCard;
- (BOOL)isRedCard;
- (BOOL)isHome;
- (BOOL)isMissedPenaltyShootoutGoal;
- (BOOL)hasAssist;
- (BOOL)isPenaltyShootoutEvent;
- (NSString *)mainText;
- (NSString *)secondaryText;
- (NSString *)eventImage;
- (UIColor *)eventColor;
- (BOOL)isSecondYellow;
@end
