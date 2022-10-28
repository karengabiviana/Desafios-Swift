//
//  UIActivityIndicatorView+SDSStatefulColor.h
//  SDSDesignSystem
//
//  Created by Hagi on 28.10.19.
//  Copyright © 2019 SumUp. All rights reserved.
//

#ifndef UIActivityIndicatorView_SDSStatefulColor_h
#define UIActivityIndicatorView_SDSStatefulColor_h

#import <UIKit/UIKit.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIActivityIndicatorView (SDSStatefulColor)

/**
 *   Applies the normal foreground color associated with the provided color style in the global stylesheet.
 *
 *   @param style The color style to use.
 */
- (void)sds_applyColorStyle:(nullable SDSColorStyle)style NS_SWIFT_NAME(apply(colorStyle:));


/**
 *   Applies the normal foreground color associated with the provided color style in the global stylesheet.
 *
 *   @param style The color style to use.
 *   @param inverted If YES the inverted color will be used.
 */
- (void)sds_applyColorStyle:(nullable SDSColorStyle)style inverted:(BOOL)inverted NS_SWIFT_NAME(apply(colorStyle:inverted:));

/**
 *   Applies the normal foreground color associated with the provided color style in the provided stylesheet.
 *
 *   @param style The color style to use.
 *   @param inverted If YES the inverted color will be used.
 *   @param styleSheet A stylesheet which includes the provided color style.
 */
- (void)sds_applyColorStyle:(nullable SDSColorStyle)style inverted:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(colorStyle:inverted:from:));

@end

NS_ASSUME_NONNULL_END

#endif
