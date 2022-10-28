//
//  NSLayoutAnchor+Scalars.m
//  SDSDesignSystem
//
//  Created by Florian Schliep on 22.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "NSLayoutAnchor+Scalars.h"

@implementation NSLayoutAnchor (Scalars)

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutAnchor *)anchor scalar:(nullable SDSScalarType)scalar {
    return [self constraintEqualToAnchor:anchor scalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutAnchor *)anchor scalar:(nullable SDSScalarType)scalar {
    return [self constraintGreaterThanOrEqualToAnchor:anchor scalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutAnchor *)anchor scalar:(nullable SDSScalarType)scalar {
    return [self constraintLessThanOrEqualToAnchor:anchor scalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutAnchor *)anchor scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintEqualToAnchor:anchor constant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutAnchor *)anchor scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintGreaterThanOrEqualToAnchor:anchor constant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutAnchor *)anchor scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintLessThanOrEqualToAnchor:anchor constant:[sheet scalarForType:scalar].normal.doubleValue];
}

@end

@implementation NSLayoutDimension (Scalars)

- (NSLayoutConstraint *)constraintEqualToScalar:(nullable SDSScalarType)scalar {
    return [self constraintEqualToScalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToScalar:(nullable SDSScalarType)scalar {
    return [self constraintGreaterThanOrEqualToScalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToScalar:(nullable SDSScalarType)scalar {
    return [self constraintLessThanOrEqualToScalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar {
    return [self constraintEqualToAnchor:anchor multiplier:m scalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar {
    return [self constraintGreaterThanOrEqualToAnchor:anchor multiplier:m scalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar {
    return [self constraintLessThanOrEqualToAnchor:anchor multiplier:m scalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (NSLayoutConstraint *)constraintEqualToScalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintEqualToConstant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToScalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintGreaterThanOrEqualToConstant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToScalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintLessThanOrEqualToConstant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintEqualToAnchor:anchor multiplier:m constant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintGreaterThanOrEqualToAnchor:anchor multiplier:m constant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutDimension *)anchor multiplier:(CGFloat)m scalar:(nullable SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintLessThanOrEqualToAnchor:anchor multiplier:m constant:[sheet scalarForType:scalar].normal.doubleValue];
}

@end
