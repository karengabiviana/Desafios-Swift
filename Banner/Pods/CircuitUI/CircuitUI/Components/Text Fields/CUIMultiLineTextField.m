//
//  CUIMultiLineTextField.m
//  CircuitUI
//
//  Created by Marcel Voß on 20.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIMultiLineTextField.h"

#import "CUIColorHelpers.h"
#import "CUIColorRef.h"
#import "CUILabel+Private.h"
#import "CUILabelBody1.h"
#import "CUISemanticColor.h"
#import "CUISpacing.h"
#import "CUITextField+Private.h"
#import "CUITextFieldValidationResult.h"
#import "CUITextStyle.h"

@import SumUpUtilities;

@interface CUIMultiLineTextField () <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, readonly, weak) UITextView *textView;
@property (nonatomic, readonly, weak) CUILabelBody1 *placeholderLabel;

@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation CUIMultiLineTextField

#pragma mark - Configuration

- (void)cui_commonInit {
    _minimumNumberOfLines = 3;

    [super cui_commonInit];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(becomeFirstResponder)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];

    [self configurePlaceholderLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayoutForContentSize:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (UIView *)createTextInputContentView {
    UITextView *textView = [UITextView new];
    textView.backgroundColor = CUISemanticColor.backgroundColor;
    textView.delegate = self;
    textView.textContainer.lineFragmentPadding = 0;
    textView.tintColor = CUISemanticColor.tintColor;
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.textAlignment = (self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) ? NSTextAlignmentLeft : NSTextAlignmentRight;

    _textView = textView;

    [self updateFontForCurrentTextStyle];
    [self configureHeightConstraint];

    return textView;
}

- (void)configurePlaceholderLabel {
    CGRect currentCaretFrame;
    UITextRange *textRange = self.textView.selectedTextRange;
    if (textRange) {
        currentCaretFrame = [self.textView caretRectForPosition:textRange.start];
    } else {
        currentCaretFrame = CGRectZero;
    }

    CUILabelBody1 *placeholderLabel = [CUILabelBody1 new];
    placeholderLabel.variant = CUILabelBodyVariantSubtle;
    placeholderLabel.userInteractionEnabled = NO;

    [self smp_addSubview:placeholderLabel withConstraints:@[
        [placeholderLabel.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor constant:CGRectGetMinX(currentCaretFrame)],
        [placeholderLabel.topAnchor constraintEqualToAnchor:self.textView.topAnchor constant:self.textView.textContainerInset.top],
        [self.textView.trailingAnchor constraintEqualToAnchor:placeholderLabel.trailingAnchor constant:self.textView.textContainerInset.right]
    ]];

    _placeholderLabel = placeholderLabel;
}

- (void)updatePlaceholderVisibility {
    self.placeholderLabel.hidden = self.text.length > 0;
}

- (void)updateFontForCurrentTextStyle {
    SDSTextStyleConfiguration *style = CUITextStyleCreateBody1(CUILabelBodyVariantDefault, NO);

    [self.textView setFont:style.scaledFont];
    [self.textView setTextColor:[style.textColor valueForState:self.state]];
}

- (void)textViewEditingBegan:(UITextView *)textView {
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    [self textViewEditingAllEvents:textView];
}

- (void)textViewEditingChanged:(UITextView *)textView {
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    [self textViewEditingAllEvents:textView];
}

- (void)textViewEditingEnded:(UITextView *)textView {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    [self textViewEditingAllEvents:textView];
}

- (void)textViewEditingAllEvents:(UITextView *)textView {
    [self sendActionsForControlEvents:UIControlEventAllEditingEvents];
}

- (void)setMinimumNumberOfLines:(NSInteger)minimumLineLimit {
    if (_minimumNumberOfLines == minimumLineLimit) {
        return;
    }
    _minimumNumberOfLines = minimumLineLimit;
    
    [self configureHeightConstraint];
}

- (void)setAdjustHeightToFitContent:(BOOL)adjustHeightForContent {
    if (_adjustHeightToFitContent == adjustHeightForContent) {
        return;
    }
    _adjustHeightToFitContent = adjustHeightForContent;

    [self.textView setScrollEnabled:!adjustHeightForContent];
    [self configureHeightConstraint];
}

- (void)configureHeightConstraint {
    [self.textViewHeightConstraint setActive:NO];

    CGFloat contentHeightForMinimumNumberOfLines = self.textView.font.lineHeight * self.minimumNumberOfLines;

    if (self.adjustsHeightToFitContent) {
        self.textViewHeightConstraint = [self.textView.heightAnchor constraintGreaterThanOrEqualToConstant:contentHeightForMinimumNumberOfLines];
    } else {
        self.textViewHeightConstraint = [self.textView.heightAnchor constraintEqualToConstant:contentHeightForMinimumNumberOfLines];
    }

    [self.textViewHeightConstraint setActive:YES];
}

- (void)updateLayoutForContentSize:(NSNotification *)notification {
    [self updateFontForCurrentTextStyle];
    [self configureHeightConstraint];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return CGRectContainsPoint(self.textView.frame, [gestureRecognizer locationInView:self]);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self updatePlaceholderVisibility];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    if (self.hasPreviousValidation) {
        [self resetValidationResult];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self updateStyleForState:CUITextFieldStateActive];
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self updateStyleForState:CUITextFieldStateNormal];
    [self updateStyleForValidationResult];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if (self.maximumNumberOfCharacters == 0) {
        // a maximum number of characters that equals to zero means "as many characters as necessary"
        // and therefore, we don't have to perform any validation on the number of characters.
        return YES;
    }

    if (range.length + range.location > textView.text.length) {
        return NO;
    }

    NSUInteger newLength = textView.text.length + string.length - range.length;
    return newLength <= self.maximumNumberOfCharacters;
}

