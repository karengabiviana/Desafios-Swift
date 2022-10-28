//
//  SDSButtonStyleConfiguration+Private.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSButtonStyleConfiguration_Private_h
#define SDSButtonStyleConfiguration_Private_h

#import "SDSButtonStyleConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSButtonStyleConfiguration ()
@property (nonatomic, readwrite) SDSTextStyleConfiguration *textStyle;
@property (nonatomic, readwrite) SDSStatefulColor *imageColor;
@property (nonatomic, readwrite, nullable) SDSStatefulColor *backgroundColor;
@property (nonatomic, readwrite, nullable) SDSStatefulColor *statefulTintColor;
@property (nonatomic, readwrite, nullable) SDSStatefulColor *borderColor;

@property (nonatomic, readwrite, nullable) SDSStatefulScalar *borderWidth;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *cornerRadius;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *minimumHeight;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *paddingHorizontal;
@property (nonatomic, readwrite, nullable) SDSStatefulScalar *paddingVertical;

@property (nonatomic, readwrite, nullable) SDSShadow *shadow;
@end

NS_ASSUME_NONNULL_END

#endif
