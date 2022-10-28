//
//  NSLayoutConstraint+Scalars.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 22.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef NSLayoutConstraint_Scalars_h
#define NSLayoutConstraint_Scalars_h

#import <UIKit/NSLayoutConstraint.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Category that adds scalar compatible methods to NSLayoutConstraint.
 *  Use these methods instead of extracting raw values from scalars and passing them as constants.
 *  All methods behave like their default counterparts.
 */
@interface NSLayoutConstraint (Scalars)

+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier scalar:(nullable SDSScalarType)scalar;
+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet;


/**
 *  Sets the `constant` of the constraint to the underlying value of `scalar`.
 *  Uses the global style sheet.
 */
- (void)applyScalar:(nullable SDSScalarType)scalar;

/**
 *  Sets the `constant` of the constraint to the underlying value of `scalar` in `sheet`.
 */
- (void)applyScalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet;

@end

NS_ASSUME_NONNULL_END

#endif
