//
// Created by Anders Hansen on 10/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "Crashlytics.h"
#import "FieldPlayerView.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "BadgeView.h"
#import "UIColor+LineupBattle.h"

@interface FieldPlayerView ()
@property(nonatomic, strong) DefaultLabel *playerName;
@property(nonatomic, strong) DefaultImageView *playerImage;
@property (nonatomic, strong) UIButton *button;
@end

@implementation FieldPlayerView

- (instancetype)initWithPlayer:(Player *)player {
    self = [super init];
    if (self) {
        self.playerName = [DefaultLabel initWithBoldSystemFontSize:13 color:[UIColor whiteColor]];

        [self addSubview:self.playerName];
        [self addSubview:self.playerImage];
        [self addSubview:self.button];

        [self setPlayer:player];
    }

    return self;
}

- (void)setPlayer:(Player *)player {
    _player = player;
    NSString *playerName = player.name ? player.name : @"Unknown";
    self.playerName.text = playerName;
    [self.playerImage loadImageWithUrlString:[player photoImageUrlString:@"34"] placeholder:@"playerPlaceholderThumb"];
    
    if (player.events.count > 0) {
        [self setupPlayerEvent:player.events];
    }
}

- (void)setupSubstituteEvent {
    DefaultImageView *imgSubstitute = [[DefaultImageView alloc] init];
    [imgSubstitute circleWithBorder:[UIColor whiteColor] diameter:15 borderWidth:1];
    [imgSubstitute setImage:[UIImage imageNamed:@"ic_substitution"]];
    [self addSubview:imgSubstitute];
    
    [imgSubstitute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerImage);
        make.bottom.equalTo(self.playerImage);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
}

- (void)setupPlayerEvent:(NSArray *)events {
    int index = 0, cardIndex = 0;
    NSMutableArray *cardEventImageArray = NSMutableArray.new;
    NSMutableArray *eventImageArray = NSMutableArray.new;
    for (NSDictionary *event in events) {
        NSString *eventType = event[@"type"];
        int eventCount = [event[@"count"] intValue];
        if ([eventType isEqualToString:@"substitution"]) {
            [self setupSubstituteEvent];
        }
        
        else if ([eventType isEqualToString:@"goal"] ||
                 [eventType isEqualToString:@"own-goal"]) {
            // Setup Goal events
            
            DefaultImageView *imgEvent = [[DefaultImageView alloc] init];
            imgEvent.image = [UIImage imageNamed:[self getImageNameFromEventType:eventType]];
            [imgEvent circleWithBorder:[UIColor whiteColor] diameter:18 borderWidth:1];
            [self addSubview:imgEvent];
            
            if (eventCount > 1 && [eventType isEqualToString:@"goal"]) { //Add badge if count > 0
                BadgeView *badge = [[BadgeView alloc] initWithColor:[UIColor primaryColor]];
                badge.borderWidth = 0;
                badge.textLabel.text = [NSString stringWithFormat:@"%d", eventCount];
                [self addSubview:badge];
                [badge mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(@(14));
                    make.right.equalTo(imgEvent).offset(3);
                    make.top.equalTo(imgEvent).offset(-4);
                }];
            }
            
            if (eventImageArray.count > index) {
                UIView *lastEvent = (UIView *)[eventImageArray objectAtIndex:index];
                [imgEvent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastEvent.mas_left).offset(-10);
                    make.top.equalTo(self.playerImage).offset(-4);
                    make.height.equalTo(@18);
                    make.width.equalTo(@18);
                }];
            } else {
                [imgEvent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.playerImage).offset(-3);
                    make.top.equalTo(self.playerImage).offset(-4);
                    make.height.equalTo(@18);
                    make.width.equalTo(@18);
                }];
            }
            [eventImageArray addObject:imgEvent];
            index++;
        }
        
        else if ([eventType isEqualToString:@"yellow-card"] ||
                 [eventType isEqualToString:@"2nd-yellow-card"] ||[eventType isEqualToString:@"red-card"] ) {
            // Setup Foul Card events
            
            UIImageView *imgEvent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getImageNameFromEventType:eventType]]];
            imgEvent.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imgEvent];
            
            if (cardEventImageArray.count > cardIndex) {
                UIView *lastEvent = (UIView *)[cardEventImageArray objectAtIndex:cardIndex];
                [imgEvent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(lastEvent.mas_left).offset(10);
                    make.top.equalTo(self.playerImage).offset(-4);
                    make.height.equalTo(@18);
                }];
            } else {
                [imgEvent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.playerImage).offset(3);
                    make.top.equalTo(self.playerImage).offset(-4);
                    make.height.equalTo(@18);
                }];
            }
            [cardEventImageArray addObject:imgEvent];
            cardIndex++;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.playerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-2);
    }];

    [self.playerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.playerName.mas_top).offset(-2);
        make.size.equalTo(@40);
    }];

    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
        make.edges.equalTo(self).with.insets(padding);
    }];

    [super layoutSubviews];
}

+ (instancetype)initWithPlayer:(Player *)player {
    return [[self alloc] initWithPlayer:player];
}

- (void)goToPlayer:(id)sender {
    if (self.player) {
        CLS_LOG(@"Player: %@", self.player.objectId);

        [[Mixpanel sharedInstance] track:@"Player" properties:@{
            @"id": self.player.objectId ?: [NSNull null],
            @"name": self.player.name ?: [NSNull null],
            @"from": @"lineup"
        }];

        [self.delegate buttonWasPressed:self];
    }
}

- (NSString *)getImageNameFromEventType:(NSString *)eventType {
    // goal, ps-goal, own-goal, missed-penalty, yellow-card, 2nd-yellow-card, red-card
    if ([eventType isEqualToString:@"goal"]) {
        return @"ic_goal";
    } else if ([eventType isEqualToString:@"own-goal"]) {
        return @"own_goal";
    } else if ([eventType isEqualToString:@"yellow-card"]) {
        return @"squad_yellow_card";
    } else if ([eventType isEqualToString:@"2nd-yellow-card"]) {
        return @"squad_yellow_card_again";
    } else if ([eventType isEqualToString:@"red-card"]) {
        return @"squad_red_card";
    }
    return nil;
}

#pragma mark - Views

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(goToPlayer:) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor clearColor];
    }

    return _button;
}

- (DefaultImageView *)playerImage {
    if (!_playerImage ) {
        _playerImage = [[DefaultImageView alloc] init];
        [_playerImage circleWithBorder:[UIColor whiteColor] diameter:40 borderWidth:2.f];
        _playerImage.image = [UIImage imageNamed:@"playerPlaceholderThumb"];
    }

    return _playerImage;
}

@end
