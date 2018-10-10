//
//  EditProfileTableViewCell.m
//  GoalFury
//
//  Created by Kevin Li on 4/4/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

#import "EditProfileTableViewCell.h"
#import "DefaultLabel.h"
#import "UIColor+LineupBattle.h"
#import "UITextView+Placeholder.h"
#import "ImageViewWithBadge.h"
#import "CountryCodeHelper.h"

typedef NS_ENUM(NSInteger, ProfileSettingContent) {
    ProfileSettingName,
    ProfileSettingEmail,
    ProfileSettingPhoto,
    ProfileSettingNationality,
    ProfileSettingNotification,
    ProfileSettingSubscription,
    ProfileSettingRateUs,
    ProfileSettingAbout,
    ProfileSettingHelp
};
static NSInteger profilePhotoSize = 45.0f;

@implementation EditProfileTableViewCell
{
    DefaultLabel *headLabel;
    UITextView *textView;
    ImageViewWithBadge *imageView;
    UIImageView *rightCursor;
    DefaultLabel *contentLabel;
    ProfileSettingContent contentType;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headLabel = [DefaultLabel initWithMediumSystemFontSize:14 color:[UIColor primaryColor]];
        textView = [[UITextView alloc] init];
        imageView = [[ImageViewWithBadge alloc] initWithBadgeScale:0.0f];
        rightCursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_gray_arrow_right"]];
        contentLabel = [DefaultLabel initWithSystemFontSize:15 color:[UIColor primaryColor]];
        
        [self.contentView addSubview:headLabel];
        [self.contentView addSubview:textView];
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:rightCursor];
        [self.contentView addSubview:contentLabel];
        
        
        // Setup constraints
        [@[headLabel, textView, imageView, rightCursor, contentLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
        
        [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
        }];
        
        [@[textView, imageView, rightCursor] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightCursor.mas_left).offset(-10);
        }];
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@150);
            make.height.equalTo(@36);
        }];
        
        textView.textAlignment = NSTextAlignmentRight;
        [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [textView setTextColor:[UIColor primaryColor]];
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.delegate = self;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@45);
        }];
        [imageView.imageView circleWithBorder:[UIColor whiteColor] diameter:profilePhotoSize borderWidth:0.0f];
        [imageView.imageView setImage:[UIImage imageNamed:@"ic_take_photo"]];
    }
    
    return self;
}

#pragma mark - Setup Cells

- (void)setupCell:(User *)user cellTemplate:(NSDictionary *)cellTemplate {
    self.user = user;
    self.cellTemplate = cellTemplate;
    contentType = [[cellTemplate objectForKey:@"type"] integerValue];
    headLabel.text = [[cellTemplate objectForKey:@"label"] uppercaseString];
    
    if ([[cellTemplate objectForKey:@"control"] isEqualToString:@"input"]) {
        // Setup <NAME & EMAIL> cells
        [self setupInputCell];
    } else if ([[cellTemplate objectForKey:@"control"] isEqualToString:@"image"]) {
        // Setup <PROFILE IMAGE> cell
        [self setupImageCell];
    } else if ([[cellTemplate objectForKey:@"control"] isEqualToString:@"select"]) {
        // Setup <NATIONALITY> cell
        [self setupOtherCell];
    } else if ([[cellTemplate objectForKey:@"control"] isEqualToString:@"pick"]) {
        // Setup <NOTIFICATIONS, SUBSCRIPTIONS> cells
        [self setupOtherCell];
    } else if ([[cellTemplate objectForKey:@"control"] isEqualToString:@"button"]) {
        // Setup <RATE US, ABOUT, HELP> cells
        [self setupOtherCell];
    }
    
    // Setup border
    if (contentType != ProfileSettingNotification && contentType != ProfileSettingSubscription) {
        CALayer *bottomBorder = [CALayer layer];
        if ([[cellTemplate objectForKey:@"separator"] isEqualToString:@"full"]) {
            bottomBorder.frame = CGRectMake(0.0f, 59.0f, self.contentView.frame.size.width, 1.0f);
            bottomBorder.backgroundColor = [UIColor highlightColor].CGColor;
        } else if ([[cellTemplate objectForKey:@"separator"] isEqualToString:@"normal"]){
            bottomBorder.frame = CGRectMake(20.0f, 59.0f, self.contentView.frame.size.width - 20, 1.0f);
            bottomBorder.backgroundColor = [UIColor lightBorderColor].CGColor;
        } else {
            bottomBorder.frame = CGRectMake(20.0f, 59.0f, self.contentView.frame.size.width - 20, 1.0f);
            bottomBorder.backgroundColor = [UIColor clearColor].CGColor;
        }
        [self.contentView.layer addSublayer:bottomBorder];
    }
}

- (void)setupInputCell {
    textView.hidden = NO;
    imageView.hidden = YES;
    rightCursor.hidden = YES;
    contentLabel.hidden = YES;
    headLabel.hidden = NO;
    
    textView.placeholder = [self.cellTemplate objectForKey:@"placeholder"];
    textView.placeholderColor = [UIColor championsLeagueColor];
    
    if (contentType == ProfileSettingEmail) {
        textView.text = self.user.email == nil ? @"" : self.user.email;
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textView setKeyboardType:UIKeyboardTypeEmailAddress];
        [textView reloadInputViews];
    } else {
        textView.text = self.user.name == nil ? @"" : self.user.name;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupImageCell {
    textView.hidden = YES;
    imageView.hidden = NO;
    rightCursor.hidden = YES;
    contentLabel.hidden = YES;
    headLabel.hidden = NO;
    
    if (self.user.photoToken) {
        [imageView.imageView loadImageWithUrlString:[self.user profileImagePath:profilePhotoSize] placeholder:@"playerPlaceholder"];
    }
}

- (void)setupOtherCell {
    textView.hidden = YES;
    imageView.hidden = YES;
    rightCursor.hidden = NO;
    contentLabel.hidden = NO;
    headLabel.hidden = NO;
    
    contentLabel.textColor = [UIColor primaryColor];
    
    switch (contentType) {
        case ProfileSettingNationality: {
            if (self.user.country != nil) {
                NSString *countryName = [CountryCodeHelper isoAlpha2CodeToName:self.user.country];
                contentLabel.text = countryName;
            } else {
                contentLabel.textColor = [UIColor championsLeagueColor];
                contentLabel.text = @"Unknown";
            }
            break;
        }
        
        case ProfileSettingNotification:
        case ProfileSettingSubscription:  // Disable for current release
            rightCursor.hidden = YES;
            contentLabel.hidden = YES;
            headLabel.hidden = YES;
            break;
            
        case ProfileSettingRateUs:
        case ProfileSettingAbout:
        case ProfileSettingHelp:
            contentLabel.hidden = YES;
        default:
            break;
    }
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    if (self.delegate != nil) {
        [self.delegate onChangeText:textView.text type:contentType];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
