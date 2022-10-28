//
//  SDSStatefulScalar.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 09.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStatefulScalar_h
#define SDSStatefulScalar_h

#import "SDSStatefulObject.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ScalarType)
typedef NSString *SDSScalarType NS_STRING_ENUM;

/**
 *   Class providing multiple scalar values for different control states
 *   (normal, highlighted, disabled).
 */
NS_SWIFT_NAME(StatefulScalar)
@interface SDSStatefulScalar : SDSStatefulObject<NSNumber *>

/**
 *   Initializes a new stateful scalar from a value as found in json stylesheets.
 *
 *   @param obj Either a number for the scalar value or a dictionary providing different values
 *              for the control states normal, highlighted, and disabled.
 *   @return A stateful scalar object or nil if the provided value is invalid.
 */
+ (nullable instancetype)statefulScalarWithValue:(NSObject *)obj;

/**
 *   Initializes a new stateful scalar that will always return zero values.
 */
+ (instancetype)zero;

@end

NS_ASSUME_NONNULL_END

#endif
