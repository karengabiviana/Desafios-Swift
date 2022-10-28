//
//  CUIInputControlContainerView.m
//  CircuitUI
//
//  Created by Marcel Voß on 06.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIInputControlContainerView.h"

#import "CUISpacing.h"
#import "CUILabelBody2.h"
#import "CUISemanticColor.h"
#import "NSLayoutAnchor+CUISpacing.h"
#import "CUIColorHelpers.h"
#import "CUIColorRef.h"
#import "CUITextField+Private.h"

#import "CUITextFieldValidationResult.h"
#import "CUIInputControlContainerValidationStatusView.h"
#import "CUIInputControlContainerValidationResult.h"

@import SumUpUtilities;

@interface CUIInputControlContainerView ()

@property (nonatomic, weak) CUILabelBody2 *titleLabel;
@property (nonatomic, weak) CUILabelBody2 *subtitleLabel;

@property (nonatomic, weak) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) CUIInputControlContainerValidationStatusView *validationStatusView;

@property (nonatomic, weak) UIView *hostedView;
@property (nonatomic, weak) UIView *contentContainerView;

@property (nonatomic, readwrite) CUIInputControlContainerViewState state;

@end

@implementation CUIInputControlContainerView

#pragma mark - Lifecycle

- (instancetype)initWithHostedView:(UIView *)hostedView {
    return [self initWithHostedView:hostedView title:nil subtitle:nil];
}

- (instancetype)initWithHostedView:(UIView *)hostedView title:(NSString *)title subtitle:(NSString *)subtitle {
    NSParameterAssert(hostedView);

    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = [title copy];
        _subtitle = [subtitle copy];
        _hostedView = hostedView;

        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self configureTitleLabel];
    [self configureContentView];
    [self configureSubtitleLabel];

    self.backgroundColor = CUISemanticColor.backgroundColor;
}

- (void)configureTitleLabel {
    CUILabelBody2 *titleLabel = [[CUILabelBody2 alloc] initWithText:self.title];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.4;

    [self smp_addSubview:titleLabel withConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor]
    ]];

    self.titleLabel = titleLabel;
}

- (CUILabelBodyVariant)titleVariantForEnabledState:(BOOL)isEnabled {
    return isEnabled ? CUILabelBodyVariantDefault : CUILabelBodyVariantDisabled;
}

- (CUILabelBodyVariant)subtitleVariantForEnabledState:(BOOL)isEnabled {
    return isEnabled ? CUILabelBodyVariantSubtle : CUILabelBodyVariantDisabled;
}

