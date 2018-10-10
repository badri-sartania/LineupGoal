//
// Created by Anders Hansen on 04/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XipSlideDownVCDelegate.h"
#import "MatchViewModel.h"

@interface SubscriptionViewController : UIViewController <XipSlideDownVCDelegate>
@property(nonatomic) NSUInteger initialBitMask;
@property(nonatomic) NSInteger initialSubscriptionCount;

- (id)initWithViewModel:(id)viewModel;
- (void)setHeaderLabel:(NSString *)targetString;
@end
