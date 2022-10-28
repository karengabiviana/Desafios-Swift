//
//  CUITextField.h
//  CircuitUI
//
//  Created by Marcel Voß on 31.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

@class CUITextField;
@class CUITextFieldValidationResult;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(TextFieldDelegate)
@protocol CUITextFieldDelegate <NSObject>
- (void)textFieldDidUpdateValidationStatus:(CUITextField *)textField;
@end

/// Base class for text fields of CircuitUI. This class is not meant to be used directly, please only use its subclasses directly.
/// There are subclasses for different requirements such as CUISingleLineTextField.
NS_SWIFT_NAME(TextField)
@interface CUITextField: UIControl

/// The text that the text field displays.
@property (nonatomic) NSString *text;

/// A text that is displayed above the text field indicating its purpose.
@property (nonatomic, copy) NSString *title;

/// An optional text is displayed below the text field, providing guidance on what input is being expected within the text field.
/// @Note This text should be short and as concise as possible in its text length, it will not be truncated and will span over multiple lines if needed.
@property (nonatomic, copy, nullable) NSString *subtitle;

/// The string that displays when there is no other text in the text field.
@property (nonatomic, nullable) NSString *placeholder;

/// The default value of this property is nil. Assigning a view to this property causes that view to be displayed above the standard system keyboard when the text field becomes the first responder.
/// For example, you could use this property to attach a custom toolbar to the keyboard.
/// Note: This is the equivalent of setting `inputAccessoryView` on a UIResponder.
@property (nonatomic, nullable) UIView *keyboardAccessoryView;

/// A Boolean value that indicates whether the text field is currently in edit mode.
@property (nonatomic, readonly) BOOL isEditing;

/// Defines the maximum number of characters allowed in the text field.
/// The default value for this property is 0. To remove any maximum limit, and use as many characters as needed, set the value of this property to 0.
@property (nonatomic) NSUInteger maximumNumberOfCharacters;

/// Determines whether the currently entered input is valid, depending on the return value of the inputValidation block.
///
/// If there hasn't been inputValidation block provided, this is always going to return YES.
@property (nonatomic, readonly) BOOL isInputValid;

/// The object that acts as the delegate of the text field.
@property (nonatomic, weak) id<CUITextFieldDelegate> delegate;

/// A block that provides validation for any input made. If no result is returned within the block, the
/// regular state is assumed ("no validation").
///
/// Do not make any assumptions when or how often this block is executed. Do not perform any potentially expensive side effects.
@property (nonatomic, copy, nullable) CUITextFieldValidationResult * _Nullable (^inputValidation)(NSString *);

- (instancetype)initWithTitle:(NSString *)title subtitle:(nullable NSString *)subtitle;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame primaryAction:(nullable UIAction *)primaryAction NS_UNAVAILABLE;

/// Run validation and return validation result represented as a Boolean value
- (BOOL)validateInput;

@end

NS_ASSUME_NONNULL_END
