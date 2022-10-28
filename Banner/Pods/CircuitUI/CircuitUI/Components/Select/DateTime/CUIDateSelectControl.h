//
//  CUIDateSelectControl.h
//  CircuitUI
//
//  Created by Roman Utrata on 19.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

@import UIKit;

#import "CUIBaseSelectControl.h"

@class CUIDateSelectControlConfiguration;

NS_ASSUME_NONNULL_BEGIN

/// The select date component allows users to choose a date in a limited space.
NS_SWIFT_NAME(DateSelectControl)
@interface CUIDateSelectControl: CUIBaseSelectControl

/// A configuration for CUIDateSelectControl.
@property (nonatomic, readonly) CUIDateSelectControlConfiguration *configuration;

/// A date that will be selected as selected when date picker will be opened. If no date has been selected yet, this equals nil.
@property (nullable, nonatomic, copy) NSDate *selectedDate;

/// A block that provides validation for any input made. If no result is returned within the block, the
/// regular state is assumed ("no validation").
///
/// Do not make any assumptions when or how often this block is executed. Do not perform any potentially expensive side effects
@property (nullable, nonatomic, copy) CUISelectControlValidationResult * _Nullable (^inputValidation)(NSDate*);

- (instancetype)initWithConfiguration:(CUIDateSelectControlConfiguration *)configuration NS_SWIFT_NAME(init(configuration:));

@end

NS_ASSUME_NONNULL_END
