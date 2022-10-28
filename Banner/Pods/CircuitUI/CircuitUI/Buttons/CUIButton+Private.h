//
//  CUIButton+Private.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButton.h"
#import "CUIButtonVariant.h"
@import SDSDesignSystem;

@interface CUIButton (Private)

#pragma mark - Private API

/**
 * Controls whether the button applies its corner rounding behavior. Defaults to YES.
 * CUIButton ignores the `cornerRadius` property of `SDSButtonStyleConfiguration`.
 */
@property (nonatomic, readonly, getter=hasRoundedCorners) BOOL roundedCorners;

/**
 * Returns the title of the button in its current control state.
 */
@property (nonatomic, readonly) BOOL hasTitleInCurrentState;

/**
 * Use this method to perform any initialization work that is needed for the setup of the button.
 * This is the preferred way over overriding initializers, because the base class ensures `cui_commonInit` is called for all cases.
 */
- (void)cui_commonInit NS_REQUIRES_SUPER;

/**
 * Updates the button's style by creating a new configuration, using `-createButtonStyleConfiguration`, and applying it.
 */
- (void)reloadButtonStyle;

/**
 * Adjusts the button's padding according to the button style configuration.
 * Override this method if you need to perform adjustment over the default behavior.
 */
- (void)updatePaddingForControlState:(UIControlState)controlState NS_REQUIRES_SUPER;

#pragma mark - To be implemented by subclasses

/**
 * This method will be called by the base class every time a new button style configuration is needed.
 * It is discouraged to perform any kind of caching in the implementation of this method and a new object should be returned on every call.
 * Must be implemented by subclasses as the base class does not provide an implementation.
 */
- (SDSButtonStyleConfiguration *)createButtonStyleConfiguration;

@end

#pragma mark - Private SDS API

@interface SDSButtonStyleConfiguration ()
@property (nonatomic, readwrite) SDSStatefulScalar *borderWidth;
@property (nonatomic, readwrite) SDSStatefulScalar *minimumHeight;
@property (nonatomic, readwrite) SDSStatefulScalar *paddingHorizontal;
@property (nonatomic, readwrite) SDSStatefulScalar *paddingVertical;
@end

