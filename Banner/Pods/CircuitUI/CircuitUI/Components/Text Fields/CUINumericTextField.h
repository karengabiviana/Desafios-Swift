//
//  CUINumericTextField.h
//  CircuitUI
//
//  Created by Illia Lukisha on 05/08/2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUISingleLineTextField.h"

NS_ASSUME_NONNULL_BEGIN

/// A text field that displays and formats numeric values.
NS_SWIFT_NAME(NumericTextField)
@interface CUINumericTextField: CUISingleLineTextField

/// Contains the decimal value that is currently displayed within the text field.
@property (nonatomic) NSDecimalNumber *value;

/// The maximum decimal value the text field can contain. Any attempt of entering a larger value than this will be rejected.
@property (nonatomic) NSDecimalNumber *maximumValue;

/// The minimum decimal value the text field can contain.
/// Any attempt of entering a lower value than this will be
/// rejected. Set to `0` by default. If negative, adds "+/-"
/// button to the toolbar.
@property (nonatomic) NSDecimalNumber *minimumValue;

/// Maximum fraction digits number can contain, default is 0.
@property (nonatomic) NSUInteger maximumFractionDigits;

/// If YES, the value zero will be rendered with the same color as the placeholder.
@property (nonatomic) BOOL treatZeroAsPlaceholder;

#pragma mark - Unavailable
@property (nonatomic) NSString *text UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) NSString *placeholder UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) NSUInteger maximumNumberOfCharacters UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END

