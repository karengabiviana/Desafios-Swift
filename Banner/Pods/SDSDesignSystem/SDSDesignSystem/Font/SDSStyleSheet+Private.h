//
//  SDSStyleSheet+Private.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStyleSheet_Private_h
#define SDSStyleSheet_Private_h

#import "SDSStyleSheet.h"
#import "SDSDesignPlatform.h"
#import "SDSButtonStyleConfiguration.h"
#import "SDSTextStyleConfiguration.h"
#import "SDSStatefulColor.h"
#import "SDSStatefulScalar.h"
#import "SDSScalableFont.h"

/**
 *   Keys in JSON dictionaries are guarenteed to be strings. Anything else is unknown.
 */
NS_SWIFT_NAME(JSONDictionary)
typedef NSDictionary<NSString *, id> * SDSJSONDictionary;

NS_SWIFT_NAME(FontNamesDictionary)
typedef NSDictionary<NSString *, NSArray<NSString * > *> * SDSFontNamesDictionary;

NS_SWIFT_NAME(ScalarSheet)
typedef NSDictionary<SDSScalarType, SDSStatefulScalar *> * SDSScalarSheet;

NS_SWIFT_NAME(ColorPalette)
typedef NSDictionary<SDSColorReference, __Color *> * SDSColorPalette;

NS_SWIFT_NAME(ColorStyleSheet)
typedef NSDictionary<SDSColorStyle, SDSStatefulColorSet *> * SDSColorStyleSheet;

NS_SWIFT_NAME(FontDictionary)
typedef NSDictionary<SDSTextStyle, SDSScalableFont *> * SDSFontDictionary;

NS_SWIFT_NAME(TextStylesDictionary)
typedef NSDictionary<SDSTextStyle, SDSTextStyleConfiguration *> * SDSTextStylesDictionary;

NS_SWIFT_NAME(ButtonStylesDictionary)
typedef NSDictionary<SDSButtonStyle, SDSButtonStyleConfiguration *> * SDSButtonStylesDictionary;

NS_SWIFT_NAME(ShadowStylesDictionary)
typedef NSDictionary<SDSShadowStyle, SDSShadow *> * SDSShadowStylesDictionary;

@interface SDSStyleSheet ()
@property (nonatomic, nullable) SDSFontNamesDictionary availableFontNames;
@property (nonatomic, nullable) SDSScalarSheet scalars;
@property (nonatomic, nullable) SDSButtonStylesDictionary buttonStyles;
@property (nonatomic, nullable) SDSFontDictionary fontStyles;
@property (nonatomic, nullable) SDSTextStylesDictionary textStyles;
@property (nonatomic, nullable) SDSColorPalette colorPalette;
@property (nonatomic, nullable) SDSColorStyleSheet colorStyles;
@property (nonatomic, nullable) SDSShadowStylesDictionary shadowStyles;
@end

#endif
