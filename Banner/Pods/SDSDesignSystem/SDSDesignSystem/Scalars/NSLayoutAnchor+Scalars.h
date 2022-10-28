//
//  NSLayoutAnchor+Scalars.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 22.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef NSLayoutAnchor_Scalars_h
#define NSLayoutAnchor_Scalars_h

#import <UIKit/NSLayoutAnchor.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Category that adds scalar compatible methods to NSLayoutAnchor.
 *  Use these methods instead of extracting raw values from scalars and passing them as constants.
 *  All methods behave like their default counterparts.
 */
@interface NSLayoutAnchor<AnchorType> (Scalars)

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor scalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(equalTo:scalar:));
- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(equalTo:scalar:styleSheet:));

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor scalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(greaterThanOrEqualTo:scalar:));
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(greaterThanOrEqualTo:scalar:styleSheet:));

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor scalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(lessThanOrEqualTo:scalar:));
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(lessThanOrEqualTo:scalar:styleSheet:));

@end

/**
 *  Category that adds scalar compatible methods to NSLayoutDimension.
 *  Use these methods instead of extracting raw values from scalars and passing them as constants.
 *  All methods behave like their default counterparts.
 */
@interface NSLayoutDimension (Scalars)

- (NSLayoutConstraint *)constraintEqualToScalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(equalToScalar:));
- (NSLayoutConstraint *)constraintEqualToScalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(equalToScalar:styleSheet:));

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToScalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(greaterThanOrEqualToScalar:));
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToScalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(greaterThanOrEqualToScalar:styleSheet:));

- (NSLayoutConstraint *)constraintLessThanOrEqualToScalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(lessThanOrEqualToScalar:));
- (NSLayoutConstraint *)constraintLessThanOrEqualToScalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(lessThanOrEqualToScalar:styleSheet:));

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(equalTo:multiplier:scalar:));
- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(equalTo:multiplier:scalar:styleSheet:));

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(greaterThanOrEqualTo:multiplier:scalar:));
- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(greaterThanOrEqualTo:multiplier:scalar:styleSheet:));

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar NS_SWIFT_NAME(constraint(lessThanOrEqualTo:multiplier:scalar:));
- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet NS_SWIFT_NAME(constraint(lessThanOrEqualTo:multiplier:scalar:styleSheet:));

@end

NS_ASSUME_NONNULL_END

#endif
