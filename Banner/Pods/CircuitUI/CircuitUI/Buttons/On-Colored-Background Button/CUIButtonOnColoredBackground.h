//
//  CUIButtonOnColoredBackground.h
//  CircuitUI
//
//  Created by Florian Schliep on 05.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButton.h"
#import "CUIButtonVariant.h"
#import "CUIButtonOnColoredBackgroundAppearance.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Implements the appearance of CircuitUI buttons to be used exclusively on colored background (e.g. green, yellow, red).
 * In any other cases, please use the `CUIDefaultButton` class and its subclasses (Giga + Kilo buttons), as defined by the CircuitUI design guidelines.
 *
 * While you can use this class directly, it is recommended to use one of its subclasses instead, as they give you greater convenience.
 * A typical use-case for this class would be to e.g. display a different button depending on some kind of context which is not known at compile time.
 *
 * @warning If you use this class directly, you must also use its designated initializer. The CUIButton convenience initializers will not allow you to control the `variant` and `appearance` properties.
 */
NS_SWIFT_NAME(ButtonOnColoredBackground)
@interface CUIButtonOnColoredBackground : CUIButton

/**
 * The variant of the button. This type of button is only available as `CUIButtonVariantPrimary` or `CUIButtonVariantSecondary`.
 * Using an invalid variant raises an assertion and the button will fall back to a valid variant.
 */
@property (nonatomic) CUIButtonVariant variant;
@property (nonatomic) CUIButtonOnColoredBackgroundAppearance appearance;

- (instancetype)initWithVariant:(CUIButtonVariant)variant appearance:(CUIButtonOnColoredBackgroundAppearance)appearance NS_DESIGNATED_INITIALIZER;

#pragma mark - Unavailable

/**
 * As defined by the CircuitUI design guidelines, this type of button does not support a destructive appearance.
 */
@property (nonatomic, getter=isDestructive) BOOL destructive NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
