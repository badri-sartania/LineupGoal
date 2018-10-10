//
// Created by Anders Borre Hansen on 15/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "PlayOnboardingViewController.h"
#import "Utils.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"
#import "SimpleLocale.h"


@implementation PlayOnboardingViewController

- (instancetype)init {
    self = [super initWithImage:[UIImage imageNamed:@"onboarding2"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headlineLabel.text = [@"Pick the best players" uppercaseString];
    self.sublineLabel.text = @"Build lineups like a boss!";
}

@end
