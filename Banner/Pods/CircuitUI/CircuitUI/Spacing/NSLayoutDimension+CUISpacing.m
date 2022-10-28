//
//  NSLayoutDimension+CUISpacing.m
//  CircuitUI
//
//  Created by Hagi on 23.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "NSLayoutDimension+CUISpacing.h"

@implementation NSLayoutDimension (CUISpacing)

- (NSLayoutConstraint *)constraintEqualToSpacing:(CUISpacing)spacing {
    return [self constraintEqualToConstant:spacing];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToSpacing:(CUISpacing)spacing {
    return [self constraintGreaterThanOrEqualToConstant:spacing];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToSpacing:(CUISpacing)spacing {
    return [self constraintLessThanOrEqualToConstant:spacing];
}

@end
