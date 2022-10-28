//
//  NSLayoutAnchor+NSLayoutAnchor_CUISpacing.m
//  CircuitUI
//
//  Created by Illia Lukisha on 18/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "NSLayoutAnchor+CUISpacing.h"

@implementation NSLayoutAnchor (NSLayoutAnchor_CUISpacing)

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutAnchor *)anchor spacing:(CUISpacing)spacing {
    return [self constraintEqualToAnchor:anchor constant:spacing];
}

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutAnchor *)anchor spacing:(CUISpacing)spacing {
    return [self constraintGreaterThanOrEqualToAnchor:anchor constant:spacing];
}

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutAnchor *)anchor spacing:(CUISpacing)spacing {
    return [self constraintLessThanOrEqualToAnchor:anchor constant:spacing];
}

@end
