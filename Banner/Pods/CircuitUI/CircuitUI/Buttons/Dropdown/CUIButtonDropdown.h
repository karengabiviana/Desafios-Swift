//
//  CUIButtonDropdown.h
//  CircuitUI
//
//  Created by Ivan Vasilev on 19.10.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIDefaultButton.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A button with a chevron icon on the trailing side. Typically used to present an options menu.
 */
NS_SWIFT_NAME(ButtonDropdown)
@interface CUIButtonDropdown : CUIDefaultButton

- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state NS_UNAVAILABLE;
- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
