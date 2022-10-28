//
//  SDSStatefulObject.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 09.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStatefulObject_h
#define SDSStatefulObject_h

#import "SDSDesignPlatform.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *   A generic class providing multiple values of the same type (ObjectType) for different control states
 *   (normal, highlighted, disabled).
 */
@interface SDSStatefulObject<__covariant ObjectType>: NSObject

/// The default value to be used for the normal control state. This is the fallback if other values are not provided.
@property (nonatomic, readonly) ObjectType normal;

/// The value to be used for the highlighted control state. Fallsback to the normal (default) value if the highlighted
/// value is not provided.
@property (nonatomic, readonly) ObjectType highlighted;

/// The value to be used for the disabled control state. Fallsback to the normal (default) value if the disabled
/// value is not provided.
@property (nonatomic, readonly) ObjectType disabled;

#if TARGET_OS_IOS

/**
 *   Convenience method to retrieve the appropriate property for the given control state.
 *
 *   @param controlState The control state for which a value should be provided.
 *   @return The value associated with the given control state.
 */
- (ObjectType)valueForState:(UIControlState)controlState;
#endif
@end

NS_ASSUME_NONNULL_END

#endif
