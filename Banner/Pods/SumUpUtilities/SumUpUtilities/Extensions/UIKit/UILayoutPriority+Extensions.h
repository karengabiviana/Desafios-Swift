//
//  UILayoutPriority+Additions.h
//
//  Created by Florian Schliep on 30.08.18.
//  Copyright © 2018 SumUp. All rights reserved.
//
#import <UIKit/NSLayoutConstraint.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *   The minimal allowed layout priority. It is lower than UILayoutPriorityFittingSizeLevel, so
 *   constraints of this priority may be ignored/compressed when asking a view
 *   for its fitting or compressed size.
 */
static const UILayoutPriority SMPLayoutPriorityLowest NS_REFINED_FOR_SWIFT = 1;

/**
 *   Medium priority that is in between UILayoutPriorityDefaultLow and UILayoutPriorityDefaultHigh.
 */
static const UILayoutPriority SMPLayoutPriorityMedium NS_REFINED_FOR_SWIFT = 500;

/**
 *   Not required, but as close as it gets. This allows you to change the priority
 *   after the constraint was created/installed. A required constraint's priority
 *   cannot be altered.
 */
static const UILayoutPriority SMPLayoutPriorityAlmostRequired NS_REFINED_FOR_SWIFT = UILayoutPriorityRequired - 1.0;

NS_ASSUME_NONNULL_END
