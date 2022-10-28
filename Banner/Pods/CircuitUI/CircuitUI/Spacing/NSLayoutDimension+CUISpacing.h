//
//  NSLayoutDimension+CUISpacing.h
//  CircuitUI
//
//  Created by Hagi on 23.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISpacing.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutDimension (CUISpacing)

- (NSLayoutConstraint *)constraintEqualToSpacing:(CUISpacing)spacing NS_SWIFT_NAME(constraint(equalToSpacing:));

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToSpacing:(CUISpacing)spacing NS_SWIFT_NAME(constraint(greaterThanOrEqualToSpacing:));

- (NSLayoutConstraint *)constraintLessThanOrEqualToSpacing:(CUISpacing)spacing NS_SWIFT_NAME(constraint(lessThanOrEqualToSpacing:));

@end

NS_ASSUME_NONNULL_END
