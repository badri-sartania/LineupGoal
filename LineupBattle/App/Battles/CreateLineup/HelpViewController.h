//
// Created by Anders Borre Hansen on 25/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BattleInfoType) {
    BattleInfoPage,
    CreateLineupPage
};

@interface HelpViewController : UIViewController

@property (nonatomic) enum BattleInfoType infoPageType;

- (instancetype)initForCreateLineup;
- (instancetype)initForBattle;
@end
