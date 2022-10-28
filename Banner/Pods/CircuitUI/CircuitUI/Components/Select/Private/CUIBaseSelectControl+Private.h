//
//  CUIBaseSelectControl+Private.h
//  CircuitUI
//
//  Created by Roman Utrata on 20.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import <CircuitUI/CUIBaseSelectControl.h>

@class CUISelectControlValidationResult;

NS_ASSUME_NONNULL_BEGIN

@interface CUIBaseSelectControl (Private)

- (void)updateStyleForState;
- (void)validateSelectedOption;

///
/// ******** Method below should be used in subclasses ********
/// When you plan to change picker to any custom view you can override methods below to provide your own view with full functionality and minimal changes.
///

/// Returns validation result for selected option. If it is nil that control doesn't run validation process.
- (CUISelectControlValidationResult * _Nullable)validationResult;

/// Returns a view that should be show when user press on select control
- (UIView *)createSelectionView;

/// Return the text that should be shown in select control. If it is nil - placeholder is shown
- (NSString * _Nullable)selectedOptionText;

/// Do any preparation before show selection view
- (void)prepareToShowSelectionView;

/// Do any clean up or updates when selection view is hidden
- (void)prepareToHideSelectionView;

@end

NS_ASSUME_NONNULL_END
