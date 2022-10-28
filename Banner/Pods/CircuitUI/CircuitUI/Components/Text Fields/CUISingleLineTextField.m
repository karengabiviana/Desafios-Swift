//
//  CUISingleLineTextField.m
//  CircuitUI
//
//  Created by Marcel Voß on 31.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISingleLineTextField.h"
#import "CUISingleLineTextFieldAccessoryConfiguration.h"

#import "CUITextField+Private.h"
#import "CUITextFieldValidationResult.h"
#import "CUILabelBody1.h"
#import "CUIColorHelpers.h"
#import "CUISpacing.h"
#import "CUIColorRef.h"
#import "CUISemanticColor.h"
#import "CUILabel+Private.h"
#import "CUITextStyle.h"

#import "CUISingleLineTextField+Private.h"
#import "UIImage+CUILibrary.h"

@import SumUpUtilities;

@interface CUISingleLineTextField () <UIGestureRecognizerDelegate>

@property (nonatomic, nonnull) UITextField *textField;
@property (nonatomic, nonnull) UIStackView *containerStackView;
@property (nonatomic, nonnull) CUISingleLineTextFieldAccessoryConfiguration *accessoryConfigurationClearButton;
@property (nonatomic, nonnull) CUISingleLineTextFieldAccessoryConfiguration *accessoryConfigurationCopy;

@end

@implementation CUISingleLineTextField

- (void)cui_commonInit {
    [super cui_commonInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFontForCurrentTextStyle)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(becomeFirstResponder)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return CGRectContainsPoint(self.textField.frame, [gestureRecognizer locationInView:self]);
}

#pragma mark - Configuration

