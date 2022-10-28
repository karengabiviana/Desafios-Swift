//
//  NSLayoutAnchor+CUISpacing.h
//  CircuitUI
//
//  Created by Illia Lukisha on 18/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISpacing.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutAnchor<AnchorType> (NSLayoutAnchor_CUISpacing)

- (NSLayoutConstraint *)constraintEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor spacing:(CUISpacing)spacing NS_SWIFT_NAME(constraint(equalTo:spacing:));

- (NSLayoutConstraint *)constraintGreaterThanOrEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor spacing:(CUISpacing)spacing NS_SWIFT_NAME(constraint(greaterThanOrEqualTo:spacing:));

- (NSLayoutConstraint *)constraintLessThanOrEqualToAnchor:(NSLayoutAnchor<AnchorType> *)anchor spacing:(CUISpacing)spacing NS_SWIFT_NAME(constraint(lessThanOrEqualTo:spacing:));

@end

NS_ASSUME_NONNULL_END
