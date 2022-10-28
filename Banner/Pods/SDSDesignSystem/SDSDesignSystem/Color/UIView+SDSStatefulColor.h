//
//  UIView+SDSStatefulColor.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 11.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef UIView_SDSStatefulColor_h
#define UIView_SDSStatefulColor_h

#import <UIKit/UIKit.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SDSStatefulColor)

/**
 *   Applies the normal background color associated with the provided color style in the global stylesheet.
 *   If no background usage color is specified in the given color style the first color in the set is used.
 *
 *   @param style The color style to use as a background color.
 */
- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(backgroundColorStyle:));

/**
 *   Applies the normal background color associated with the provided color style in the provided stylesheet.
 *   If no background usage color is specified in the given color style the first color in the set is used.
 *
 *   @param style The color style to use as a background color.
 *   @param styleSheet A stylesheet which includes the provided color style.
 */
- (void)sds_applyBackgroundColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(backgroundColorStyle:from:));

/**
 *   Applies the normal border color associated with the provided color style in the global stylesheet.
 *   If no border usage color is specified in the given color style the first color in the set is used.
 *
 *   @param style The color style to use as a border color.
 */
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(borderColorStyle:));

/**
 *   Applies the normal border color associated with the provided color style in the provided stylesheet.
 *   If no border usage color is specified in the given color style the first color in the set is used.
 *
 *   @param style The color style to use as a border color.
 *   @param styleSheet A stylesheet which includes the provided color style.
 */
- (void)sds_applyBorderColorStyle:(nullable SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(borderColorStyle:from:));

@end

NS_ASSUME_NONNULL_END

#endif
