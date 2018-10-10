//
// Created by Anders Hansen on 08/05/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "TeamFormView.h"
#import "CircleWithTextView.h"

@interface TeamFormView ()
@property(nonatomic, strong) NSMutableArray *formItems;
@end

@implementation TeamFormView

- (instancetype)init {
    self = [super init];

    if (self) {
        [self addSubviews];
        [self defineLayout];
    }

    return self;
}

- (void)addSubviews {
    self.formItems = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSUInteger i = 0; i < 5; i++) {
        CircleWithTextView *circle = [[CircleWithTextView alloc] init];
        [self.formItems addObject:circle];
        [self addSubview:circle];
    }
}

- (void)defineLayout {
    for (NSUInteger i = 0; i < 5; i++) {
        CircleWithTextView *circle = self.formItems[i];
        circle.frame = CGRectMake(i*25, 0, 20, 20);
    }
}

- (void)setData:(NSArray *)form {
    NSInteger count = form.count;
    for (NSUInteger i = 0; i < 5; i++) {
        CircleWithTextView *circle = self.formItems[i];

        if (count <= i) {
            [circle setText:@""];
        } else {
            [circle setText:form[i]];
        }

    }
}

@end
