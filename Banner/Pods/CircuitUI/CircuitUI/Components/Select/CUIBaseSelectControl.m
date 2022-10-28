//
//  CUIBaseSelectControl.m
//  CircuitUI
//
//  Created by Roman Utrata on 19.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUIBaseSelectControl.h"

#import "CUIButtonGigaTertiary.h"
#import "CUIButtonStyle.h"
#import "CUIColorHelpers.h"
#import "CUIColorRef.h"
#import "CUIInputControlContainerView.h"
#import "CUILabelBody1.h"
#import "CUISemanticColor.h"
#import "CUISpacing.h"
#import "UIImage+CUILibrary.h"
#import "CUIInputControlContainerValidationResult.h"
#import "CUISelectControlValidationResult.h"
#import "CUIBaseSelectControl+Private.h"

@import SumUpUtilities;

@interface CUIBaseSelectControl ()

@property (nonatomic, weak) CUIInputControlContainerView *hostingView;
@property (nonatomic, weak) UIStackView *containerStackView;

@property (nonatomic, weak) CUILabelBody1 *titleLabel;
@property (nonatomic, weak) UIImageView *chevronView;

// these properties are defined as readonly within UIResponder, by
// redefining these as readwrite, we can assign our own views to them
// and make use of UIResponder's inputView presentation mechanism.
@property (nonatomic, readwrite) UIView *inputView;
@property (nonatomic, readwrite) UIView *inputAccessoryView;
@property (nonatomic, weak) CUILabelBody1 *inputAccessoryViewTitleLabel;

@end

@implementation CUIBaseSelectControl

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (void)cui_commonInit {
    _continousSelectionUpdates = YES;

    [self configureContentHostingView];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(togglePickerVisibility)];
    [self addGestureRecognizer:tapGestureRecognizer];

    self.inputView = [self createSelectionView];
    self.inputAccessoryView = [self createSelectionAccessoryView];
}

- (CUISelectControlValidationResult * _Nullable)validationResult {
    NSAssert(NO, @"Subclasses must override validationResult");
    return nil;
}

- (UIView *)createSelectionView {
    NSAssert(NO, @"Subclasses must override createSelectionView");
    return nil;
}

- (NSString * _Nullable)selectedOptionText {
    NSAssert(NO, @"Subclasses must override selectedOptionText");
    return @"";
}

- (void)prepareToShowSelectionView {
    NSAssert(NO, @"Subclasses must override prepareToShowSelectionView");
}

- (void)prepareToHideSelectionView {
    NSAssert(NO, @"Subclasses must override prepareToHideSelectionView");
}

#pragma mark - Configuration

- (void)configureContentHostingView {
    CUIInputControlContainerView *hostingView = [[CUIInputControlContainerView alloc] initWithHostedView:[self createPickerView] title:self.title subtitle:self.subtitle];
    hostingView.hostedViewMarginInsets = [self layoutMarginInsetsForPickerSize];

    [self smp_addSubview:hostingView withConstraints:@[
        [self.leadingAnchor constraintEqualToAnchor:hostingView.leadingAnchor],
        [self.trailingAnchor constraintEqualToAnchor:hostingView.trailingAnchor],
        [self.topAnchor constraintEqualToAnchor:hostingView.topAnchor],
        [self.bottomAnchor constraintEqualToAnchor:hostingView.bottomAnchor]
    ]];

    self.hostingView = hostingView;
}

- (UIView *)createPickerView {
    CUILabelBody1 *titleLabel = [CUILabelBody1 new];
    self.titleLabel = titleLabel;

    UIImageView *chevronView = [[UIImageView alloc] initWithImage:[UIImage cui_chevron_down_24]];
    chevronView.contentMode = UIViewContentModeScaleAspectFit;
    chevronView.tintColor = CUIColorFromHex(CUIColorRefN100);
    [chevronView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [chevronView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.chevronView = chevronView;

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, chevronView]];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = [self spacingForPickerSize];
    stackView.distribution = UIStackViewDistributionFill;

    [self updateStyleForState];

    return stackView;
}

- (void)updateStyleForState {
    // when we're currently the first responder, we would like to be in an active state,
    // even if validation has failed before. once we're no longer first responder, we restore
    // the state.
    CUIInputControlContainerViewState state = self.isFirstResponder ? CUIInputControlContainerViewStateActive : self.hostingView.state;
    [self.hostingView updateStyleForState:state];

    NSString *text = [self selectedOptionText];
    if (text == nil) {
        self.titleLabel.text = self.placeholder;
        self.titleLabel.variant = CUILabelBodyVariantSubtle;
    } else {
        self.titleLabel.text = text;
        self.titleLabel.variant = CUILabelBodyVariantDefault;
    }
}

