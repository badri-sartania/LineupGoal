//
// Created by Anders Hansen on 15/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "RequestError.h"


@interface RequestError ()
@property(nonatomic, strong) NSError *error;
@property(nonatomic, strong) UIImage *image;
@end

@implementation RequestError

- (id)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        self.error = error;
    }

    return self;
}

- (UIImage *)image {
    return self.image;
}

- (NSString *)text {
    return self.error.localizedDescription;
}

@end