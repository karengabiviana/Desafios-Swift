//
//  CUIMultiLineTextField.h
//  CircuitUI
//
//  Created by Marcel Voß on 20.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;

#import "CUITextField.h"

NS_ASSUME_NONNULL_BEGIN

/// The implementation of CircuitUI for text fields supporting multi-line text input.
NS_SWIFT_NAME(MultiLineTextField)
@interface CUIMultiLineTextField: CUITextField <UITextInputTraits>

/// Defines the minimum number of lines for the text field.
///
/// Depending on whether the text field should adjust its height for its content, this defines the minimum number of lines visible before it starts to scroll.
@property (nonatomic) NSInteger minimumNumberOfLines;

/// Defines whether the text field adjusts its height for its text or not. If this is `NO` (the default), then the text input area scrolls should the text exceed its bounds.
@property (nonatomic, getter=adjustsHeightToFitContent) BOOL adjustHeightToFitContent;

/// The types of data that convert to tappable URLs in the text view.
///
/// You can use this property to specify the types of data (phone numbers, http links, and so on) that should be automatically converted to URLs in the text field. When tapped, the text field opens the application responsible for handling the URL type and passes it the URL.
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes;

@end

NS_ASSUME_NONNULL_END
