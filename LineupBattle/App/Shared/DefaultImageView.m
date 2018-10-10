//
// Created by Anders Hansen on 13/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "DefaultImageView.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>


@implementation DefaultImageView

- (id)init {
    self = [super init];

    if (self) {
        [self setContentMode:UIViewContentModeScaleAspectFit];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }

    return self;
}

- (void)circleWithBorder:(UIColor *)color diameter:(CGFloat)diameter {
    [self circleWithBorder:color diameter:diameter borderWidth:1.5];
}

- (void)circleWithBorder:(UIColor *)color diameter:(CGFloat)diameter borderWidth:(CGFloat)borderWidth {
    self.layer.cornerRadius = diameter / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
    self.layer.backgroundColor = color.CGColor;
}

- (void)loadImageWithUrlString:(NSString *)urlString placeholder:(NSString *)placeholder {
    [self loadImageWithUrlString:urlString placeholder:placeholder success:nil failure:nil];
}

- (void)loadImageWithUrlString:(NSString *)urlString placeholder:(NSString *)placeholder success:(void (^)())success failure:(void (^)())failure {
    if (urlString && ![urlString isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        @weakify(self);
        [self setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:placeholder]
                             success:^(NSURLRequest *request2, NSHTTPURLResponse *response, UIImage *image) {
                                 @strongify(self);
                                 [self setImage:image];
                                 if (success) success();
                             }
                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 if (failure) failure();
                             }];
    } else {
        self.image = [UIImage imageNamed:placeholder];
        if (failure) failure();
    }
}
@end
