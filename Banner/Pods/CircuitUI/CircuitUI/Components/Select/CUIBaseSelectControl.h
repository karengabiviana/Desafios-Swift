//
//  CUIBaseSelectControl.h
//  CircuitUI
//
//  Created by Roman Utrata on 19.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

@import UIKit;

@class CUISelectControlValidationResult;

#import "CUISelectControlSize.h"

NS_ASSUME_NONNULL_BEGIN

/// Base class for select control of CircuitUI. This class is not meant to be used directly, please only use its subclasses directly.
/// There are subclasses for different requirements such as CUISelectControl or CUIDateSelectControl
NS_SWIFT_NAME(BaseSelectControl)
@interface CUIBaseSelectControl: UIControl

/// Defines the size for the select control.
///
/// You can also optionally use one of the available subclasses if that fits your needs better. Both ways of using are equivalent.
@property (nonatomic) CUISelectControlSize size;

/// A text that is displayed above the picker indicating its purpose.
@property (nonatomic, nullable, copy) NSString *title;

/// An optional text is displayed below the picker, providing guidance on what kind of input is being expected within the picker
///
/// This text should be short and as concise as possible in its text length, it will not be truncated and will span over multiple lines if needed.
@property (nonatomic, nullable, copy) NSString *subtitle;

/// A text that is displayed when there was no selection made yet.
@property (nonatomic, nullable, copy) NSString *placeholder;

/// Defines whether the component will send continous updates on the selected option or whether it
/// will only do so once the picker disappears (i.e. the selection is confirmed). The default is YES.
///
/// In order to react on any selections, add a target action for UIControlEventValueChanged.
@property (nonatomic, getter=continouslyUpdatesSelection) BOOL continousSelectionUpdates;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
