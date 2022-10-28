//
//  SDSStatefulScalar.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 09.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStatefulScalar.h"
#import "SDSStatefulObject+Private.h"
#import "SDSCast.h"
#import "SDSInternalConstants.h"

@implementation SDSStatefulScalar

+ (nullable instancetype)statefulScalarWithValue:(NSObject *)obj {
    NSNumber *number = safeNumber(obj);

    if (number != nil) {
        SDSStatefulScalar *scalar = [SDSStatefulScalar new];
        scalar.normal = number;
        return scalar;
    }

    NSDictionary *dict = safeDict(obj);
    NSNumber *normal = safeNumber(dict[SDSJsonKeyNormal]);

    if (normal == nil) {
        NSLog(@"incomplete scalar value missing normal value: %@", obj);
        return nil;
    }

    SDSStatefulScalar *scalar = [SDSStatefulScalar new];
    scalar.normal = normal;
    scalar.highlighted = safeNumber(dict[SDSJsonKeyHighlighted]);
    scalar.disabled = safeNumber(dict[SDSJsonKeyDisabled]);
    return scalar;
}

+ (instancetype)zero {
    SDSStatefulScalar *scalar = [SDSStatefulScalar new];
    scalar.normal = [NSNumber numberWithDouble:0];
    return scalar;
}

- (NSString *)documentationForValue:(NSNumber *)obj {
    return [obj stringValue];
}

@end
