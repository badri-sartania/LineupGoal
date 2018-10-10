//
// Created by Anders Hansen on 22/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel/RVMViewModel.h>

@interface AbstractViewModel : RVMViewModel
- (NSString *)classNameAsString;

@property(nonatomic, strong) NSNumber *dataLoaded;
@end