- (UIView *)createTextInputContentView {
    UIStackView *containerStackView = [[UIStackView alloc] init];
    containerStackView.axis = UILayoutConstraintAxisHorizontal;
    containerStackView.spacing = CUISpacingKilo;
    containerStackView.distribution = UIStackViewDistributionFill;

    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.tintColor = CUISemanticColor.tintColor;

    self.textField = textField;
    self.containerStackView = containerStackView;

    [self updateFontForCurrentTextStyle];

    // forward UIControlEvents from the underlying UITextField
    [textField addTarget:self action:@selector(textFieldEditingBegan:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(textFieldEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
    [textField addTarget:self action:@selector(textFieldEditingEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [containerStackView addArrangedSubview:textField];

    return containerStackView;
}

- (void)textFieldEditingBegan:(UITextField *)textField {
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    [self updateClearButtonAccessoryConfiguration];
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    [self updateClearButtonAccessoryConfiguration];
    if (self.hasPreviousValidation) {
        [self resetValidationResult];
    }
}

- (void)textFieldEditingEnded:(UITextField *)textField {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    [self updateClearButtonAccessoryConfiguration];
}

- (void)textFieldEditingEndOnExit:(UITextField *)textField {
    [self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)updateClearButtonAccessoryConfiguration {
    CUISingleLineTextFieldAccessoryConfiguration *configuration;
    switch (self.clearButtonMode) {
        case CUITextFieldClearButtonModeAlways:
            if (self.text.length > 0) {
                configuration = self.accessoryConfigurationClearButton;
            } else {
                configuration = self.accessoryConfigurationCopy;
            }
            break;
        case CUITextFieldClearButtonModeWhileEditing:
            if (self.text.length > 0 && self.textField.isFirstResponder) {
                configuration = self.accessoryConfigurationClearButton;
            } else {
                configuration = self.accessoryConfigurationCopy;
            }
            break;
        case CUITextFieldClearButtonModeNever:
            configuration = self.accessoryConfigurationCopy;
            break;
    }
    self.accessoryConfiguration = configuration;
}

- (void)updateFontForCurrentTextStyle {
    SDSTextStyleConfiguration *style = [self textStyleForCurrentState];

    [self.textField setFont:style.scaledFont];
    [self.textField setTextColor:[style.textColor valueForState:[self state]]];
}

- (SDSTextStyleConfiguration *)textStyleForCurrentState {
    return CUITextStyleCreateBody1([self labelBodyVariantForCurrentState], NO);
}

- (CUILabelBodyVariant)labelBodyVariantForCurrentState {
    return self.isEnabled ? CUILabelBodyVariantDefault : CUILabelBodyVariantDisabled;
}

- (CUISingleLineTextFieldAccessoryConfiguration *)accessoryConfigurationClearButton {
    if (! _accessoryConfigurationClearButton) {
       UIImage *image = [[UIImage cui_close_24] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
       UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
       [button setImage:image forState:UIControlStateNormal];
       [button setTintColor:CUISemanticColor.bodyColor];
       [button addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];

       CUISingleLineTextFieldAccessoryConfiguration *configuration = [[CUISingleLineTextFieldAccessoryConfiguration alloc]
                                                                    initWithAccessoryView:button
                                                                    position:CUISingleLineTextFieldAccessoryPositionTrailing
                                                                    respectSemanticContentDirection:NO];
       _accessoryConfigurationClearButton = configuration;
    }

    return _accessoryConfigurationClearButton;
}

- (void)setAccessoryConfiguration:(CUISingleLineTextFieldAccessoryConfiguration *)accessoryConfiguration {
    if ([accessoryConfiguration isEqual:self.accessoryConfiguration]) {
        return;
    }

    [self.accessoryConfiguration.accessoryView removeFromSuperview];

    UIView *accessoryView = accessoryConfiguration.accessoryView;
    [accessoryView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [accessoryView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    // in some cases, we have to force a view to be on the left/right side (e.g. for currency symbols that should not
    // follow the language direction but actually have a defined location per locale that must not be equal to the
    // direction of the language). therefore, we enforce a semantic content attribute here.
    self.containerStackView.semanticContentAttribute = accessoryConfiguration.respectSemanticContentDirection ? UISemanticContentAttributeUnspecified : UISemanticContentAttributeForceLeftToRight;

    switch (accessoryConfiguration.position) {
        case CUISingleLineTextFieldAccessoryPositionLeading:
            [self.containerStackView insertArrangedSubview:accessoryView atIndex:0];

            break;
        case CUISingleLineTextFieldAccessoryPositionTrailing:
            [self.containerStackView addArrangedSubview:accessoryView];

            break;
    }

    _accessoryConfiguration = accessoryConfiguration;

    if (accessoryConfiguration != self.accessoryConfigurationClearButton) {
        _accessoryConfigurationCopy = accessoryConfiguration;
    }
}

- (CUISingleLineTextFieldAccessoryConfiguration *)accessoryConfigurationFrom:(NSString *)referenceString accessorySymbol:(NSString *)accessorySymbol {
    if (!referenceString.length) {
        NSAssert(NO, @"reference string has an invalid format.");
        return nil;
    }

    // we're determining what the correct location for the accessory symbol is, in the currently used
    // locale by asking the number formatter for a correctly formatted string and by then checking whether
    // the accessory symbol is the first or last characther within the string.
    BOOL isLeading = [referenceString rangeOfString:accessorySymbol].location == 0;

    CUISingleLineTextFieldAccessoryPosition position;

    if (isLeading) {
        position = CUISingleLineTextFieldAccessoryPositionLeading;
    } else {
        position = CUISingleLineTextFieldAccessoryPositionTrailing;
    }

    CUILabelBody1 *accessorySymbolLabel = [[CUILabelBody1 alloc] initWithText:accessorySymbol];
    accessorySymbolLabel.variant = [self labelBodyVariantForCurrentState];

    // we disable respectSemanticContentDirection on purpose, as the currency symbol position
    // can differ from the direction of a language.
    return [[CUISingleLineTextFieldAccessoryConfiguration alloc] initWithAccessoryView:accessorySymbolLabel position:position respectSemanticContentDirection:NO];
}

#pragma mark - UITextField Forwarding

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.textField.enabled = enabled;
    [self updateFontForCurrentTextStyle];
}

- (BOOL)isEnabled {
    return self.textField.enabled;
}

- (BOOL)isEditing {
    return self.textField.isEditing;
}

- (nullable NSString *)placeholder {
    return self.textField.placeholder;
}

- (void)setPlaceholder:(nullable NSString *)placeholder {
    NSAttributedString *attributedPlaceholder;

    if (placeholder) {
        attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                      attributes:@{NSForegroundColorAttributeName: CUIColorFromHex(CUIColorRefN50)}];
    } else {
        attributedPlaceholder = nil;
    }
    
    self.textField.attributedPlaceholder = attributedPlaceholder;
}

- (NSString *)text {
    return self.textField.text ?: @"";
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
    if (!self.isEditing) {
        [self updateStyleForValidationResult];
    }
}

- (void)clearTextField {
    [self setText:@""];
    // As text clear is some sort of text change by calling editingChanged event
    // we actually notify caller side.
    [self textFieldEditingChanged:self.textField];
    // Become first responder on text clear.
    // Useful when CUITextFieldClearButtonModeAlways and field is out of focus
    [self becomeFirstResponder];
}

- (nullable UIView *)keyboardAccessoryView {
    return self.textField.inputAccessoryView;
}

- (void)setKeyboardAccessoryView:(UIView *)keyboardAccessoryView {
    [self.textField setInputAccessoryView:keyboardAccessoryView];
}

#pragma mark - UIResponder

- (BOOL)canResignFirstResponder {
    return self.textField.canResignFirstResponder;
}

- (BOOL)becomeFirstResponder {
    // we're only calling this to fulfill the API contract that requires
    // us to call the super implementation.
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
}

- (BOOL)isFirstResponder {
    return self.textField.isFirstResponder;
}

- (BOOL)resignFirstResponder {
    // we're only calling the super class' implementation to conform to the API contract
    // but we're actually only interested in forwarding it to the backing text field.
    [super resignFirstResponder];

    [self updateStyleForState:CUITextFieldStateNormal];
    [self updateStyleForValidationResult];
    return [self.textField resignFirstResponder];;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self updateStyleForState:CUITextFieldStateActive];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateStyleForState:CUITextFieldStateNormal];
    [self updateStyleForValidationResult];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.maximumNumberOfCharacters == 0) {
        // a maximum number of characters that equals to zero means "as many characters as necessary"
        // and therefore, we don't have to perform any validation on the number of characters.
        return YES;
    }

    if (range.length + range.location > textField.text.length) {
        return NO;
    }

    NSUInteger newLength = textField.text.length + string.length - range.length;
    return newLength <= self.maximumNumberOfCharacters;
}

#pragma mark - UITextInputTraits Conformance

- (BOOL)isSecureTextEntry {
    return self.textField.isSecureTextEntry;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    [self.textField setSecureTextEntry:secureTextEntry];
}

- (UIKeyboardType)keyboardType {
    return self.textField.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    [self.textField setKeyboardType:keyboardType];
}

- (UIKeyboardAppearance)keyboardAppearance {
    return self.textField.keyboardAppearance;
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
    [self.textField setKeyboardAppearance:keyboardAppearance];
}

- (UIReturnKeyType)returnKeyType {
    return self.textField.returnKeyType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    [self.textField setReturnKeyType:returnKeyType];
}

- (UITextContentType)textContentType {
    return self.textField.textContentType;
}

- (void)setTextContentType:(UITextContentType)textContentType {
    [self.textField setTextContentType:textContentType];
}

- (BOOL)enablesReturnKeyAutomatically {
    return self.textField.enablesReturnKeyAutomatically;
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically {
    [self.textField setEnablesReturnKeyAutomatically:enablesReturnKeyAutomatically];
}

- (UITextAutocapitalizationType)autocapitalizationType {
    return self.textField.autocapitalizationType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
    [self.textField setAutocapitalizationType:autocapitalizationType];
}

- (UITextAutocorrectionType)autocorrectionType {
    return self.textField.autocorrectionType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
    [self.textField setAutocorrectionType:autocorrectionType];
}

- (UITextSpellCheckingType)spellCheckingType {
    return self.textField.spellCheckingType;
}

- (void)setSpellCheckingType:(UITextSpellCheckingType)spellCheckingType {
    [self.textField setSpellCheckingType:spellCheckingType];
}

- (UITextSmartQuotesType)smartQuotesType API_AVAILABLE(ios(11.0)){
    return self.textField.smartQuotesType;
}

- (void)setSmartQuotesType:(UITextSmartQuotesType)smartQuotesType API_AVAILABLE(ios(11.0)){
    [self.textField setSmartQuotesType:smartQuotesType];
}

- (UITextSmartDashesType)smartDashesType API_AVAILABLE(ios(11.0)){
    return self.textField.smartDashesType;
}

- (void)setSmartDashesType:(UITextSmartDashesType)smartDashesType API_AVAILABLE(ios(11.0)){
    [self.textField setSmartDashesType:smartDashesType];
}

- (UITextSmartInsertDeleteType)smartInsertDeleteType API_AVAILABLE(ios(11.0)){
    return self.textField.smartInsertDeleteType;
}

- (void)setSmartInsertDeleteType:(UITextSmartInsertDeleteType)smartInsertDeleteType API_AVAILABLE(ios(11.0)){
    [self.textField setSmartInsertDeleteType:smartInsertDeleteType];
}

- (UITextInputPasswordRules *)passwordRules API_AVAILABLE(ios(12.0)){
    return self.textField.passwordRules;
}

- (void)setPasswordRules:(UITextInputPasswordRules *)passwordRules API_AVAILABLE(ios(12.0)){
    [self.textField setPasswordRules:passwordRules];
}

@end
