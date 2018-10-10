//
// Created by Anders Hansen on 17/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YLMoment/YLMoment.h>
//#import <XipSlideDownView/XipSlideDownVCDelegate.h>
#import "XipSlideDownVCDelegate.h"
#import "DefaultTableViewDelegate.h"

@interface MatchesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DefaultTableViewDelegate>
@property (strong, nonatomic) YLMoment *date;
@property(nonatomic, copy) NSString *identifier;

- (id)initWithDate:(YLMoment *)date;

- (void)fetchDate:(YLMoment *)date clearTable:(BOOL)clear;
@end
