//
//  CALayer+Scalars.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 17.09.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef CALayer_Scalars_h
#define CALayer_Scalars_h

#import <QuartzCore/QuartzCore.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Scalars)

/**
 *  Sets the `cornerRadius` of the layer to the underlying value of `scalar`.
 *  Uses the global style sheet.
 */
- (void)sds_applyCornerRadius:(nullable SDSScalarType)scalar NS_SWIFT_NAME(applyCornerRadius(_:));

/**
 *  Sets the `cornerRadius` of the layer to the underlying value of `scalar` in `sheet`.
 */
- (void)sds_applyCornerRadius:(nullable SDSScalarType)scalar fromStyleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(applyCornerRadius(_:from:));

/**
 *  Sets the `borderWidth` of the layer to the underlying value of `scalar`.
 *  Uses the global style sheet.
 */
- (void)sds_applyBorderWidth:(nullable SDSScalarType)scalar NS_SWIFT_NAME(applyBorderWidth(_:));

/**
 *  Sets the `borderWidth` of the layer to the underlying value of `scalar` in `sheet`.
 */
- (void)sds_applyBorderWidth:(nullable SDSScalarType)scalar fromStyleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(applyBorderWidth(_:from:));

@end

NS_ASSUME_NONNULL_END

#endif
