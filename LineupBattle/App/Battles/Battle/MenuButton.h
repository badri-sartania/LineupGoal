//
// Created by Anders Borre Hansen on 04/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MenuButtonDelegate;

@interface MenuButton : UIView
@property (nonatomic, weak) id <MenuButtonDelegate> delegate;
@property (nonatomic) NSInteger index;

- (instancetype)initWithDelegate:(id)delegate index:(NSInteger)index image:(UIImage *)image imageHighlighted:(UIImage *)imageHightlighted title: (NSString *)title;
- (void)setHighlighted:(BOOL)highlight;
@end

@protocol MenuButtonDelegate
- (void)menuButtonPressed:(MenuButton *)menuButton;
@end
