//
//  UIView+Scalars.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 10.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef UIView_Scalars_h
#define UIView_Scalars_h

#import <UIKit/UIKit.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Scalars)

/**
 *  Applies a given color style as tint color to the view using the global style sheet.
 *  If available, the style's `tint` variant will be used.
 *
 *  @param color The color style to apply as tint color.
 */
- (void)sds_applyTintColor:(nullable SDSColorStyle)color NS_SWIFT_NAME(applyTintColor(_:));

/**
 *  Applies a given color style as tint color to the view using the given style sheet.
 *  If available, the style's `tint` variant will be used.
 *
 *  @param color The color style to apply as tint color.
 *  @param sheet The style sheet to retrieve the `color` from.
 */
- (void)sds_applyTintColor:(nullable SDSColorStyle)color fromStyleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(applyTintColor(_:from:));

@end

NS_ASSUME_NONNULL_END

#endif
