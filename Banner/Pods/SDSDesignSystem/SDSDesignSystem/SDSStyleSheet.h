//
//  SDSStyleSheet.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStyleSheet_h
#define SDSStyleSheet_h

#import "SDSDesignPlatform.h"
#import "SDSButtonStyleConfiguration.h"
#import "SDSTextStyleConfiguration.h"
#import "SDSStatefulColor.h"
#import "SDSStatefulScalar.h"
#import "SDSShadow.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *   Reference a color in the palette.
 *
 *   @note Wherever possible you should use an SDSColorStyle to get a semantic color reference.
 */
NS_SWIFT_NAME(ColorReference)
typedef NSString *SDSColorReference NS_STRING_ENUM;

/**
 *   A color style semantically references a color in the color palette.
 *
 *   Multiple styles can reference the same color and allow you to link colors to UI element types.
 */
NS_SWIFT_NAME(ColorStyle)
typedef NSString *SDSColorStyle NS_STRING_ENUM;


/**
 *   Reference a scalar value in the stylesheet.
 */
NS_SWIFT_NAME(ScalarRef)
typedef NSString *SDSScalarRef NS_STRING_ENUM;

/**
 * Stylesheet provides information about colors, fonts, and other UI style related information.
 */
NS_SWIFT_NAME(StyleSheet)
@interface SDSStyleSheet : NSObject

+ (nullable instancetype)styleSheetFromURL:(NSURL *)url;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 *   Loads the style as defined by the main bundle's Style.json.
 *   Throws an exception if the global stylesheet cannot be loaded.
 */
@property (class, nonatomic, readonly) SDSStyleSheet *global;

/**
 *   By default the global stylesheet is loaded from the app main bundle's Style.json.
 *   This methods enables other paths to be used for the global stylesheet.
 *   Throws an exception if the stylesheet cannot be loaded from the provided url.
 *
 *   @param url Valid file-url to a Style.json.
 */
+ (void)loadGlobalStyleSheetFromURL:(NSURL *)url;

/**
 *   By default the global stylesheet is loaded from the app main bundle's Style.json.
 *   This methods enables other to pass in data representing a style sheet.
 *   Throws an exception if the stylesheet cannot be loaded from the provided data.
 *
 *   @param data Valid data representing a Style.json.
 */
+ (void)loadGlobalStyleSheetFromData:(NSData *)data;

#pragma mark - Scalars

/**
 *   A sorted list of all scalar keys.
 *
 *   This is mainly useful for code-generation and previews.
 */
@property (nonatomic, readonly) NSArray<SDSScalarType> *allScalarTypes;

/**
 *   Scalars represent values used on their own such as paddings as well values
 *   used by e.g. button styles such as linewidths.
 *
 *   @param type The scalar type to look up.
 *   @return The stateful scalar or nil if missing from the stylesheet.
 */
- (nullable SDSStatefulScalar *)scalarForType:(nullable SDSScalarType)type;

/**
 *   @param type The scalar type to look up.
 *   @return The normal scalar value as CGFloat or 0 if missing.
 */
- (CGFloat)scalarNormalValueForType:(nullable SDSScalarType)type;

#pragma mark - Shadows

/**
 *   Shadows contain all information necessary to apply a shadow to a CALayer.
 *   @param style The shadow style to look up.
 *   @return The shadow or nil if missing from stylesheet.
 */
- (nullable SDSShadow *)shadowForStyle:(nullable SDSShadowStyle)style;

/**
 *   A sorted list of all shadow style keys.
 *
 *   This is mainly useful for code-generation and previews.
 */
@property (nonatomic, readonly) NSArray<SDSShadowStyle> *allShadowStyles;

#pragma mark - Text and Fonts

/**
 *   A sorted list of all text style keys.
 *
 *   This is mainly useful for code-generation and previews.
 */
@property (nonatomic, readonly) NSArray<SDSTextStyle> *allTextStyles;

/**
 *   Provides the text style configuration associated with the given style if present in the stylesheet.
 *
 *   @param style The text style to look up.
 *
 *   @return The text style configuration for the given style or nil if missing in the stylesheet.
 */
- (nullable SDSTextStyleConfiguration *)configurationForTextStyle:(SDSTextStyle)style;

/**
 *   Provides the font not adjusted for current content category and associated with the given text style if present in the stylesheet.
 *
 *   @param style The text style to look up.
 *
 *   @return The font for the given style or nil if missing in the stylesheet.
 */
- (nullable __Font *)baseFontForStyle:(SDSTextStyle)style;

#pragma mark - Buttons

/**
 *   A sorted list of all button style keys.
 *
 *   This is mainly useful for code-generation and previews.
 */
@property (nonatomic, readonly) NSArray<SDSButtonStyle> *allButtonStyles;

/**
 *   Provides the text style configuration associated with the given style if present in the stylesheet.
 *
 *   @param style The text style to look up.
 *
 *   @return The text style configuration for the given style or nil if missing in the stylesheet.
 */
- (nullable SDSButtonStyleConfiguration *)configurationForButtonStyle:(SDSButtonStyle)style;

#pragma mark - Colors

/**
 *   A sorted list of all color style keys.
 *
 *   This is mainly useful for code-generation and previews.
 */
@property (nonatomic, readonly) NSArray<SDSColorStyle> *allColorStyles;

/**
 *   Provides the color associated with the given style if present in the stylesheet.
 *
 *   @param style The color style to look up.
 *
 *   @return The color for the given style or nil if missing in the stylesheet.
 */
- (nullable __Color *)colorForStyle:(SDSColorStyle)style;

/**
 *   Color sets desribe multiple `SDSStatefulColor` for different usages (such as background or foreground).
 *   Each `SDSStatefulColor` provides colors for the different UIControlStates
 *   (such as normal, highlighted, and disabled).
 *
 *   @param style The style to look up.
 *   @return The colorset associated with the color style or nil if missing from the stylesheet.
 */
- (nullable SDSStatefulColorSet *)colorSetForStyle:(SDSColorStyle)style;

/**
 *   A sorted list of all color reference keys in the stylesheet's palette.
 *
 *   This is mainly useful for code-generation and previews.
 */
@property (nonatomic, readonly) NSArray<SDSColorReference> *allColorReferences;

/**
 *   Provides the color from the stylesheet's palette associated with the given reference key.
 *
 *   @note Please use or introduce a color style wherever possible before resorting to using
 *   color references directly.
 *
 *   @param ref The color reference to look up.
 *
 *   @return The color from the stylesheet's palette associated with the given reference key or nil if missing.
 */
- (nullable __Color *)paletteColorWithReference:(SDSColorReference)ref;

@end

NS_ASSUME_NONNULL_END

#endif
