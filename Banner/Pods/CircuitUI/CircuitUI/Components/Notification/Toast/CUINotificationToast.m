//
//  CUINotificationToast.m
//  CircuitUI
//
//  Created by Anuraag Shakya on 01.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUINotificationToast.h"
#import "CUIColorHelpers.h"
#import "CUIColorRef.h"
#import "CUILabelBody1.h"
#import "CUILabelBody1CallToAction+Private.h"
#import "CUISemanticColor.h"
#import "CUISpacing.h"
#import "UIImage+CUILibrary.h"
#import "UIImage+Resources+Private.h"
#import "CTAButton.h"
#import "Animation+Helpers.h"

@interface CUINotificationToast ()

@property (nonatomic, weak) CUILabel *titleLabel;
@property (nonatomic, weak) CUILabelBody1 *subtitleLabel;
@property (nonatomic, weak) CTAButton *actionLabel;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, readwrite) CUINotificationToastVariant variant;
@property (nonatomic) CUINotificationToastDismissResultBlock dismissResultBlock;

@end

@implementation CUINotificationToast

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle variant:(CUINotificationToastVariant)variant {
    NSParameterAssert(subtitle);
    self = [super init];

    if (self) {
        [self commonInitWithAction:NO isDismissable:NO];
        self.title = title;
        self.subtitle = subtitle;
        self.variant = variant;
    }

    return self;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle variant:(CUINotificationToastVariant)variant actionTitle:(NSString *)actionTitle dismissResultBlock:(CUINotificationToastDismissResultBlock)dismissResultBlock {
    NSParameterAssert(subtitle);
    NSParameterAssert(actionTitle);
    NSParameterAssert(dismissResultBlock);

    self = [super init];

    if (self) {
        [self commonInitWithAction:YES isDismissable:YES];
        self.title = title;
        self.subtitle = subtitle;
        self.variant = variant;
        [self setActionTitle:actionTitle];
        self.dismissResultBlock = dismissResultBlock;
    }

    return self;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle variant:(CUINotificationToastVariant)variant dismissResultBlock:(CUINotificationToastDismissResultBlock)dismissResultBlock {
    NSParameterAssert(subtitle);
    NSParameterAssert(dismissResultBlock);

    self = [super init];

    if (self) {
        [self commonInitWithAction:NO isDismissable:YES];
        self.title = title;
        self.subtitle = subtitle;
        self.variant = variant;
        self.dismissResultBlock = dismissResultBlock;
    }

    return self;
}

- (void)commonInitWithAction:(BOOL)hasAction isDismissable:(BOOL)isDismissable {
    self.layoutMargins = UIEdgeInsetsMake(CUISpacingKilo, CUISpacingMega, CUISpacingKilo, CUISpacingMega);
    self.backgroundColor = CUISemanticColor.backgroundColor;

    CUILabelBody1 *titleLabel = [CUILabelBody1 new];
    titleLabel.variant = CUILabelBodyVariantHighlight;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.numberOfLines = 0;

    CUILabelBody1 *subtitleLabel = [CUILabelBody1 new];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleLabel.numberOfLines = 0;

    UIStackView *labelStackView = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, subtitleLabel]];
    labelStackView.translatesAutoresizingMaskIntoConstraints = NO;
    labelStackView.axis = UILayoutConstraintAxisVertical;
    labelStackView.spacing = CUISpacingNano;
    labelStackView.alignment = UIStackViewAlignmentLeading;
    [labelStackView setLayoutMarginsRelativeArrangement:YES];
    labelStackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(CUISpacingNano, 0, 0, 0);

    if (hasAction) {
        CTAButton *actionLabel = [CTAButton new];
        actionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        actionLabel.titleLabel.numberOfLines = 0;
        actionLabel.isAccessibilityElement = YES;
        actionLabel.accessibilityTraits = UIAccessibilityTraitButton;

        [labelStackView addArrangedSubview:actionLabel];
        [labelStackView setCustomSpacing:CUISpacingByte afterView:subtitleLabel];

        [actionLabel addTarget:self action:@selector(didRecognizeActionLabelTap:)forControlEvents:UIControlEventTouchDown];

        self.actionLabel = actionLabel;
    }

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., 24., 24.)];
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [iconImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    UIStackView *horizontalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[iconImageView, labelStackView]];
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    horizontalStackView.spacing = CUISpacingMega;
    horizontalStackView.alignment = UIStackViewAlignmentTop;

    if (isDismissable) {
        UIImage *dismissIcon = UIImage.cui_close_16;
        UIButton *dismissButton = [[UIButton alloc] init];
        [dismissButton setImage:dismissIcon forState:UIControlStateNormal];
        [dismissButton addTarget:self action:@selector(didTapDismissButton:) forControlEvents:UIControlEventTouchUpInside];

        dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
        [dismissButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [dismissButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        [horizontalStackView addArrangedSubview:dismissButton];
        [horizontalStackView setCustomSpacing:CUISpacingPeta afterView:labelStackView];
    }

    [self addSubview:horizontalStackView];
    [NSLayoutConstraint activateConstraints:@[
        [horizontalStackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
        [horizontalStackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
        [horizontalStackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
        [horizontalStackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor]
    ]];

    self.layer.borderWidth = CUISpacingNano;
    self.layer.cornerRadius = CUISpacingByte;

    self.titleLabel = titleLabel;
    self.subtitleLabel = subtitleLabel;
    self.iconImageView = iconImageView;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self.titleLabel setHidden:[self shouldHideLabelForText:title]];
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle{
    self.subtitleLabel.text = subtitle;
}

- (NSString *)subtitle {
    return self.subtitleLabel.text;
}

- (void)setActionTitle:(NSString *)actionTitle {
    [self.actionLabel setTitle:actionTitle];
    self.actionLabel.accessibilityLabel = actionTitle;
}

- (void)setVariant:(CUINotificationToastVariant)variant {
    _variant = variant;
    self.iconImageView.image = [self imageForCurrentVariant];
    self.iconImageView.tintColor = [self tintColorForCurrentVariant];
    self.layer.borderColor = [self tintColorForCurrentVariant].CGColor;
}

- (void)addLinkInSubtitleWithURL:(NSURL *)url toSubstring:(NSString *)substring {
    [self.subtitleLabel addLinkWithURL:url toSubstring:substring];
}

- (void)addLinkInSubtitleWithURL:(NSURL *)url toRange:(NSRange)range {
    [self.subtitleLabel addLinkWithURL:url toSubstringWithRange:range];
}

- (void)floatAboveView:(UIView *)containerView {
    [self showInView:containerView];
}

- (void)showInView:(UIView *)containerView {
    [self prepareForShowingIn:containerView];

    NSLayoutConstraint *bottomConstraint = [containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:CUISpacingMega];

    bottomConstraint.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[
        bottomConstraint,
        [containerView.safeAreaLayoutGuide.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)showInView:(UIView *)containerView transition:(CUINotificationToastTransition)transition {
    switch (transition) {
        case CUINotificationToastTransitionNone:
            [self showInView:containerView];
        case CUINotificationToastTransitionSlideIn:
            [self showWithSlideTransitionInView:containerView];
    }
}

- (void)showWithSlideTransitionInView:(UIView *)containerView {
    [self prepareForShowingIn:containerView];
    NSLayoutConstraint *topToContainerBottomConstraint = [containerView.bottomAnchor constraintEqualToAnchor:self.topAnchor constant:CUISpacingMega];
    NSLayoutConstraint *bottomToContainerBottomConstraint = [containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:CUISpacingMega];
    NSLayoutConstraint *bottomToContainerSafeAreaBottomConstraint = [containerView.safeAreaLayoutGuide.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomAnchor];

    // Initially place below containerView bottom
    bottomToContainerSafeAreaBottomConstraint.priority = UILayoutPriorityDefaultLow;
    topToContainerBottomConstraint.priority = UILayoutPriorityDefaultHigh;
    bottomToContainerBottomConstraint.priority = UILayoutPriorityDefaultLow;
    [NSLayoutConstraint activateConstraints:@[
        topToContainerBottomConstraint,
        bottomToContainerBottomConstraint,
        bottomToContainerSafeAreaBottomConstraint
    ]];
    [containerView layoutIfNeeded];

    // Move with animation to expected position
    topToContainerBottomConstraint.priority = UILayoutPriorityDefaultLow;
    bottomToContainerBottomConstraint.priority = UILayoutPriorityDefaultHigh;
    bottomToContainerSafeAreaBottomConstraint.priority = 900;
    [UIView animateWithDuration:CUIAnimationDurationDefault animations:^{
        [containerView layoutIfNeeded];
    }];

    // Hide after 6 seconds
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!weakSelf || !weakSelf.superview) {
            return;
        }
        topToContainerBottomConstraint.priority = UILayoutPriorityDefaultHigh;
        bottomToContainerBottomConstraint.priority = UILayoutPriorityDefaultLow;
        bottomToContainerSafeAreaBottomConstraint.priority = UILayoutPriorityDefaultLow;
        [UIView animateWithDuration:CUIAnimationDurationDefault animations:^{
            [containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [weakSelf dismiss];
        }];
    });
}

- (void)dismiss {
    [self dismissWithResult:CUINotificationToastDismissCauseProgrammatic];
}

- (void)didRecognizeActionLabelTap:(UITapGestureRecognizer *)sender {
    [self dismissWithResult:CUINotificationToastDismissCauseCTA];
}

- (void)didTapDismissButton:(UIButton *)sender {
    [self dismissWithResult:CUINotificationToastDismissCauseClose];
}

- (void)dismissWithResult:(CUINotificationToastDismissCause)dismissResult {
    if (self.dismissResultBlock) {
        self.dismissResultBlock(dismissResult);
    }

    [self removeFromSuperview];
}

#pragma mark - Helpers

- (void)prepareForShowingIn:(UIView *)containerView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:self];
    [NSLayoutConstraint activateConstraints:@[
        [self.leadingAnchor constraintGreaterThanOrEqualToAnchor:containerView.safeAreaLayoutGuide.leadingAnchor constant:CUISpacingMega],
        [containerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
    ]];
}

- (UIImage *)imageForCurrentVariant {
    NSString *imageName;
    switch ([self variant]) {
        case CUINotificationToastVariantAlert:
            imageName = @"notification_icon_alert";
            break;

        case CUINotificationToastVariantConfirm:
            imageName = @"notification_icon_confirm";
            break;

        case CUINotificationToastVariantNeutral:
            imageName = @"notification_icon_neutral";
            break;

        case CUINotificationToastVariantNotify:
            imageName = @"notification_icon_notify";
            break;
    }

    if (!imageName) {
        NSAssert(NO, @"Unknown notification toast variant encountered");
        return nil;
    }

    return [[UIImage cui_imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIColor *)tintColorForCurrentVariant {
    UIColor *color;
    switch ([self variant]) {
        case CUINotificationToastVariantAlert:
            color = CUISemanticColor.alertColor;
            break;

        case CUINotificationToastVariantConfirm:
            color = CUISemanticColor.confirmColor;
            break;

        case CUINotificationToastVariantNeutral:
            color = CUISemanticColor.tintColor;
            break;

        case CUINotificationToastVariantNotify:
            color = CUISemanticColor.notifyColor;
            break;
    }

    if (!color) {
        NSAssert(NO, @"Unknown notification toast variant encountered");
        color = CUISemanticColor.tintColor;
    }

    return color;
}

- (BOOL)shouldHideLabelForText:(NSString *)text {
    return [text isEqualToString:@""] || text == nil;
}

@end
