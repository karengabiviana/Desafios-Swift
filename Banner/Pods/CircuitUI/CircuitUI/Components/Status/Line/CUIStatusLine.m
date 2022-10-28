//
//  CUIStatusLine.m
//  CircuitUI
//
//  Created by Hagi on 04.10.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIStatusLine.h"

#import "CUICircleView.h"
#import "CUILabelBody2.h"
#import "CUISpacing.h"
#import "CUIStatusVariantColors.h"
#import "UIImage+CUILibrary.h"

@import SumUpUtilities;

@interface CUIStatusLine ()
/// This circle is a background layer of the icon, to "tint" the cutouts of
/// the icon.
@property (nonatomic, weak, readonly) CUICircleView *backgroundCircle;
@property (nonatomic, weak, readonly) CUILabelBody2 *label;
@property (nonatomic, weak, readonly) UIImageView *imageView;
@end

@implementation CUIStatusLine

@dynamic backgroundColor;
@dynamic layer;

- (instancetype)initWithIcon:(CUIStatusLineIcon)icon text:(NSString *)statusText variant:(CUIStatusVariant)variant {
    NSParameterAssert(statusText);

    self = [super initWithFrame:CGRectZero];
    if (self) {
        _icon = icon;
        _text = [statusText copy];
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
    // Circle height is equal to label height, but according to designs it shoudn't be less
    // than 16 points. 
    [[circle.heightAnchor constraintGreaterThanOrEqualToConstant:16] setActive:YES];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView = imageView;

    [circle smp_addSubview:imageView withConstraints:@[
        [imageView.centerYAnchor constraintEqualToAnchor:circle.centerYAnchor],
        [imageView.centerXAnchor constraintEqualToAnchor:circle.centerXAnchor],
        [imageView.widthAnchor constraintEqualToAnchor:imageView.heightAnchor],
        // The circle is slightly smaller than the image view, as it's
        // only meant to fill the icon cutout areas. We avoid the borders
        // to prevent rasterization issues.
        [imageView.heightAnchor constraintEqualToAnchor:circle.heightAnchor constant:1.0]
    ]];

    CUILabelBody2 *label = [[CUILabelBody2 alloc] init];
    _label = label;
    label.variant = CUILabelBodyVariantHighlight;

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[circle, label]];
    stack.spacing = CUISpacingBit;

    [self smp_addSubview:stack withConstraints:@[
        [self.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
        [self.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
        [self.bottomAnchor constraintEqualToAnchor:stack.bottomAnchor],
        [self.topAnchor constraintEqualToAnchor:stack.topAnchor]
    ]];

    // only the label/font size is supposed to determine
    // the height of the component
    [circle setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    // this is an accessibility container – only the
    // label will be used for accessibility purposes
    self.isAccessibilityElement = NO;
}

#pragma mark - Content Updates

- (void)updateDisplay {
    self.label.text = self.text;

    UIImage *image;
    switch (self.icon) {
        case CUIStatusLineIconAlert:
            image = [UIImage cui_alert_16];
            break;
        case CUIStatusLineIconConfirm:
            image = [UIImage cui_confirm_16];
            break;
        case CUIStatusLineIconNotify:
            image = [UIImage cui_notify_16];
            break;
        case CUIStatusLineIconPaidOut:
            image = [UIImage cui_paid_out_16];
            break;
        case CUIStatusLineIconRefunded:
            image = [UIImage cui_refunded_16];
            break;
        case CUIStatusLineIconTime:
            image = [UIImage cui_time_16];
            break;
        case CUIStatusLineIconInfo:
            image = [UIImage cui_info_16];
            break;
    }
    NSAssert(image, @"Unknown icon case: %@", @(self.icon));
    self.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    self.imageView.tintColor = CUITintColorFromStatusVariant(self.variant);
    self.backgroundCircle.backgroundColor = CUIContrastColorFromStatusVariant(self.variant);

    [self invalidateIntrinsicContentSize];
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    [self updateDisplay];
}

- (void)setIcon:(CUIStatusLineIcon)icon {
    _icon = icon;
    [self updateDisplay];
}

- (void)setVariant:(CUIStatusVariant)variant {
    _variant = variant;
    [self updateDisplay];
}

#pragma mark - Accessibility

- (NSArray *)accessibilityElements {
    return @[self.label];
}

@end