- (void)reloadPicker {
    [self.hostingView removeFromSuperview];

    [self configureContentHostingView];
}

#pragma mark - Setters/Getters

- (NSString *)title {
    return self.hostingView.title;
}

- (void)setTitle:(NSString *)title {
    self.hostingView.title = title;
    self.inputAccessoryViewTitleLabel.text = title;
}

- (NSString *)subtitle {
    return self.hostingView.subtitle;
}

- (void)setSubtitle:(NSString *)subtitle {
    self.hostingView.subtitle = subtitle;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.titleLabel.text = self.placeholder;
}

- (void)setSize:(CUISelectControlSize)size {
    if (size == self.size) {
        return;
    }

    _size = size;
    [self reloadPicker];
    [self invalidateIntrinsicContentSize];
}

#pragma mark - UIControl

- (void)togglePickerVisibility {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return;
    }

    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL isFirstResponder = [super becomeFirstResponder];
    if (!isFirstResponder) {
        return NO;
    }

    [self rotateChevron];
    [self updateStyleForState];
    [self prepareToShowSelectionView];

    [self reloadInputViews];

    return YES;
}

- (BOOL)resignFirstResponder {
    // first resign first responder before we inform our delegate about
    // any selection, has the selection only occures once the first responder
    // has resigned (as in: the highlighted row before resigning is selected).
    BOOL superResignFirstResponder = [super resignFirstResponder];
    [self rotateChevron];
    [self prepareToHideSelectionView];

    return superResignFirstResponder;
}

#pragma mark - Actions

- (UIView *)createSelectionAccessoryView {
    CUILabelBody1 *titleLabel = [[CUILabelBody1 alloc] initWithText:self.title];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    self.inputAccessoryViewTitleLabel = titleLabel;

    SDSTextStyleConfiguration *style = CUIButtonDefaultStyleCreateTextStyle(CUIButtonVariantTertiary, NO);

    // this isn't a tertiary button but allows us to avoid adding localization to CircuitUI
    // for the time being, as the done bar button item already is localized. we should probably
    // remove this and use a tertiary button sooner than later but for now this should suffice.
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(doneButtonPressed:)];
    doneItem.tintColor = [style.textColor valueForState:UIControlStateNormal];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, UIApplication.sharedApplication.keyWindow.bounds.size.width, 50)];
    toolbar.translucent = NO;
    toolbar.backgroundColor = CUISemanticColor.backgroundColor;
    [toolbar setItems:@[titleItem, spaceItem, doneItem]];
    [toolbar sizeToFit];

    return toolbar;
}

- (void)doneButtonPressed:(id)sender {
    [self resignFirstResponder];
}

- (void)validateSelectedOption {
    CUISelectControlValidationResult *result = [self validationResult];
    if (!result) {
        [self.hostingView updateStyleForValidationResult:nil];
        return;
    }
    // we modify our validation result before we hand it over to the hosting container,
    // as the select picker component doesn't have a success state. so, we transform any success
    // state to a "normal" state. we do this to keep the call site cleaner (as any accepted selection
    // is effectively a success).
    CUIInputControlContainerValidationResult *resultConverted = result.success ? nil : [[CUIInputControlContainerValidationResult alloc] initWithSelectValidationResult:result];

    [self.hostingView updateStyleForValidationResult:resultConverted];
}

- (void)rotateChevron {
    // rotate the chevron by 180 degrees for indicating that the control is in its expanded/collapsed state
    self.chevronView.transform = self.isFirstResponder ? CGAffineTransformRotate(CGAffineTransformIdentity, M_PI) : CGAffineTransformIdentity;
}

#pragma mark - Utilities

- (UIEdgeInsets)layoutMarginInsetsForPickerSize {
    switch (self.size) {
        case CUISelectControlSizeKilo:
            return UIEdgeInsetsMake(CUISpacingBit, CUISpacingKilo, CUISpacingBit, CUISpacingKilo);
        case CUISelectControlSizeGiga:
            return UIEdgeInsetsMake(CUISpacingKilo, CUISpacingMega, CUISpacingKilo, CUISpacingMega);
    }
}

- (CUISpacing)spacingForPickerSize {
    switch (self.size) {
        case CUISelectControlSizeKilo:
            return CUISpacingByte;
        case CUISelectControlSizeGiga:
            return CUISpacingKilo;
    }
}

@end
