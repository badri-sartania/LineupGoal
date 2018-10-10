//
//  LogoutTableViewCell.m
//  
//
//  Created by Morten Hansen on 04/07/2018.
//

#import "LogoutTableViewCell.h"
#import "UIColor+LineupBattle.h"

@implementation LogoutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.logoutButton = [[UIButton alloc] init];
    UIButton* logoutButton = self.logoutButton;
    [logoutButton setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor lightBorderColor]];
    [logoutButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    [logoutButton setTitleColor:[UIColor relegationColor] forState:UIControlStateNormal];
    [self.contentView addSubview: logoutButton];
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).equalTo(@20);
        make.height.equalTo(@47);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    logoutButton.clipsToBounds = YES;
    logoutButton.layer.cornerRadius = 8;//half of the width
    logoutButton.layer.borderWidth=0.0f;
    
    return self;
}
@end
