//
//  CUIPercentageTextField.h
//  CircuitUI
//
//  Created by Andrii Kravchenko on 27.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUISingleLineTextField.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(PercentageTextField)
@interface CUIPercentageTextField : CUISingleLineTextField

/// Contains the decimal value that is currently displayed within the text field.
@property (nonatomic) NSDecimalNumber *value;
@property (nonatomic) NSUInteger maximumFractionDigits;
@property (nonatomic) NSLocale *percentageLocale;

@end

NS_ASSUME_NONNULL_END
