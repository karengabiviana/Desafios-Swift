//
//  SDSShadow.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 25.07.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSShadow_h
#define SDSShadow_h

#import "SDSStatefulColor.h"
#import "SDSStatefulScalar.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *   A shadow style references a shadow configuration in a stylesheet.
 */
NS_SWIFT_NAME(ShadowStyle)
typedef NSString *SDSShadowStyle NS_STRING_ENUM;

@interface SDSShadow : NSObject
@property (nonatomic, readonly, nullable) SDSStatefulColor *borderColor;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *borderWidth;

@property (nonatomic, readonly) SDSStatefulColor *color;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *opacity;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *blurRadius;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *spread;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *offsetY;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *offsetX;

#if TARGET_OS_IOS
- (UIEdgeInsets)coveredMarginForState:(UIControlState)state;
#endif

@end

NS_ASSUME_NONNULL_END

#endif
