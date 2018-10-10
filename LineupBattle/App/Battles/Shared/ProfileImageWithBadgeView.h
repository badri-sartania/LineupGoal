//
// Created by Anders Borre Hansen on 20/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageViewWithBadge.h"

@protocol ProfileImageButtonDelegate
- (void)profileButtonPressed:(UIButton *)profileButton;
@end


@interface ProfileImageWithBadgeView : UIView
@property (nonatomic, weak) id <ProfileImageButtonDelegate> delegate;

@property (nonatomic, strong) ImageViewWithBadge *imageViewWithBadge;

- (id)initWithImageName:(NSString *)imageName badgeText:(NSString *)text;
@end

