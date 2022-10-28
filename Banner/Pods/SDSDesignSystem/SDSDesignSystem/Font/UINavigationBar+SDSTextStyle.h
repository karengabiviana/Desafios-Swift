//
//  UINavigationBar+SDSTextStyle.h
//  SDSDesignSystem
//
//  Created by Evgeniy Nazarov on 18.02.19.
//  Copyright © 2019 SumUp. All rights reserved.
//

#ifndef UINavigationBar_SDSTextStyle_h
#define UINavigationBar_SDSTextStyle_h

#import <UIKit/UIKit.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (SDSTextStyle)

/**
 *   Applies a text style configuration (font and colors) for the given text style as provided by the global
 *   stylesheet.
 *
 *  @note Fonts and colors will not update automatically.
 *
 *   @param style The style to apply to title label. It must be present in the global stylesheet to take effect.
 */
- (void)sds_applyTitleTextStyle:(SDSTextStyle)style NS_SWIFT_NAME(apply(titleTextStyle:));

/**
 *   Applies a text style configuration (font and colors) for the given text style as provided by the global
 *   stylesheet.
*
 *   @note Fonts and colors will not update automatically.
 *
 *   @param style The style to apply to title label. It must be present in the global stylesheet to take effect.
 *   @param inverted If true the color will be inverted if available.
 */
- (void)sds_applyTitleTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted NS_SWIFT_NAME(apply(titleTextStyle:invertedColor:));

@end

NS_ASSUME_NONNULL_END

#endif
