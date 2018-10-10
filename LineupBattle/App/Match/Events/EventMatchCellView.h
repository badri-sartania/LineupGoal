//
// Created by Anders Hansen on 19/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "DefaultViewCell.h"

@interface EventMatchCellView : DefaultViewCell

@property(nonatomic, strong) Event *event;

- (void)setupEvent:(Event *)event;

- (void)defineLayout:(Event *)event;
@end
