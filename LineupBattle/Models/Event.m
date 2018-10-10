//
// Created by Anders Hansen on 19/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "Event.h"
#import "HexColors.h"
#import "UIColor+LineupBattle.h"

@implementation Event

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"home" : @"home",

        // Types
        //
        // Server events: goal, ps-goal, own-goal, missed-penalty, substitution, yellow-card, 2nd-yellow-card, red-card
        // Client events: halftime, fulltime, assist
        //
        @"type" : @"type",

        // When
        // { minutes: 45, overtime: 2 }
        //
        @"time" : @"when",
        @"player" : @"player",
        @"in" : @"in",
        @"out" : @"out",
        @"assist": @"assist",
    };
}

+ (NSValueTransformer *)inJSONTransformer {
    return [self.class playerJSONTransformer];
}

+ (NSValueTransformer *)outJSONTransformer {
    return [self.class playerJSONTransformer];
}

+ (NSValueTransformer *)assistJSONTransformer {
    return [self.class playerJSONTransformer];
}

- (void)setScoreAtEvent:(NSDictionary *)scoreAtEvent {
    self.score = scoreAtEvent;
}

- (Player *)playerInFocus {
    if (self.isSubstitution) {
        return self.in;
    } else if (self.isAssistEvent) {
        return self.assist;
    } else {
        return self.player;
    }
}

#pragma mark - Decorator methods
- (BOOL)isGoal {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"goal"] || self.isPenaltyGoal || self.isPenaltyShootoutGoal;
}

- (BOOL)isPenaltyGoal {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"p-goal"];
}

- (BOOL)isPenaltyShootoutGoal {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"ps-goal"];
}

- (BOOL)isOwnGoal {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"own-goal"];
}

- (BOOL)isFullTime {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"fulltime"];
}

- (BOOL)isSubstitution {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"substitution"];
}

- (BOOL)isYellowCard {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"yellow-card"];
}

- (BOOL)isRedCard {
    if (!self.type) return NO;
    return [self.type isEqualToString:@"red-card"];
}

- (BOOL)isSecondYellow {
    return [self.type isEqualToString:@"2nd-yellow-card"];
}

- (BOOL)isHome {
    if (!self.type) return NO;
    return self.home;
}

- (BOOL)isMissedPenalty {
    return [self.type isEqualToString:@"missed-penalty"] || self.isMissedPenaltyShootoutGoal;
}

- (BOOL)isMissedPenaltyShootoutGoal {
    return [self.type isEqualToString:@"ps-missed-penalty"];
}

- (BOOL)hasAssist {
    if (!self.type) return NO;
    return (BOOL)self.assist;
}

- (BOOL)isPenaltyShootoutEvent {
    return self.isMissedPenaltyShootoutGoal || self.isPenaltyShootoutGoal;
}

- (NSString *)mainText {
    if (self.isSubstitution) {
       return self.in.name;
    } else if (self.isAssistEvent) {
        return self.assist.name;
    } else if (self.isGoal || self.isOwnGoal) {
        if (self.isHome) {
            return [NSString stringWithFormat:@"%@-%@ %@", self.score[@"home"], self.score[@"away"], self.player.name];
        } else {
            return [NSString stringWithFormat:@"%@ %@-%@", self.player.name, self.score[@"home"], self.score[@"away"]];
        }

    } else {
       return self.player.name;
    }
}

- (NSString *)secondaryText {
    if (self.isSubstitution) {
        return self.out.name;
    } else if (self.isAssistEvent) {
        return @"Assist";
    } else if (self.isPenaltyGoal) {
        return @"Penalty Goal";
    } else if (self.isMissedPenalty) {
        return @"Missed penalty";
    } else if (self.isOwnGoal) {
        return @"Own goal";
    } else if (self.isGoal) {
        return @"Goal";
    } else {
        return @"";
    }
}

- (NSString *)eventImage {
    if (self.isGoal) {
       return @"football";
    } else if (self.isOwnGoal) {
       return @"own_goal";
    } else if (self.isSubstitution) {
       return @"substitution";
    } else if (self.isYellowCard) {
       return @"yellowcard";
    } else if (self.isRedCard) {
       return @"red";
    } else if (self.isSecondYellow) {
       return @"second_yellow";
    } else if (self.isMissedPenalty) {
       return @"missed";
    }

    return @"";
}

- (UIColor *)eventColor {
    return [UIColor primaryColor];
//    if ([self.type isEqualToString:@"substitution"]) {
//        return [UIColor hx_colorWithHexString:@"#00b763"];
//    } else if (self.isOwnGoal || self.isRedCard || self.isSecondYellow || self.isMissedPenalty) {
//        return [UIColor hx_colorWithHexString:@"#e74c3c"];
//    } else if (self.isYellowCard) {
//        return [UIColor hx_colorWithHexString:@"#fcd800"];
//    } else {
//        return [UIColor hx_colorWithHexString:@"#383534"];
//    }
}

- (NSString *)cellName {
    NSString *side = self.isHome ? @"left" : @"right";
    NSString *rows = @"single";

    if(self.isSubstitution) {
        rows = @"double";
    } else if (self.isAssistEvent) {
        rows = @"assistEvent";
    } else if (self.hasAssist) {
        rows = @"assist";
    }

    return [NSString stringWithFormat:@"%@-%@", side, rows];
}


@end
