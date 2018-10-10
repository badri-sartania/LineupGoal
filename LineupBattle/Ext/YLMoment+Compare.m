//
// Created by Anders Hansen on 26/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "YLMoment+Compare.h"


@implementation YLMoment (Compare)

- (NSComparisonResult)compare:(YLMoment *)moment {
    return [self.date compare:moment.date];
}

@end