//
// Created by Anders Hansen on 29/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "ImageTextViewCell.h"
#import "DefaultImageView.h"
#import "ImageViewWithBadge.h"
#import "UIColor+LineupBattle.h"

@interface ImageTextViewCell ()
@property (nonatomic, strong) DefaultLabel *team;
@property (nonatomic, strong) DefaultImageView *playerImage;
@property (nonatomic, strong) NSMutableArray *eventViews;
@end

@implementation ImageTextViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.playerName = [DefaultLabel initWithBoldSystemFontSize:14 color:[UIColor primaryColor]];
        self.playerPosition = [DefaultLabel initWithSystemFontSize:13 color:[UIColor secondaryTextColor]];
        self.playerImage  = [[DefaultImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.playerImage circleWithBorder:[UIColor whiteColor] diameter:40 borderWidth:1.0];
        [self addSubview:self.playerImage];
        [self addSubview:self.playerName];
        [self addSubview:self.playerPosition];
        self.eventViews = NSMutableArray.new;
    }

    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearPlayerEvents];
}

- (void)clearPlayerEvents {
    for (UIView *view in self.eventViews) {
        [view removeFromSuperview];
    }
}

- (void)setData:(Player *)player position:(NSInteger)position{
    if (position % 2 == 0) {
        [self setBackgroundColor:[UIColor lightBackgroundColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    self.playerName.text = player.fullName ? player.fullName : player.name;
    self.playerPosition.text = [self getPositionFullFromShort:player.position];
    [self.playerImage loadImageWithUrlString:[player photoImageUrlString:@"40"] placeholder:@"playerPlaceholder"];
    
    if (player.events != nil && player.events.count) {
        // Setup player events;
        [self setupPlayerEvent:player.events];
    }
}

- (void)setupSubstituteEvent {
    DefaultImageView *imgSubstitute = [[DefaultImageView alloc] init];
    [imgSubstitute circleWithBorder:[UIColor whiteColor] diameter:15 borderWidth:1];
    [imgSubstitute setImage:[UIImage imageNamed:@"ic_substitution"]];
    [self addSubview:imgSubstitute];
    [self.eventViews addObject:imgSubstitute];
    
    [imgSubstitute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerImage);
        make.bottom.equalTo(self.playerImage);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
}

- (NSString *)getPositionFullFromShort:(NSString *)position {
    if ([position isEqualToString:@"fw"]) {
        return @"Forward";
    } else if ([position isEqualToString:@"df"]) {
        return @"Defender";
    } else if ([position isEqualToString:@"gk"]) {
        return @"Goalkeeper";
    } else {
        return @"Midfielder";
    }
}

- (NSString *)getImageNameFromEventType:(NSString *)eventType {
    // goal, ps-goal, own-goal, missed-penalty, yellow-card, 2nd-yellow-card, red-card
    if ([eventType isEqualToString:@"goal"]) {
        return @"ic_goal";
    } else if ([eventType isEqualToString:@"own-goal"]) {
        return @"own_goal";
    } else if ([eventType isEqualToString:@"yellow-card"]) {
        return @"yellowcard";
    } else if ([eventType isEqualToString:@"2nd-yellow-card"]) {
        return @"second_yellow";
    } else if ([eventType isEqualToString:@"red-card"]) {
        return @"red";
    }
    return nil;
}

- (void)setupPlayerEvent:(NSArray *)events {
    int index = 0;
    NSMutableArray *eventImageArray = NSMutableArray.new;
    for (NSDictionary *event in events) {
        NSString *eventType = event[@"type"];
        int eventCount = [event[@"count"] intValue];
        if ([eventType isEqualToString:@"substitution"]) {
            [self setupSubstituteEvent];
        } else if ([self getImageNameFromEventType:eventType] != nil) {
            
            UIImageView *imgEvent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getImageNameFromEventType:eventType]]];
            imgEvent.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imgEvent];
            [self.eventViews addObject:imgEvent];
            
            if (eventCount > 1 && [eventType isEqualToString:@"goal"]) { //Add badge if count > 0
                BadgeView *badge = [[BadgeView alloc] initWithColor:[UIColor primaryColor]];
                badge.textLabel.text = [NSString stringWithFormat:@"%d", eventCount];
                [self addSubview:badge];
                [self.eventViews addObject:badge];
                [badge mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(@(13));
                    make.right.equalTo(imgEvent).offset(3);
                    make.top.equalTo(imgEvent).offset(-4);
                }];
            }
            
            if (eventImageArray.count > index) {
                UIView *lastEvent = (UIView *)[eventImageArray objectAtIndex:index];
                [imgEvent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(lastEvent.mas_left).offset(-10);
                    make.centerY.equalTo(self);
                    make.height.equalTo(@16);
                }];
            } else {
                [imgEvent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-10);
                    make.centerY.equalTo(self);
                    make.height.equalTo(@16);
                }];
            }
            [eventImageArray addObject:imgEvent];
            index++;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.playerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.size.equalTo(@40);
    }];

    [self.playerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerImage.mas_right).offset(10);
        make.top.equalTo(self.playerImage.mas_top).offset(4);
    }];
    
    [self.playerPosition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerImage.mas_right).offset(10);
        make.bottom.equalTo(self.playerImage.mas_bottom).offset(-4);
    }];

    [super layoutSubviews];
}

@end