#pragma mark - UIResponder
- (BOOL)becomeFirstResponder {
    // we're only calling this to fulfill the API contract that requires
    // us to call the super implementation.
    [super becomeFirstResponder];
    return [self.textView becomeFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return self.textView.canResignFirstResponder;
}

- (BOOL)resignFirstResponder {
    // we're only calling the super class' implementation to conform to the API contract
    // but we're actually only interested in forwarding it to the backing text view.
    [super resignFirstResponder];
    return [self.textView resignFirstResponder];
}

#pragma mark - Forwarding

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    [self.textView setText:text];
    [self updateStyleForValidationResult];
    [self updatePlaceholderVisibility];
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
}

- (BOOL)isEditing {
    return self.textView.isFirstResponder;
}

- (BOOL)isEnabled {
    return YES;
}

- (UIDataDetectorTypes)dataDetectorTypes {
    return self.textView.dataDetectorTypes;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setDataDetectorTypes:dataDetectorTypes];
}

- (nullable UIView *)keyboardAccessoryView {
    return self.textView.inputAccessoryView;
}

- (void)setKeyboardAccessoryView:(UIView *)keyboardAccessoryView {
    [self.textView setInputAccessoryView:keyboardAccessoryView];
}

#pragma mark - UITextInputTraits Conformance

- (BOOL)isSecureTextEntry {
    return self.textView.isSecureTextEntry;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setSecureTextEntry:secureTextEntry];
}

- (UIKeyboardType)keyboardType {
    return self.textView.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setKeyboardType:keyboardType];
}

- (UIKeyboardAppearance)keyboardAppearance {
    return self.textView.keyboardAppearance;
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setKeyboardAppearance:keyboardAppearance];
}

- (UIReturnKeyType)returnKeyType {
    return self.textView.returnKeyType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setReturnKeyType:returnKeyType];
}

- (UITextContentType)textContentType {
    return self.textView.textContentType;
}

- (void)setTextContentType:(UITextContentType)textContentType {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setTextContentType:textContentType];
}

- (BOOL)enablesReturnKeyAutomatically {
    return self.textView.enablesReturnKeyAutomatically;
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setEnablesReturnKeyAutomatically:enablesReturnKeyAutomatically];
}

- (UITextAutocapitalizationType)autocapitalizationType {
    return self.textView.autocapitalizationType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setAutocapitalizationType:autocapitalizationType];
}

- (UITextAutocorrectionType)autocorrectionType {
    return self.textView.autocorrectionType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setAutocorrectionType:autocorrectionType];
}

- (UITextSpellCheckingType)spellCheckingType {
    return self.textView.spellCheckingType;
}

- (void)setSpellCheckingType:(UITextSpellCheckingType)spellCheckingType {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setSpellCheckingType:spellCheckingType];
}

- (UITextSmartQuotesType)smartQuotesType API_AVAILABLE(ios(11.0)){
    return self.textView.smartQuotesType;
}

- (void)setSmartQuotesType:(UITextSmartQuotesType)smartQuotesType API_AVAILABLE(ios(11.0)) {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setSmartQuotesType:smartQuotesType];
}

- (UITextSmartDashesType)smartDashesType API_AVAILABLE(ios(11.0)){
    return self.textView.smartDashesType;
}

- (void)setSmartDashesType:(UITextSmartDashesType)smartDashesType API_AVAILABLE(ios(11.0)) {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setSmartDashesType:smartDashesType];
}

- (UITextSmartInsertDeleteType)smartInsertDeleteType API_AVAILABLE(ios(11.0)) {
    return self.textView.smartInsertDeleteType;
}

- (void)setSmartInsertDeleteType:(UITextSmartInsertDeleteType)smartInsertDeleteType API_AVAILABLE(ios(11.0)) {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setSmartInsertDeleteType:smartInsertDeleteType];
}

- (UITextInputPasswordRules *)passwordRules API_AVAILABLE(ios(12.0)) {
    return self.textView.passwordRules;
}

- (void)setPasswordRules:(UITextInputPasswordRules *)passwordRules API_AVAILABLE(ios(12.0)) {
    NSAssert(self.textView, @"text view must not be nil.");
    [self.textView setPasswordRules:passwordRules];
}

@end
