//
//  SDSCast.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSCast_h
#define SDSCast_h


#pragma mark Casting

static inline id _Nullable safeCast(NSObject * _Nonnull obj, Class _Nonnull aClass) {
    return [obj isKindOfClass:aClass] ? obj : nil;
}

static inline NSDictionary * _Nullable safeDict(NSObject * _Nonnull obj) {
    return safeCast(obj, [NSDictionary class]);
}

static inline NSString * _Nullable safeString(NSObject * _Nonnull obj) {
    return safeCast(obj, [NSString class]);
}

static inline NSNumber * _Nullable safeNumber(NSObject * _Nonnull obj) {
    return safeCast(obj, [NSNumber class]);
}

static inline NSArray * _Nullable safeArray(NSObject * _Nonnull obj) {
    return safeCast(obj, [NSArray class]);
}

#endif /* SDSCast_h */
