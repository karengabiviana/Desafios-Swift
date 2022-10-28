//
//  CUISingleLineTextField.h
//  CircuitUI
//
//  Created by Marcel Voß on 31.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUITextField.h"

NS_ASSUME_NONNULL_BEGIN

@class CUISingleLineTextFieldAccessoryConfiguration;

typedef NS_CLOSED_ENUM(NSInteger, CUITextFieldClearButtonMode) {
    CUITextFieldClearButtonModeNever,
    CUITextFieldClearButtonModeAlways,
    CUITextFieldClearButtonModeWhileEditing
} NS_SWIFT_NAME(TextFieldClearButtonMode);

/// The implementation of CircuitUI for text fields supporting single-line text input
NS_SWIFT_NAME(SingleLineTextField)
@interface CUISingleLineTextField: CUITextField <UITextInputTraits>

@property (nonatomic) CUISingleLineTextFieldAccessoryConfiguration *accessoryConfiguration;

@property (nonatomic) CUITextFieldClearButtonMode clearButtonMode;

@end

NS_ASSUME_NONNULL_END
