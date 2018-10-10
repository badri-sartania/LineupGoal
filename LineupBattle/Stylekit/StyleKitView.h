//
//  StyleKitView.h
//  Champion
//
//  Created by Anders Borre Hansen on 27/04/15.
//  Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockType)(CGRect rect);

@interface StyleKitView : UIView
- (instancetype)initWithStyleKitBlock:(BlockType)block;
@end
