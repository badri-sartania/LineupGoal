//
// Created by Anders Borre Hansen on 20/05/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "ProfileImageWithBadgeView.h"


@implementation ProfileImageWithBadgeView

- (id)initWithImageName:(NSString *)imageName badgeText:(NSString *)text {
    self = [super init];
    if (self) {
        // User profile image
        CGFloat profileSize = 45;
        self.imageViewWithBadge = [[ImageViewWithBadge alloc] initWithBadgeScale:1.f];
        if (imageName) [self.imageViewWithBadge setImageName:imageName];
        [self.imageViewWithBadge.imageView circleWithBorder:[UIColor whiteColor] diameter:profileSize borderWidth:0.f];
        
        if (text != nil){
            [self.imageViewWithBadge setBadgeText:text];
        } else {
            [self.imageViewWithBadge setBadgeText:@""];
        }

        UIButton *buttonOverlay2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonOverlay2 setAccessibilityIdentifier:@"profileImageButton"];
        [buttonOverlay2 addTarget:self action:@selector(profileAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.imageViewWithBadge];
        [self addSubview:buttonOverlay2];

        [@[self.imageViewWithBadge, buttonOverlay2] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.size.equalTo(@(profileSize));
        }];
    }

    return self;
}

- (void)profileAction:(id)o {
    [self.delegate profileButtonPressed:o];
}


@end
