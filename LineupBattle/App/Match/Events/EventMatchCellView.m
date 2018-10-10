//
// Created by Anders Hansen on 19/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "EventMatchCellView.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"

@interface EventMatchCellView ()
@property (nonatomic, strong) DefaultLabel *eventTime;
@property (nonatomic, strong) DefaultLabel *eventOvertime;
@property (nonatomic, strong) DefaultLabel *playerName;
@property (nonatomic, strong) DefaultLabel *eventDescription;
@property (nonatomic, strong) DefaultImageView *eventImage;
@property (nonatomic, strong) DefaultImageView *playerImage;
@end

@implementation EventMatchCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.eventTime];
        [self.contentView addSubview:self.eventOvertime];
        [self.contentView addSubview:self.eventImage];
        [self.contentView addSubview:self.playerImage];
        [self.contentView addSubview:self.playerName];
        [self.contentView addSubview:self.eventDescription];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat x = self.event.isHome ? 81.75f : rect.size.width-83.75f;

    if(self.event.isAssistEvent) {
        UIBezierPath* rectanglePath1 = [UIBezierPath bezierPathWithRect: CGRectMake(x, 0.f, 1.5f, 1.5f)];
        UIBezierPath* rectanglePath2 = [UIBezierPath bezierPathWithRect: CGRectMake(x, 3.f, 1.5f, 1.5f)];
        UIBezierPath* rectanglePath3 = [UIBezierPath bezierPathWithRect: CGRectMake(x, 6.f, 1.5f, 1.5f)];
        [self.event.eventColor setFill];
        [rectanglePath1 fill];
        [rectanglePath2 fill];
        [rectanglePath3 fill];
    } else if (self.event.hasAssist) {
        UIBezierPath* rectanglePath1 = [UIBezierPath bezierPathWithRect: CGRectMake(x, 47.f, 1.5f, 1.5f)];
        UIBezierPath* rectanglePath2 = [UIBezierPath bezierPathWithRect: CGRectMake(x, 44.f, 1.5f, 1.5f)];
        [self.event.eventColor setFill];
        [rectanglePath1 fill];
        [rectanglePath2 fill];
    }
}

- (void)setupEvent:(Event *)event {
    self.event = event;

    if (event.isSubstitution) {
        self.playerName.textColor = [UIColor hx_colorWithHexString:@"2ECC71"];
        self.eventDescription.textColor = [UIColor hx_colorWithHexString:@"E74C3C"];
    } else {
        self.playerName.textColor = [UIColor primaryTextColor];
        self.eventDescription.textColor = [UIColor secondaryTextColor];
    }

    [self setData:event];
}

- (void)setData:(Event *)event {
    self.playerName.text = event.mainText;
    self.eventDescription.text = event.secondaryText;
    self.eventTime.text = [NSString stringWithFormat:@"%@\'", event.time[@"minutes"]];
    if (event.time[@"overtime"]) self.eventOvertime.text = [NSString stringWithFormat:@"+%@", event.time[@"overtime"]];
    self.eventImage.image = [UIImage imageNamed:event.eventImage];
//    [self.playerImage circleWithBorder:event.eventColor diameter:34.f borderWidth:1.5f];
    [self.playerImage circleWithBorder:[UIColor primaryColor] diameter:33.f borderWidth:1.5f];
    [self.playerImage loadImageWithUrlString:[event.playerInFocus photoImageUrlString:@"33"] placeholder:@"playerPlaceholderThumb"];
}

