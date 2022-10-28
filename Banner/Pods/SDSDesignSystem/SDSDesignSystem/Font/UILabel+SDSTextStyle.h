//
//  UILabel+SDSTextStyle.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef UILabel_SDSTextStyle_h
#define UILabel_SDSTextStyle_h

#import <UIKit/UIKit.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SDSTextStyle)

/**
 *   Convenience method for -sds_applyTextStyle:invertedColor: with inverted being false.
 */
- (void)sds_applyTextStyle:(SDSTextStyle) style NS_SWIFT_NAME(apply(textStyle:));

/**
 *   Applies a text style configuration (font and colors) for the given text style as provided by the global
 *   stylesheet.
 *
 *   @note Fonts and colors will update automatically when the system's preferredContentSizeCategory changes (iOS 9 and
 *   later). If you subsequently manipulate the font or textColor properties manually, they will be overriden upon the
 *   next UIContentSizeCategoryDidChangeNotification. If you need to change the font/color manually, make sure to call
 *   sds_stopObservingContentSizeCategoryChanges.
 *
 *   @param style The style to apply to the label. It must be present in the global stylesheet to take effect.
 *   @param inverted If true the color will be inverted if available.
 */
- (void)sds_applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL) inverted NS_SWIFT_NAME(apply(textStyle:invertedColor:));

/**
 *   Applies a text style configuration (font and colors) for the given text style from the given stylesheet. See
 *   sds_applyTextStyle:invertedColor: for notes and discussion.
 *
 *   @param style The style to apply to the label. It must be present in the given stylesheet to take effect.
 *   @param inverted If true the color will be inverted if available.
 *   @param styleSheet The stylesheet defining the text style configuration.
 */
- (void)sds_applyTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *) styleSheet NS_SWIFT_NAME(apply(textStyle:invertedColor:from:));

/**
 *   Convenience method for -sds_applyTextStyleFromButtonStyle:invertedColor: with inverted being false.
 */
- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style NS_SWIFT_NAME(apply(textStyleFrom:));

/**
 *   Convenience method for -sds_applyTextStyleFromButtonStyle:invertedColor:fromStyleSheet: using the global style sheet.
 */
- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style invertedColor:(BOOL)inverted NS_SWIFT_NAME(apply(textStyleFrom:invertedColor:));

/**
 *   Applies a text style configuration (font and colors) for the given button style from the given stylesheet. See
 *   sds_applyTextStyle:invertedColor: for notes and discussion.
 *
 *   @param style A button style whose text style is applied to the label. It must be present in the given stylesheet to take effect.
 *   @param inverted If true the color will be inverted if available.
 *   @param styleSheet The stylesheet defining the text style configuration.
 */
- (void)sds_applyTextStyleFromButtonStyle:(SDSButtonStyle)style invertedColor:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(textStyleFrom:invertedColor:from:));

/**
 *   Stops the automatic text style updates in response to UIContentSizeCategoryDidChangeNotification after calling
 *   sds_applyTextStyle:.
 */
- (void)sds_stopObservingContentSizeCategoryChangesIfNeeded NS_SWIFT_NAME(stopObservingContentSizeCategoryChangesIfNeeded());

/// A label's text style configuration can be set using the sds_applyTextStyle methods.
@property (nonatomic, nullable, readonly) SDSTextStyleConfiguration *sds_textStyle;

/// Alternative to `isEnabled`, it reliably updates the label's appearance according to the current `sds_textStyle` in the setter.
/// `isEnabled` on the other hand always applies a system defined color behaviour.
@property (nonatomic, getter=sds_isEnabled) BOOL sds_enabled;

@end

NS_ASSUME_NONNULL_END

#endif
