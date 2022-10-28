//
//  CUIStatusIndeterminate.m
//  CircuitUI
//
//  Created by Victor Kachalov on 17.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUIStatusIndeterminate.h"

#import "CUICircleView.h"
#import "CUISpacing.h"
#import "CUIStatusVariantColors.h"

@import SumUpUtilities;

@interface CUIStatusIndeterminate ()
/// This circle is a background layer
@property (nonatomic, weak, readonly) CUICircleView *backgroundCircle;

@end

@implementation CUIStatusIndeterminate

@dynamic backgroundColor;
@dynamic layer;

- (instancetype)initWithVariant:(CUIStatusVariant)variant {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _variant = variant;

        [self setUpSubviews];
        [self updateDisplay];
    }
    return self;
}

- (void)setUpSubviews {
    NSAssert(!self.subviews.count, @"setUpSubviews should only be called once.");
    if (self.subviews.count) {
        return;
    }

    CUICircleView *circle = [[CUICircleView alloc] init];
    _backgroundCircle = circle;
    [[circle.heightAnchor constraintEqualToConstant:10] setActive:YES];

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[circle]];
    [stack setSpacing:CUISpacingBit];
    [stack setAlignment:UIStackViewAlignmentCenter];

    [self smp_addSubview:stack withConstraints:@[
        [self.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [self.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
        [self.bottomAnchor constraintEqualToAnchor:stack.bottomAnchor],
        [self.topAnchor constraintEqualToAnchor:stack.topAnchor]
    ]];
}

#pragma mark - Content Updates

- (void)updateDisplay {
    [self.backgroundCircle setBackgroundColor:CUITintColorFromStatusVariant(self.variant)];

    [self invalidateIntrinsicContentSize];
}

- (void)setVariant:(CUIStatusVariant)variant {
    _variant = variant;
    [self updateDisplay];
}

@end
