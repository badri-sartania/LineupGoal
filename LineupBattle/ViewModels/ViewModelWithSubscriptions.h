//
// Created by Anders Hansen on 24/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractViewModel.h"
#import "Subscription.h"


@interface ViewModelWithSubscriptions : AbstractViewModel
@property (nonatomic, strong) Subscription *subscription;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@end