//
// Created by Anders Hansen on 12/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "DefaultLabel.h"
#import "DefaultImageView.h"

@interface NotificationOverlayView : UIView
- (instancetype)initWithText:(NSString *)text image:(UIImage *)image;

- (void)setText:(NSString *)text image:(UIImage *)image;

- (void)fadeIn;
@end