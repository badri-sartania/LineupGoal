//
// Created by Anders Hansen on 04/02/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "NotificationButtonView.h"
#import "DefaultLabel.h"
#import "DefaultImageView.h"
#import "UIColor+LineupBattle.h"
#import "HexColors.h"

@interface NotificationButtonView ()
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) DefaultImageView *imageView;
@property(nonatomic, strong) DefaultLabel *type;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) ViewModelWithSubscriptions *viewModel;
@end

@implementation NotificationButtonView

- (id)initWithName:(NSString *)name key:(NSString *)key viewModel:(ViewModelWithSubscriptions *)viewModel {
    self = [super init];

    if (self) {
        self.viewModel = viewModel;
        self.identifier = key;

        self.type = [DefaultLabel initWithSystemFontSize:12];
        self.imageView = [[DefaultImageView alloc] init];

        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.imageView];
        [self addSubview:self.type];
        [self addSubview:self.button];

        // Data
        self.type.text = name;

        // Layout
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(15);
            make.size.equalTo(@25);
        }];

        [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(47);
        }];

        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        @weakify(self);
        if ([key isEqualToString:@"reminder"]) {
            [RACObserve(self.viewModel.subscription, reminder) subscribeNext:^(NSNumber *selected) {
                @strongify(self);
                self.selected = [selected boolValue];
                [self buttonSelected:self.selected];
            }];
        } else if ([key isEqualToString:@"lineup"]) {
            [RACObserve(self.viewModel.subscription, lineup) subscribeNext:^(NSNumber *selected) {
                @strongify(self);
                self.selected = [selected boolValue];
                [self buttonSelected:self.selected];
            }];
        } else if ([key isEqualToString:@"kickOff"]) {
            [RACObserve(self.viewModel.subscription, kickOff) subscribeNext:^(NSNumber *selected) {
                @strongify(self);
                self.selected = [selected boolValue];
                [self buttonSelected:self.selected];
            }];
        } else if ([key isEqualToString:@"goals"]) {
            [RACObserve(self.viewModel.subscription, goals) subscribeNext:^(NSNumber *selected) {
                @strongify(self);
                self.selected = [selected boolValue];
                [self buttonSelected:self.selected];
            }];
        } else if ([key isEqualToString:@"redCards"]) {
            [RACObserve(self.viewModel.subscription, redCards) subscribeNext:^(NSNumber *selected) {
                @strongify(self);
                self.selected = [selected boolValue];
                [self buttonSelected:self.selected];
            }];
        } else if ([key isEqualToString:@"ht"]) {
            [RACObserve(self.viewModel.subscription, ht) subscribeNext:^(NSNumber *selected) {
                @strongify(self);
                self.selected = [selected boolValue];
                [self buttonSelected:self.selected];
            }];
        } else if ([key isEqualToString:@"ft"]) {
            [RACObserve(self.viewModel.subscription, ft) subscribeNext:^(NSNumber *selected) {
                @strongify(self);
                self.selected = [selected boolValue];
                [self buttonSelected:self.selected];
            }];
        }
    }

    return self;
}

#pragma mark - Button state handling
- (void)toggleStateChange {
    [self setState:!self.selected];
}

- (void)setState:(BOOL)state {
    self.selected = state;
    [self.viewModel.subscription setValue:@(self.selected) forKey:self.identifier];
}

- (void)buttonSelected:(BOOL)selected {
    self.type.textColor = selected ? [UIColor darkGrayTextColor] : [UIColor hx_colorWithHexString:@"372533"];

    NSString *newImageName = [NSString stringWithFormat:@"%@%@", self.identifier, (selected ? @"blue" : @"")];
    self.imageView.image = [UIImage imageNamed:newImageName];
}

- (void)changeState {
     [self toggleStateChange];
}

@end
