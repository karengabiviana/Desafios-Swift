//
//  SDSStatefulObject.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 09.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStatefulObject_Private_h
#define SDSStatefulObject_Private_h

#import "SDSStatefulObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSStatefulObject<__covariant ObjectType> ()
@property (nonatomic, readwrite) ObjectType normal;
@property (nonatomic, readwrite) ObjectType highlighted;
@property (nonatomic, readwrite) ObjectType disabled;
@property (nonatomic, readonly) NSString *documentation;
- (NSString *)documentationForValue:(ObjectType)obj;
@end

@interface SDSStatefulString : SDSStatefulObject<NSString *>
- (instancetype)initWithNormal:(nullable NSString *)normal;
@end

NS_ASSUME_NONNULL_END

#endif
