//
//  SDSShadowView.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 25.07.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSShadowView_h
#define SDSShadowView_h

#import <UIKit/UIKit.h>
#import "SDSShadow.h"

@class SDSStyleSheet;

NS_ASSUME_NONNULL_BEGIN

/**
 *   A UIView subclass supporting all styling information provided by SDSShadow including
 *   rendering of different UIControlStates and cornerRadius support.
 */
NS_SWIFT_NAME(ShadowView)
@interface SDSShadowView : UIView
@property (nonatomic, nullable) SDSShadow *shadow;
@property (nonatomic) UIControlState controlState;
/// In order to properly render the cornerRadius it must be set via this property rather
/// than through the underlying CALayer.
@property (nonatomic) CGFloat cornerRadius;

/**
 *  In order to properly render the cornerRadius it must be set via this method rather
 *  than through the underlying CALayer. Uses the global style sheet.
 */
- (void)applyCornerRadius:(nullable SDSScalarType)scalar;

/**
 *  In order to properly render the cornerRadius it must be set via this method rather
 *  than through the underlying CALayer.
 */
- (void)applyCornerRadius:(nullable SDSScalarType)scalar fromStyleSheet:(SDSStyleSheet *)sheet;

@end

NS_ASSUME_NONNULL_END

#endif
