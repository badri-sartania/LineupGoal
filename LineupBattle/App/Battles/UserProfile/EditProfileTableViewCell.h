//
//  EditProfileTableViewCell.h
//  GoalFury
//
//  Created by Kevin Li on 4/4/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

// Declare delegate
@protocol EditProfileTableViewCellDelegate;


// Define Cell details
@interface EditProfileTableViewCell : UITableViewCell <UITextViewDelegate>
@property (nonatomic, weak) id <EditProfileTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSDictionary *cellTemplate;
@property (nonatomic, strong) User *user;

- (void)setupCell:(User *)user cellTemplate:(NSDictionary *)cellTemplate;
@end


// Define delegate functions
@protocol EditProfileTableViewCellDelegate
- (void)onSelect:(EditProfileTableViewCell *)cell type:(NSInteger)type;
- (void)onUpdateContent:(id)content type:(NSInteger)type;
- (void)onChangeText:(NSString *)text type:(NSInteger)type;
@end
