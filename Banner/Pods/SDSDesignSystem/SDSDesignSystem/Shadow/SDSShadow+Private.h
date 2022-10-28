//
//  SDSShadow+Private.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 25.07.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSShadow_Private_h
#define SDSShadow_Private_h

#import "SDSShadow.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSShadow ()
@property (nonatomic, readwrite, nullable) SDSStatefulColor *borderColor;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *borderWidth;

@property (nonatomic, readwrite) SDSStatefulColor *color;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *opacity;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *blurRadius;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *spread;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *offsetY;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *offsetX;
@end

NS_ASSUME_NONNULL_END

#endif