- (void)defineLayout:(Event *)event {
    if(!event.isHome) {
        self.eventDescription.textAlignment = NSTextAlignmentRight;
        self.playerName.textAlignment = NSTextAlignmentRight;
    }

    [self.eventImage mas_makeConstraints:^(MASConstraintMaker *make) {

        if (event.isHome) {
            make.left.equalTo(self.contentView.mas_left).offset(12);
        } else {
            make.right.equalTo(self.contentView.mas_right).offset(-12);
        }

        if(event.isAssistEvent) {
            make.centerY.equalTo(self.contentView.mas_top);
        } else if (event.hasAssist) {
            make.centerY.equalTo(self.contentView.mas_bottom);
        } else {
            make.centerY.equalTo(self.contentView);
        }

        make.size.equalTo(@20);
    }];

    [self.eventTime mas_makeConstraints:^(MASConstraintMaker *make) {
        if (event.isHome) {
            make.left.equalTo(self.eventImage.mas_right).offset(5);
        } else {
            make.right.equalTo(self.eventImage.mas_left).offset(-5);
        }

        if(event.isAssistEvent) {
            make.centerY.equalTo(self.contentView.mas_top);
        } else if (event.hasAssist) {
            make.centerY.equalTo(self.contentView.mas_bottom);
        } else {
            make.centerY.equalTo(self.contentView);
        }

        make.width.greaterThanOrEqualTo(@22);
    }];

    [self.eventOvertime mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.eventTime.mas_bottom).offset(-3);
       make.right.equalTo(self.eventTime.mas_right).offset(-4);
    }];

    NSNumber *avatarSize = @33;
    [self.playerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if (event.isHome) {
            make.left.equalTo(self.eventTime.mas_right).offset(7);
        } else {
            make.right.equalTo(self.eventTime.mas_left).offset(-7);
        }

        if (event.isAssistEvent) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
        } else if (event.hasAssist) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        } else {
            make.centerY.equalTo(self.contentView);
        }
        make.size.equalTo(avatarSize);
    }];

    [self.playerName mas_makeConstraints:^(MASConstraintMaker *make) {
        if (event.isHome) {
            make.left.equalTo(self.playerImage.mas_right).offset(8);
        } else {
            make.right.equalTo(self.playerImage.mas_left).offset(-8);
        }

        if([event.secondaryText isEqual:@""]) {
            make.centerY.equalTo(self.playerImage.mas_centerY);
        } else {
            make.centerY.equalTo(self.playerImage.mas_centerY).centerOffset(CGPointMake(0, -7));
        }
    }];

    [self.eventDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        if (event.isHome) {
            make.left.equalTo(self.playerName.mas_left);
        } else {
            make.right.equalTo(self.playerName.mas_right);
        }

        make.top.equalTo(self.playerName.mas_bottom).offset(-2);
    }];
}

#pragma mark - Views
- (DefaultImageView *)eventImage {
  if(!_eventImage) {
      _eventImage = [[DefaultImageView alloc] init];

  }

  return _eventImage;
};

- (DefaultLabel *)eventTime {
    if(!_eventTime) {
        _eventTime = [DefaultLabel initWithSystemFontSize:14];
        _eventTime.textAlignment = NSTextAlignmentCenter;
    }

    return _eventTime;
}

- (DefaultLabel *)eventOvertime {
    if (!_eventOvertime) {
        _eventOvertime = [DefaultLabel initWithAlignment:NSTextAlignmentCenter];
        _eventOvertime.textColor = [UIColor hx_colorWithHexString:@"bcbcbc"];
    }

    return _eventOvertime;
}

- (DefaultImageView *)playerImage {
    if(!_playerImage) {
        _playerImage = [[DefaultImageView alloc] init];
        _playerImage.image = [UIImage imageNamed:@"playerPlaceholderThumb"];
    }

    return _playerImage;
};

- (DefaultLabel *)playerName {
    if(!_playerName) {
        _playerName = [DefaultLabel initWithBoldSystemFontSize:15 color:[UIColor darkGrayTextColor]];
    }

    return _playerName;
}

- (DefaultLabel *)eventDescription {
    if(!_eventDescription) {
        _eventDescription = [DefaultLabel initWithSystemFontSize:13];
    }

    return _eventDescription;
}

@end
