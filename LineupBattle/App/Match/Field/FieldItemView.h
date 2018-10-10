//
// Created by Anders Borre Hansen on 13/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FieldViewItemDelegate;


@interface FieldItemView : UIView
@property (nonatomic, weak) id <FieldViewItemDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@protocol FieldViewItemDelegate
- (void)buttonWasPressed:(FieldItemView *)fieldViewItem;
- (void)captainButtonWasPressed:(FieldItemView *)fieldViewItem;
@end