- (void)configureContentView {
    UIView *contentContainerView = [UIView new];
    contentContainerView.layer.cornerRadius = CUISpacingByte;
    contentContainerView.backgroundColor = CUISemanticColor.backgroundColor;
    [self smp_addSubview:contentContainerView withConstraints:@[
        [contentContainerView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor spacing:CUISpacingBit],
        [contentContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [contentContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];

    [contentContainerView smp_addSubview:self.hostedView withConstraints:@[
        // we would like to have a giga minimum height, as the tap target for small
        // font sizes gets noticably harder to touch. we also want to make sure that all hosted views
        // have the same minimum height to keep them consistent.
        [self.hostedView.heightAnchor constraintGreaterThanOrEqualToConstant:CUISpacingGiga],
        [self.hostedView.topAnchor constraintEqualToAnchor:contentContainerView.layoutMarginsGuide.topAnchor],
        [self.hostedView.leadingAnchor constraintEqualToAnchor:contentContainerView.layoutMarginsGuide.leadingAnchor],
        [self.hostedView.trailingAnchor constraintEqualToAnchor:contentContainerView.layoutMarginsGuide.trailingAnchor],
        [contentContainerView.layoutMarginsGuide.bottomAnchor constraintEqualToAnchor:self.hostedView.bottomAnchor]
    ]];

    self.contentContainerView = contentContainerView;
    [self updateStyleForState:CUIInputControlContainerViewStateNormal];
}

- (void)configureSubtitleLabel {
    if (!self.subtitle) {
        if (!self.bottomConstraint) {
            self.bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor];
        }
        [self.bottomConstraint setActive:YES];
        return;
    }

    if (self.subtitleLabel && self.subtitleLabel.superview) {
        self.subtitleLabel.text = self.subtitle;
        // if we have a subtitleLabel already set up, we don't want to set it up again
        // therefore, we can simply return here after we update subtitleLabel text.
        return;
    }

    CUILabelBody2 *subtitleLabel = [[CUILabelBody2 alloc] initWithText:self.subtitle];
    subtitleLabel.variant = CUILabelBodyVariantSubtle;
    subtitleLabel.numberOfLines = 0;
    [subtitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self installFooterView:subtitleLabel];

    self.subtitleLabel = subtitleLabel;
}

- (void)installFooterView:(UIView *)footerView {
    [self.bottomConstraint setActive:NO];
    NSLayoutConstraint *bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:footerView.bottomAnchor];

    [self smp_addSubview:footerView withConstraints:@[
        [footerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [footerView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
        [footerView.topAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor spacing:CUISpacingBit],
        bottomConstraint
    ]];

    self.bottomConstraint = bottomConstraint;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = [subtitle copy];

    if (!self.validationStatusView) {
        // only configure the subtitle label if we currently don't show any validation state.
        // the subtitle will be configured appropriately once the validation has disappeared.
        [self configureSubtitleLabel];
    }
}

- (UIEdgeInsets)hostedViewMarginInsets {
    return self.contentContainerView.layoutMargins;
}

- (void)setHostedViewMarginInsets:(UIEdgeInsets)hostedViewMarginInsets {
    self.contentContainerView.layoutMargins = hostedViewMarginInsets;
}

#pragma mark - State Updating

- (void)updateStyleForValidationResult:(nullable CUIInputControlContainerValidationResult *)validationResult {
    CUIInputControlContainerViewState state = [self stateForValidationResult:validationResult];
    [self updateStyleForState:state];

    if (!validationResult || state == CUIInputControlContainerViewStateDisabled) {
        [self.validationStatusView removeFromSuperview];
        [self configureSubtitleLabel];
        return;
    }

    if ([validationResult isEqualToResult:self.validationStatusView.result]) {
        // if the result is equal to the already on-screen one, we don't do anything and return early
        return;
    }

    [self.subtitleLabel removeFromSuperview];
    [self.validationStatusView removeFromSuperview];

    CUIInputControlContainerValidationStatusView *statusView = [[CUIInputControlContainerValidationStatusView alloc] initWithValidationResult:validationResult];
    [self installFooterView:statusView];

    self.validationStatusView = statusView;
}

- (CUIInputControlContainerViewState)stateForValidationResult:(nullable CUIInputControlContainerValidationResult *)result {
    if (self.state == CUIInputControlContainerViewStateDisabled) {
        return CUIInputControlContainerViewStateDisabled;
    }

    if (!result || result.success) {
        return CUIInputControlContainerViewStateNormal;
    }

    return CUIInputControlContainerViewStateFailure;
}

- (void)updateStyleForState:(CUIInputControlContainerViewState)state {
    switch (state) {
        case CUIInputControlContainerViewStateNormal:
        case CUIInputControlContainerViewStateDisabled: {
            self.contentContainerView.layer.borderWidth = 1.;
            self.contentContainerView.layer.borderColor = [CUIColorFromHex(CUIColorRefN50) CGColor];

            break;
        }
        case CUIInputControlContainerViewStateActive: {
            self.contentContainerView.layer.borderWidth = 2.;
            self.contentContainerView.layer.borderColor = [CUISemanticColor.tintColor CGColor];

            break;
        }
        case CUIInputControlContainerViewStateFailure: {
            self.contentContainerView.layer.borderWidth = 1.;
            self.contentContainerView.layer.borderColor = [CUISemanticColor.alertColor CGColor];

            break;
        }
    }
    self.titleLabel.variant = [self titleVariantForEnabledState:state != CUIInputControlContainerViewStateDisabled];
    self.subtitleLabel.variant = [self subtitleVariantForEnabledState:state != CUIInputControlContainerViewStateDisabled];
    self.state = state;
}

@end
