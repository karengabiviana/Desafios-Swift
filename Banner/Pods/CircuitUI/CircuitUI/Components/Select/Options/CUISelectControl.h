//
//  CUISelectControl.h
//  CircuitUI
//
//  Created by Marcel Voß on 06.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

@class CUISelectControlValidationResult;

#import "CUIBaseSelectControl.h"

NS_ASSUME_NONNULL_BEGIN

/// The select component allows users to choose from a list of options in a limited space.
NS_SWIFT_NAME(SelectControl)
@interface CUISelectControl: CUIBaseSelectControl

/// An array of all options available for selection in the picker.
///
/// The number of available options should be between four to eight. All values are copied and the order is never changed.
///
/// Consider a logical order of the available options (e.g. frequency of use, alphabetical order, numeric order).
@property (nonatomic, copy) NSArray<NSString *> *options;

/// The index of the currently selected option.
///
/// In order to react on any selections, add a target action for UIControlEventValueChanged. If no option has been selected yet, this equals NSNotFound.
/// @Note The index must be within the range of the options property. The index is equivalent to the array that has been assigned to the options property.
@property (nonatomic) NSInteger selectedOptionIndex;

/// A block that provides validation for any input made. If no result is returned within the block, the
/// regular state is assumed ("no validation").
///
/// Do not make any assumptions when or how often this block is executed. Do not perform any potentially expensive side effects
@property (nonatomic, copy, nullable) CUISelectControlValidationResult * _Nullable (^inputValidation)(NSInteger);

/// Initializes a new picker component with a list of contained options.
/// @param options An array of all options contained within the picker.
- (instancetype)initWithOptions:(NSArray<NSString *> *)options;

@end

NS_ASSUME_NONNULL_END
