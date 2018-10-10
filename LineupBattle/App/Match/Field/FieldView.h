//
// Created by Anders Hansen on 14/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldItemView.h"

@class CreateLineupViewController;
@protocol FieldViewDataSource;
@protocol FieldViewDelegate;

@interface FieldView : UIView <FieldViewItemDelegate>
- (void)reloadData;

@property(nonatomic, weak) id <FieldViewDataSource> dataSource;
@property(nonatomic, weak) id <FieldViewDelegate> delegate;
@end

@protocol FieldViewDataSource<NSObject>

@required
- (FieldItemView *)fieldView:(FieldView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfItemsForSectionInFieldView:(FieldView *)fieldView section:(NSInteger)section;

@optional
- (NSInteger)numberOfSectionsInFieldView:(FieldView *)fieldView; // Default is 1 if not implemented

@end

@protocol FieldViewDelegate<NSObject>

@optional
- (CGFloat)fieldView:(FieldView *)fieldView marginBetweenItemsInSection:(NSInteger)section; // Default is 10
- (CGFloat)fieldView:(FieldView *)fieldView heightForSection:(NSInteger)section; // Default is 30
- (CGFloat)fieldView:(FieldView *)fieldView marginForSection:(NSInteger)section; // Default is 0
- (void)fieldView:(FieldView *)fieldView didSelectFieldItemView:(FieldItemView *)fieldItemView;
- (void)fieldView:(FieldView *)fieldView didSelectCaptainFieldItemView:(FieldItemView *)fieldItemView;
- (BOOL)fieldViewShouldBeReversed:(FieldView *)fieldView; // Defaults to NO

@end

@interface NSIndexPath (FieldView)

+ (NSIndexPath *)indexPathForRow:(NSInteger)row inSection:(NSInteger)section;

@property(nonatomic,readonly) NSInteger section;
@property(nonatomic,readonly) NSInteger row;

@end
