//
//  CUICurrencyTextField.h
//  CircuitUI
//
//  Created by Marcel Voß on 02.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISingleLineTextField.h"

NS_ASSUME_NONNULL_BEGIN

/// A text field that displays and formats monetary values.
NS_SWIFT_NAME(CurrencyTextField)
@interface CUICurrencyTextField: CUISingleLineTextField

/// Defines the locale that is used.
///
/// The language portion of the locale is used for formatting purposes and the country portion is used for the
/// currency code/symbol.
/// @Attention Do not set this repeatedly, as this might perform expensive operations under the hood.
@property (nonatomic) NSLocale *currencyLocale;

/// Contains the decimal value that is currently displayed within the text field.
@property (nonatomic) NSDecimalNumber *value;

/// The maximum decimal value the text field can contain. Any attempt of entering a larger value than this will be rejected.
@property (nonatomic) NSDecimalNumber *maximumValue;

/// If YES, the value zero will be rendered with the same color as the placeholder.
@property (nonatomic) BOOL treatZeroAsPlaceholder;

#pragma mark - Unavailable
@property (nonatomic) NSString *text UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) NSString *placeholder UNAVAILABLE_ATTRIBUTE;
@property (nonatomic) NSUInteger maximumNumberOfCharacters UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
