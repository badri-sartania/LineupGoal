//
//  SectionHeaderView.h
//  LineupBattle
//
//  Created by Tomasz Przybyl on 1/23/18.
//  Copyright © 2018 Pumodo. All rights reserved.
//

@interface SectionHeaderView : UIView

@property(nonatomic, strong) UILabel *titleLabel;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;

@end
