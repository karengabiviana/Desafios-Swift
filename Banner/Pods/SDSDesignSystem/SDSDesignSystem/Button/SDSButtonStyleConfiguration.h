//
//  SDSButtonStyleConfiguration.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSButtonStyleConfiguration_h
#define SDSButtonStyleConfiguration_h

#import "SDSDesignPlatform.h"
#import "SDSStatefulScalar.h"


@class SDSShadow;
@class SDSStatefulColor;
@class SDSTextStyleConfiguration;

NS_ASSUME_NONNULL_BEGIN

/**
 *   SDSButtonStyles are effectively names/keys for style configurations
 *   in the JSON stylesheets. Using string constants, these can be
 *   defined/extended by clients depending on their needs and the JSON
 *   format.
 *
 *   You can use the SDSDesignSymbolExtractor tool to generate the style
 *   constants automatically.
 */
NS_SWIFT_NAME(ButtonStyle)
typedef NSString * SDSButtonStyle NS_STRING_ENUM;

NS_SWIFT_NAME(ButtonStyleConfiguration)
@interface SDSButtonStyleConfiguration : NSObject
+ (instancetype)buttonStyleConfigurationWithTextStyleConfiguration:(SDSTextStyleConfiguration *)textStyle;
@property (nonatomic, readonly) __Color *tintColor;
@property (nonatomic, readonly) SDSTextStyleConfiguration *textStyle;
@property (nonatomic, readonly) SDSStatefulColor *imageColor;
@property (nonatomic, readonly, nullable) SDSStatefulColor *backgroundColor;
@property (nonatomic, readonly, nullable) SDSStatefulColor *statefulTintColor;
@property (nonatomic, readonly, nullable) SDSStatefulColor *borderColor;

@property (nonatomic, readonly, nullable) SDSStatefulScalar *borderWidth;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *cornerRadius;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *minimumHeight;

@property (nonatomic, readonly, nullable) SDSStatefulScalar *paddingHorizontal;
@property (nonatomic, readonly, nullable) SDSStatefulScalar *paddingVertical;

@property (nonatomic, readonly, nullable) SDSShadow *shadow;
@end

NS_ASSUME_NONNULL_END

#endif
