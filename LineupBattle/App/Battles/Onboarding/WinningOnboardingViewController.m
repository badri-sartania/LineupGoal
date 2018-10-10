//
// Created by Anders Borre Hansen on 15/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "SCLButton.h"
#import "WinningOnboardingViewController.h"
#import "Utils.h"
#import "DefaultLabel.h"
#import "AppDelegate.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"


@implementation WinningOnboardingViewController

- (instancetype)init {
    self = [super initWithImage:[UIImage imageNamed:@"onboarding3"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headlineLabel.text = [@"Earn points. Win prizes!" uppercaseString];
    self.sublineLabel.text = @"Enjoy epic battlegasm!";
}

@end
