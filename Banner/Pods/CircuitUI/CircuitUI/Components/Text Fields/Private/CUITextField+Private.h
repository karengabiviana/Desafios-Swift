//
//  CUITextField+Private.h
//  CircuitUI
//
//  Created by Marcel Voß on 03.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUITextField.h"

typedef NS_ENUM(NSUInteger, CUITextFieldState) {
    CUITextFieldStateNormal,
    CUITextFieldStateActive,
    CUITextFieldStateFailure
} NS_SWIFT_NAME(TextFieldState);

NS_ASSUME_NONNULL_BEGIN

@interface CUITextField (Private)

/// A boolean property, which indicates if any kind of validation has already passed.
/// Also indicates if a validation check messages is presented.
@property (nonatomic, readonly) BOOL hasPreviousValidation;

/// Creates a new view that implements underlying text editing (e.g. a UITextField).
/// Subclasses must override this method and return and their own input content view.
/// This view is automatically added to the view hierarchy when appropriate.
- (UIView *)createTextInputContentView;

/// Use this method to perform any initialization work that is needed for the setup of the text field.
/// This is the preferred way over overriding initializers, because the base class ensures `cui_commonInit` is called for all cases.
- (void)cui_commonInit NS_REQUIRES_SUPER;

- (void)updateStyleForValidationResult NS_REQUIRES_SUPER;
- (void)updateStyleForState:(CUITextFieldState)textFieldState NS_REQUIRES_SUPER;

/// Use this method to hide all kind of validation check messages if presented.
- (void)resetValidationResult NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
