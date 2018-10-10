//
// Created by Anders Borre Hansen on 13/04/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DefaultLabel;

typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionTopCenter,
    ImagePositionCenterCenter,
    ImagePositionHalfTop
};

@interface ImageViewController : UIViewController

@property (nonatomic, strong) DefaultLabel *sublineLabel;

@property (nonatomic, strong) DefaultLabel *headlineLabel;

- (id)initWithImage:(UIImage *)image;
@end
