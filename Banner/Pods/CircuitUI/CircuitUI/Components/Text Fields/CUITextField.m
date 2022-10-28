//
//  CUITextField.m
//  CircuitUI
//
//  Created by Marcel Voß on 31.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUITextField.h"

#import "CUIColorHelpers.h"
#import "CUIColorRef.h"
#import "CUISpacing.h"
#import "CUITextField+Private.h"
#import "CUITextFieldValidationResult.h"
#import "NSLayoutAnchor+CUISpacing.h"
#import "CUIInputControlContainerValidationResult.h"

#import "CUIInputControlContainerView.h"

#import "CUISemanticColor.h"

@import SumUpUtilities;

@interface CUITextField ()

@property (nonatomic, weak) NSLayoutConstraint *bottomConstraint;

@property (nonatomic, weak) CUIInputControlContainerView *hostingView;
@property (nonatomic, weak) UIView *contentContainerView;

@property (nonatomic, readwrite) BOOL hasPreviousValidation;

@end

@implementation CUITextField

#pragma mark - Initializers

- (instancetype)initWithTitle:(NSString *)title subtitle:(nullable NSString *)subtitle {
    NSParameterAssert(title);

    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = [title copy];
        _subtitle = [subtitle copy];

        [self cui_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

#pragma mark - Configuration

- (void)cui_commonInit {
    NSAssert([self class] != [CUITextField class], @"CUITextField may not be used directly. Please use one of its subclasses.");

    [self configureContentView];

    self.backgroundColor = CUISemanticColor.backgroundColor;
}

- (void)configureContentView {
    CUIInputControlContainerView *hostingView = [[CUIInputControlContainerView alloc] initWithHostedView:[self createTextInputContentView] title:self.title subtitle:self.subtitle];
    hostingView.hostedViewMarginInsets = UIEdgeInsetsMake(CUISpacingKilo, CUISpacingMega, CUISpacingKilo, CUISpacingMega);
    [self smp_addSubview:hostingView withConstraints:@[
        [hostingView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [hostingView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [hostingView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [hostingView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];

    self.hostingView = hostingView;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.hostingView.title = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    self.hostingView.subtitle = subtitle;
}

#pragma mark - State Updating

- (NSString *)text {
    NSAssert(NO, @"Subclasses must override text");
    return @"";
}

- (void)setText:(NSString *)text {
    NSAssert(NO, @"Subclasses must override setText:");
}

- (NSString *)placeholder {
    NSAssert(NO, @"Subclasses must override placeholder");
    return nil;
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSAssert(NO, @"Subclasses must override setPlaceholder:");
}

- (void)setEnabled:(BOOL)enabled {
    [self.hostingView updateStyleForState:enabled ? CUIInputControlContainerViewStateNormal : CUIInputControlContainerViewStateDisabled];
}

- (BOOL)isEnabled {
    NSAssert(NO, @"Subclasses must override isEnabled");
    return NO;
}

- (BOOL)isEditing {
    NSAssert(NO, @"Subclasses must override isEditing");
    return NO;
}

- (BOOL)isInputValid {
    if (self.inputValidation) {
        return self.inputValidation(self.text).success;
    }

    return YES;
}

- (void)resetValidationResult {
    [self.hostingView updateStyleForValidationResult:nil];
    if (self.isEditing) {
        [self updateStyleForState:CUITextFieldStateActive];
    }
    [self.delegate textFieldDidUpdateValidationStatus:self];
    self.hasPreviousValidation = NO;
} 

- (BOOL)validateInput {
    [self updateStyleForValidationResult];
    return [self isInputValid];
}

- (void)updateStyleForValidationResult {
    if (!self.inputValidation) {
        return;
    }

    CUITextFieldValidationResult *result = self.inputValidation(self.text);
    CUIInputControlContainerValidationResult *containerResult = [[CUIInputControlContainerValidationResult alloc] initWithTextFieldValidationResult:result];
    [self.hostingView updateStyleForValidationResult:containerResult];
    
    self.hasPreviousValidation = result != nil;

    [self.delegate textFieldDidUpdateValidationStatus:self];
}

- (UIControlState)state {
    if (!self.isEnabled) {
        return UIControlStateDisabled;
    }

    if (self.isFirstResponder) {
        return UIControlStateSelected;
    }

    return self.highlighted ? UIControlStateHighlighted : UIControlStateNormal;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingState {
    return [NSSet setWithObjects:@"isEnabled", @"isHighlighted", @"isFirstResponder", nil];
}

#pragma mark - Private

- (UIView *)createTextInputContentView {
    NSAssert(NO, @"Subclasses must override createTextInputContentView");
    return nil;
}

- (void)updateStyleForState:(CUITextFieldState)textFieldState {
    CUIInputControlContainerViewState state;

    switch (textFieldState) {
        case CUITextFieldStateActive:
            state = CUIInputControlContainerViewStateActive;
            break;
        case CUITextFieldStateNormal:
            state = CUIInputControlContainerViewStateNormal;
            break;
        case CUITextFieldStateFailure:
            state = CUIInputControlContainerViewStateFailure;
            break;
    }

    [self.hostingView updateStyleForState:state];
}

@end
