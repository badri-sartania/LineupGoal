//
// Created by Anders Borre Hansen on 15/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "SelectOnboardingViewController.h"
#import "DefaultLabel.h"
#import "Utils.h"
#import "UIColor+LineupBattle.h"


@implementation SelectOnboardingViewController

- (instancetype)init {
    self = [super initWithImage:[UIImage imageNamed:@"onboarding1"]];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headlineLabel.text = [@"world cup fan battle" uppercaseString];
    self.sublineLabel.text = @"Beat fans and friends worldwide";
}


@end
