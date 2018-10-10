//
// Created by Anders Hansen on 04/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelWithSubscriptions.h"


@interface NotificationButtonView : UIView
- (id)initWithName:(NSString *)data key:(NSString *)key viewModel:(ViewModelWithSubscriptions *)viewModel;

- (void)setState:(BOOL)state;

- (void)buttonSelected:(BOOL)selected;

@property(nonatomic) BOOL selected;
@property(nonatomic, copy) NSString *identifier;

@end