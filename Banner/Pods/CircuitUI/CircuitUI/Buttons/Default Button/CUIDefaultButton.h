//
//  CUIDefaultButton.h
//  CircuitUI
//
//  Created by Florian Schliep on 02.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButton.h"
#import "CUIButtonVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Implements the default appearance of CircuitUI buttons and serves as base class for Giga and Kilo buttons.
 * While you can use this class directly, it is recommended to use one of its Giga or Kilo subclasses instead, as they give you greater convenience.
 * A typical use-case for this class would be to e.g. display a different button depending on some kind of context which is not known at compile time.
 *
 * @warning If you use this class directly, you must also use its designated initializer. The CUIButton convenience initializers will not allow you to control the `variant` and `size` properties.
 */
NS_SWIFT_NAME(DefaultButton)
@interface CUIDefaultButton : CUIButton

@property (nonatomic) CUIButtonVariant variant;
@property (nonatomic) CUIButtonSize size;
@property (nonatomic, readonly) BOOL isActivityIndicatorVisible;

- (instancetype)initWithVariant:(CUIButtonVariant)variant size:(CUIButtonSize)size NS_DESIGNATED_INITIALIZER;

/**
 * Will display the button's loading state.
 * The label and image will be hidden, a loading indicator will be displayed.
 */
- (void)startActivityIndicatorAnimation;

/**
 * Will hide the button's loading state.
 */
- (void)stopActivityIndicatorAnimation;

@end

NS_ASSUME_NONNULL_END
