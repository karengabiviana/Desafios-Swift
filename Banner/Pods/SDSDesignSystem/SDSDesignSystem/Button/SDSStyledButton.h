//
//  SDSStyledButton.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStyledButton_h
#define SDSStyledButton_h

#import <UIKit/UIKit.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

@class SDSShadowView;

NS_SWIFT_NAME(StyledButton)
@interface SDSStyledButton : UIButton

/*
 *   Creates a new button with the given style configuration (font, colors, shadows...) from the global style sheet.
 *   See applyButtonStyle: for notes and discussion.
 *
 *   @param style The style to apply to the button. It must be present in the global stylesheet to take effect.
 *   @return Button with the given style.
 */
+ (instancetype)buttonWithStyle:(SDSButtonStyle)buttonStyle;

/*
 *   Creates a new button with the given style configuration (font, colors, shadows...) from the given style sheet.
 *   See applyButtonStyle: for notes and discussion.
 *
 *   @param style The style to apply to the button. It must be present in the given stylesheet to take effect.
 *   @param styleSheet The stylesheet defining the button style configuration.
 *   @return Button with the given style.
 */
+ (instancetype)buttonWithStyle:(SDSButtonStyle)buttonStyle styleSheet:(SDSStyleSheet *)styleSheet;

/**
 *   Convenience method for applyButtonStyle:invertedColors: with invertedColors being NO.
 */
- (void)applyButtonStyle:(SDSButtonStyle)style NS_SWIFT_NAME(apply(buttonStyle:));

/**
 *   Convenience method for applyButtonStyle:invertedColors:fromStyleSheet: using the global style sheet.
 */
- (void)applyButtonStyle:(SDSButtonStyle)style invertedColors:(BOOL)invertedColors NS_SWIFT_NAME(apply(buttonStyle:invertedColors:));

/**
 *   Applies a style configuration (font, colors, shadows...) for the given button style as provided by the given
 *   stylesheet. See applyButtonStyle: for notes and discussion.
 *
 *   @param style The style to apply to the button. It must be present in the given stylesheet to take effect.
 *   @param invertedColors Flag to control whether all colors are applied inverted.
 *   @param styleSheet The stylesheet defining the button style configuration.
 */
- (void)applyButtonStyle:(SDSButtonStyle)style invertedColors:(BOOL)invertedColors fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(buttonStyle:invertedColors:from:));

/**
 *   Stops the automatic button style updates in response to UIContentSizeCategoryDidChangeNotification after calling
 *   applyButtonStyle:.
 */
- (void)stopObservingContentSizeCategoryChanges;

/// The minimum height can be used to override the minimum height provided by the style.
@property (nonatomic, nullable) SDSStatefulScalar *minimumHeight;

/// The horizontal padding can be used to override the horizontal padding provided by the style.
/// Generally it is preferred to use a style's default padding, but if it's required from a visual perspective,
/// e.g. the button would be too small with the default padding, it is more sensible to override the padding
/// than to create another style that _only_ changes the padding.
@property (nonatomic, nullable) SDSStatefulScalar *horizontalPadding;

/// The vertical padding can be used to override the vertical padding provided by the style.
/// Generally it is preferred to use a style's default padding, but if it's required from a visual perspective,
/// e.g. the button would be too small with the default padding, it is more sensible to override the padding
/// than to create another style that _only_ changes the padding.
@property (nonatomic, nullable) SDSStatefulScalar *verticalPadding;

@end

@interface SDSStyledButton (Subclassing)

/// Subclasses can query the buttonStyle to use more information
@property (nonatomic, readonly, nullable) SDSButtonStyleConfiguration *buttonStyle;

/// Subclasses can override this property to ignore the minimum height provided by the style. Default returns NO.
@property (nonatomic, readonly) BOOL ignoreMinimumHeight;

/// Subclasses may modify the background view to apply their own styling to the button.
@property (nonatomic, readonly) SDSShadowView *backgroundView;

/// Subclasses may override this method to apply the buttonStyle differently.
- (void)updateForControlState:(UIControlState)controlState NS_REQUIRES_SUPER;

/// Subclasses may override this to perform any necessary additional initialization. Do not call directly.
- (void)commonInit NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END

#endif
