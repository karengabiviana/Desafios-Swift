//
//  SDSStyleSheet.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStyleSheet+Private.h"
#import "SDSButtonStyleConfiguration+Private.h"
#import "SDSCast.h"
#import "SDSColorHelpers.h"
#import "SDSScalableFont+Private.h"
#import "SDSShadow+Private.h"
#import "SDSStatefulColor+Private.h"
#import "SDSTextStyleConfiguration+Private.h"

#define SDSLog(format, ...) NSLog((@"%s (line %i): " format),__PRETTY_FUNCTION__,__LINE__, ##__VA_ARGS__)

#pragma mark - Style Sheet

static SDSStyleSheet *globalStylesheet;

@implementation SDSStyleSheet

+ (void)loadGlobalStyleSheetFromURL:(NSURL *)url {
    NSParameterAssert(url);

    if (!url) {
        return;
    }

    NSData *data = [NSData dataWithContentsOfURL:url];
    NSAssert(data, @"data could not be loaded from  %@", url);
    [self loadGlobalStyleSheetFromData:data];
}

+ (void)loadGlobalStyleSheetFromData:(NSData *)data {
    NSParameterAssert(data.length);

    if (!data.length) {
        return;
    }

    SDSStyleSheet *styleSheet = [SDSStyleSheet styleSheetFromData:data];
    NSAssert(styleSheet, @"global stylesheet could not be loaded from data");

    if (!styleSheet) {
        return;
    }

    globalStylesheet = styleSheet;
}

+ (instancetype)global {
    if (!globalStylesheet) {
        globalStylesheet = [SDSStyleSheet styleSheetFromURL:[[NSBundle mainBundle] URLForResource:@"Style" withExtension:@"json"]];
        NSAssert(globalStylesheet, @"global stylesheet Style.json could not be loaded from main bundle. Include Style.json in your app bundle or use +loadGlobalStyleSheetFromURL:.");
    }

    return globalStylesheet;
}

#pragma mark - Shadow

- (nullable SDSShadow *)shadowForStyle:(nullable SDSShadowStyle)style {
    if (!style) {
        return nil;
    }

    return self.shadowStyles[style];
}

- (NSArray<SDSShadowStyle> *)allShadowStyles {
    if (!self.shadowStyles.count) {
        return @[];
    }

    return [self.shadowStyles.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

#pragma mark - Scalars

- (SDSStatefulScalar *)scalarForType:(SDSScalarType)type {
    if (!type) {
        return nil;
    }

    return self.scalars[type];
}

- (CGFloat)scalarNormalValueForType:(nullable SDSScalarType)type {
    return [[[self scalarForType:type] normal] doubleValue];
}

- (NSArray<SDSScalarType> *)allScalarTypes {
    if (!self.scalars.count) {
        return @[];
    }

    return [self.scalars.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

#pragma mark - Text and Fonts

- (SDSTextStyleConfiguration *)configurationForTextStyle:(SDSTextStyle)style {
    return self.textStyles[style];
}

- (__Font *)baseFontForStyle:(SDSTextStyle)style
{
    SDSTextStyleConfiguration *configuration = [self configurationForTextStyle:style];
    return configuration.baseFont.baseFont;
}

- (NSArray<SDSTextStyle> *)allTextStyles {
    if (!self.textStyles.count) {
        return @[];
    }

    return [self.textStyles.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

#pragma mark - Buttons

- (SDSButtonStyleConfiguration *)configurationForButtonStyle:(SDSButtonStyle)style {
    return self.buttonStyles[style];
}

- (NSArray<SDSButtonStyle> *)allButtonStyles {
    if (!self.buttonStyles.count) {
        return @[];
    }

    return [self.buttonStyles.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

#pragma mark - Colors

- (NSArray<SDSColorStyle> *)allColorStyles {
    if (!self.colorStyles.count) {
        return @[];
    }

    return [self.colorStyles.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

- (NSArray<SDSColorReference> *)allColorReferences {
    if (!self.colorPalette.count) {
        return @[];
    }

    return [self.colorPalette.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

- (__Color *)colorForStyle:(SDSColorStyle)style {
    return [[self.colorStyles[style] colorForUsage:SDSStatefulColorUsageForeground] normal];
}

- (__Color *)backgroundColorForStyle:(SDSColorStyle)style {
    return [[self.colorStyles[style] strictColorForUsage:SDSStatefulColorUsageBackground] normal];
}

- (SDSStatefulColorSet *)colorSetForStyle:(SDSColorStyle)style {
    return self.colorStyles[style];
}

- (__Color *)paletteColorWithReference:(SDSColorReference)ref {
    return self.colorPalette[ref];
}

#pragma mark - JSON loading

+ (instancetype)styleSheetFromURL:(NSURL *)url {
    NSParameterAssert(url);
    NSData *data = [NSData dataWithContentsOfURL:url];

    if (!data) {
        SDSLog(@"Could not load style sheet data from URL: %@", url);
        return nil;
    }

    return [self styleSheetFromData:data];
}

+ (instancetype)styleSheetFromData:(NSData *)data {
    if (!data) {
        SDSLog(@"Could not load style sheet with nil data");
        return nil;
    }

    NSError *error;
    SDSJSONDictionary json = safeDict([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);

    if (error || !json) {
        SDSLog(@"Could not deserialize style sheet json from data! Error: %@", error);
        return nil;
    }

    SDSStyleSheet *styleSheet = [[self alloc] init];
    styleSheet.scalars = [self scalarSheetFromDict:json];
    styleSheet.availableFontNames = [self availableFontNamesFromStyleDict:json];
    styleSheet.fontStyles = [self fontStylesFromStyleDict:json availableFonts:styleSheet.availableFontNames];
    styleSheet.colorPalette = [self colorPaletteFromDict:json];
    styleSheet.colorStyles = [self colorStylesFromDict:json withColorPalette:styleSheet.colorPalette];
    styleSheet.textStyles = [self textStylesFromDict:json withColorPalette:styleSheet.colorPalette colorStyles:styleSheet.colorStyles fontStyles:styleSheet.fontStyles];
    styleSheet.shadowStyles = [self shadowStylesFromDict:json withScalars:styleSheet.scalars colorPalette:styleSheet.colorPalette colorStyles:styleSheet.colorStyles];
    styleSheet.buttonStyles = [self buttonStylesFromDict:json withScalars:styleSheet.scalars colorPalette:styleSheet.colorPalette colorStyles:styleSheet.colorStyles fontStyles:styleSheet.fontStyles textStyles:styleSheet.textStyles shadowStyles:styleSheet.shadowStyles];
    return styleSheet;
}

+ (SDSJSONDictionary)fontCollectionFromStyleDict:(SDSJSONDictionary)dict {
    return safeDict(dict[@"font-collection"]);
}

+ (SDSFontNamesDictionary)availableFontNamesFromStyleDict:(SDSJSONDictionary)dict {
    SDSJSONDictionary fontCollection = [self fontCollectionFromStyleDict:dict];

    return safeDict(fontCollection[@"available-fonts"]);
}

+ (SDSFontDictionary)fontStylesFromStyleDict:(SDSJSONDictionary)dict availableFonts:(SDSJSONDictionary)availableFonts {
    SDSJSONDictionary fontCollection = [self fontCollectionFromStyleDict:dict];
    SDSJSONDictionary fontStylesRaw = safeDict(fontCollection[@"font-styles"]);

    NSMutableDictionary<SDSTextStyle, SDSScalableFont *> *fontStyles = [NSMutableDictionary dictionaryWithCapacity:fontStylesRaw.count];

    [fontStylesRaw enumerateKeysAndObjectsUsingBlock:^(SDSTextStyle _Nonnull fontKey, id _Nonnull fontInfos, BOOL * _Nonnull stop) {
        SDSJSONDictionary styleAttributes = safeDict(fontInfos);
        NSString *fontRef = safeString(styleAttributes[@"name"]);
        NSNumber *baseSize = safeNumber(styleAttributes[@"size"]);

        if (!fontRef || (baseSize == nil)) {
            SDSLog(@"Missing font name or size for %@", fontKey);
            return;
        }

        SDSScalableFont *font = [self fontWithReference:fontRef baseSize:baseSize.doubleValue fromAvailableFonts:availableFonts];

        if (!font) {
            if ([self useFallbackFont]) {
                SDSLog(@"Could not load font for %@. Will use fallback.", fontRef);
                font = [SDSScalableFont scalableFontWithBaseFont:[__Font systemFontOfSize:baseSize.doubleValue]];
            } else {
                SDSLog(@"Could not load font for %@", fontRef);
                return;
            }
        }

        NSNumber *scaleExponent = safeNumber(styleAttributes[@"scale-exponent"]);

        if (scaleExponent != nil) {
            font.scaleExponent = scaleExponent.doubleValue;
        }

        fontStyles[fontKey] = font;
    }];

    return [fontStyles copy];
}

+ (SDSScalableFont *)fontWithReference:(NSString *)fontRef baseSize:(double)baseSize fromAvailableFonts:(SDSFontNamesDictionary)availableFonts {
    NSArray<NSString *> *fontNames = safeArray(availableFonts[fontRef]);

    if (!fontNames) {
        SDSLog(@"Cannot find %@ in available fonts: %@", fontRef, availableFonts);
        return nil;
    }

    for (NSString *fontName in fontNames) {
        if (!safeString(fontName)) {
            SDSLog(@"Invalid font name: %@", fontName);
            continue;
        }

        __Font *font = [__Font fontWithName:fontName size:baseSize];
        NSString *documentation = [NSString stringWithFormat:@"%@ (%@pt)", fontName, @(baseSize)];

        if (!font && [fontName isEqualToString:@"system"]) {
            font = [__Font systemFontOfSize:baseSize];
        } else if (!font && [fontName isEqualToString:@"system:bold"]) {
            font = [__Font boldSystemFontOfSize:baseSize];
        }

        if (font) {
            SDSScalableFont *scalableFont = [SDSScalableFont scalableFontWithBaseFont:font];
            scalableFont.documentation = documentation;
            return scalableFont;
        }

#if DEBUG
        // this is expected when used in the SumUp SDK so silence in non-debug builds
        SDSLog(@"Could not load font with name: %@", fontName);
#endif
    }

    SDSLog(@"Cannot find valid font for %@ in available fonts: %@", fontRef, availableFonts);
    return nil;
}

+ (BOOL)useFallbackFont {
#if TARGET_OS_IOS
    return NO;
#else
    // Fonts that are used in apps may not necessarily be installed
    // on developer computers (e.g., due to licensing constraints).
    // For now, macOS is only supported for code generation, where
    // the actual font instances do not matter. Should become a
    // public property once we really want to support macOS.
    return YES;
#endif /* TARGET_OS_IOS */
}

+ (SDSScalarSheet)scalarSheetFromDict:(SDSJSONDictionary)dictionary {
    SDSJSONDictionary scalarsRaw = safeDict(dictionary[@"scalars"]);

    NSMutableDictionary<SDSScalarType, SDSStatefulScalar *> *scalars = [NSMutableDictionary dictionaryWithCapacity:scalarsRaw.count];

    [scalarsRaw enumerateKeysAndObjectsUsingBlock:^(SDSScalarType scalarType, id scalarValueRaw, BOOL * _Nonnull stop) {
        SDSStatefulScalar *scalarValue = [SDSStatefulScalar statefulScalarWithValue:scalarValueRaw];

        if (scalarValue) {
            scalars[scalarType] = scalarValue;
        } else {
            SDSLog(@"Unable to extract scalar from %@ for %@", scalarValueRaw, scalarType);
        }
    }];

    return [scalars copy];
}

+ (SDSColorPalette)colorPaletteFromDict:(SDSJSONDictionary)dictionary {
    SDSJSONDictionary hexColors = safeDict(dictionary[@"color-palette"]);

    NSMutableDictionary<SDSColorReference, __Color *> *colors = [NSMutableDictionary dictionaryWithCapacity:hexColors.count];

    [hexColors enumerateKeysAndObjectsUsingBlock:^(SDSColorReference colorKey, id colorInfo, BOOL * _Nonnull stop) {
        NSString *colorHex = safeString(colorInfo);
        __Color *color = colorFromHex(colorHex);

        if (color) {
            colors[colorKey] = color;
        } else {
            SDSLog(@"Unable to extract color from %@ for %@", colorInfo, colorKey);
        }
    }];

    return [colors copy];
}

+ (SDSColorStyleSheet)colorStylesFromDict:(SDSJSONDictionary)dictionary withColorPalette:(SDSColorPalette)colorPalette {
    SDSJSONDictionary colorStyles = safeDict(dictionary[@"color-styles"]);

    NSMutableDictionary<SDSColorStyle, SDSStatefulColorSet *> *colors = [NSMutableDictionary dictionaryWithCapacity:colorStyles.count];

    [colorStyles enumerateKeysAndObjectsUsingBlock:^(SDSColorStyle _Nonnull colorStyleKey, id _Nonnull colorInfo, BOOL * _Nonnull stop) {
        SDSStatefulColorSet *color = [SDSStatefulColorSet statefulColorSetWithValue:colorInfo colorPalette:colorPalette];

        if (color) {
            colors[colorStyleKey] = color;
        } else {
            SDSLog(@"Color not found for key %@", colorStyleKey);
        }
    }];

    return [colors copy];
}

+ (SDSTextStylesDictionary)textStylesFromDict:(SDSJSONDictionary)dictionary withColorPalette:(SDSColorPalette)colorPalette colorStyles:(SDSColorStyleSheet)colorStyles fontStyles:(SDSFontDictionary)fontStyles {
    SDSJSONDictionary textConfigurationsRaw = safeDict(dictionary[@"text-styles"]);

    NSMutableDictionary<SDSTextStyle, SDSTextStyleConfiguration *> *textConfigurations = [NSMutableDictionary dictionaryWithCapacity:textConfigurationsRaw.count];

    [textConfigurationsRaw enumerateKeysAndObjectsUsingBlock:^(SDSTextStyle _Nonnull textStyle, id _Nonnull styleInfo, BOOL * _Nonnull stop) {
        SDSTextStyleConfiguration *config = [self textStyleConfigurationFromDictionary:safeDict(styleInfo) withColorPalette:colorPalette colorStyles:colorStyles fontStyles:fontStyles];

        if (config) {
            textConfigurations[textStyle] = config;
        } else {
            SDSLog(@"Error creating text configuration for %@", textStyle);
        }
    }];

    return [textConfigurations copy];
}

+ (SDSStatefulColorSet *)colorSetWithValue:(NSObject *)textColorObj fromPalette:(SDSColorPalette)colorPalette colorStyles:(SDSColorStyleSheet)colorStyles {
    SDSColorStyle colorStyle = safeString(textColorObj);

    if (colorStyle && colorStyles[colorStyle]) {
        return colorStyles[colorStyle];
    }

    SDSStatefulColorSet *textColor = [SDSStatefulColorSet statefulColorSetWithValue:textColorObj
                                                                       colorPalette:colorPalette];
    return textColor;
}

+ (SDSTextStyleConfiguration *)textStyleConfigurationFromDictionary:(SDSJSONDictionary)textConfigurationDict withColorPalette:(SDSColorPalette)colorPalette colorStyles:(SDSColorStyleSheet)colorStyles fontStyles:(SDSFontDictionary)fontStyles {
    if (!textConfigurationDict.count) {
        return nil;
    }

    NSString *fontReference = safeString(textConfigurationDict[@"font-style"]);

    if (!fontReference) {
        SDSLog(@"Missing font style reference in %@", textConfigurationDict);
        return nil;
    }

    SDSScalableFont *font = fontStyles[fontReference];

    if (!font) {
        SDSLog(@"Unresolved font reference: %@", fontReference);
        return nil;
    }

    NSObject *textColorObj = textConfigurationDict[@"color"];
    SDSStatefulColorSet *textColor = [self colorSetWithValue:textColorObj fromPalette:colorPalette colorStyles:colorStyles];

    if (!textColor) {
        SDSLog(@"Unable to retrieve color %@ with palette %@", textColorObj, colorPalette);
        return nil;
    }

    return [SDSTextStyleConfiguration configurationWithBaseFont:font colors:textColor];
}

+ (SDSButtonStylesDictionary)buttonStylesFromDict:(SDSJSONDictionary)dictionary withScalars:(SDSScalarSheet)scalars colorPalette:(SDSColorPalette)colorPalette colorStyles:(SDSColorStyleSheet)colorStyles fontStyles:(SDSFontDictionary)fontStyles textStyles:(SDSTextStylesDictionary)textStyles shadowStyles:(SDSShadowStylesDictionary)shadowStyles {
    SDSJSONDictionary buttonConfigurationsRaw = safeDict(dictionary[@"button-styles"]);

    NSMutableDictionary<SDSButtonStyle, SDSButtonStyleConfiguration *> *buttonConfigurations = [NSMutableDictionary dictionaryWithCapacity:buttonConfigurationsRaw.count];

    [buttonConfigurationsRaw enumerateKeysAndObjectsUsingBlock:^(SDSButtonStyle _Nonnull buttonStyle, id _Nonnull styleInfo, BOOL * _Nonnull stop) {
        SDSJSONDictionary styleDict = safeDict(styleInfo);

        if (!styleDict.count) {
            return;
        }

        NSString *inherited = safeString(styleDict[@"inherit"]);

        if (inherited) {
            NSMutableDictionary *superDict = [buttonConfigurationsRaw[inherited] mutableCopy];
            [superDict addEntriesFromDictionary:styleDict];
            styleDict = [superDict copy];
        }

        NSObject *textStyleRaw = styleDict[@"text-style"];

        if (!textStyleRaw) {
            return;
        }

        SDSTextStyleConfiguration *textStyle;
        SDSTextStyle textStyleRef = safeString(textStyleRaw);
        SDSJSONDictionary textStyleCustom = safeDict(textStyleRaw);

        if (textStyleRef) {
            textStyle = textStyles[textStyleRef];
        } else if (textStyleCustom) {
            textStyle = [self textStyleConfigurationFromDictionary:textStyleCustom withColorPalette:colorPalette colorStyles:colorStyles fontStyles:fontStyles];
        }

        if (!textStyle) {
            SDSLog(@"Unable to generate text style for button style %@", buttonStyle);
            return;
        }

        SDSButtonStyleConfiguration *config = [self buttonStyleConfigurationWithColorPalette:colorPalette colorStyles:colorStyles scalars:scalars styleDict:styleDict textStyle:textStyle shadowStyles:shadowStyles];
        buttonConfigurations[buttonStyle] = config;
    }];

    return buttonConfigurations;
}

+ (SDSButtonStyleConfiguration *)buttonStyleConfigurationWithColorPalette:(SDSColorPalette)colorPalette colorStyles:(SDSColorStyleSheet)colorStyles scalars:(SDSScalarSheet)scalars styleDict:(SDSJSONDictionary)styleDict textStyle:(SDSTextStyleConfiguration *)textStyle shadowStyles:(SDSShadowStylesDictionary)shadowStyles {
    SDSButtonStyleConfiguration *config = [SDSButtonStyleConfiguration buttonStyleConfigurationWithTextStyleConfiguration:textStyle];

    config.borderWidth = [self scalarWithValue:styleDict[@"border-width"] sheet:scalars];
    config.minimumHeight = [self scalarWithValue:styleDict[@"min-height"] sheet:scalars];
    config.cornerRadius = [self scalarWithValue:styleDict[@"corner-radius"] sheet:scalars];
    config.paddingVertical = [self scalarWithValue:styleDict[@"padding-v"] sheet:scalars];
    config.paddingHorizontal = [self scalarWithValue:styleDict[@"padding-h"] sheet:scalars];
    SDSShadowStyle shadowStyle = styleDict[@"shadow"];

    if (shadowStyle) {
        config.shadow = shadowStyles[shadowStyle];
    }

    return config;
}

+ (SDSShadowStylesDictionary)shadowStylesFromDict:(SDSJSONDictionary)dictionary withScalars:(SDSScalarSheet)scalars colorPalette:(SDSColorPalette)colorPalette colorStyles:(SDSColorStyleSheet)colorStyles  {
    SDSJSONDictionary shadowsRaw = safeDict(dictionary[@"shadows"]);

    NSMutableDictionary<SDSShadowStyle, SDSShadow *> *shadowStyles = [NSMutableDictionary dictionaryWithCapacity:shadowsRaw.count];

    [shadowsRaw enumerateKeysAndObjectsUsingBlock:^(SDSShadowStyle _Nonnull shadowStyle, id _Nonnull styleInfo, BOOL * _Nonnull stop) {
        SDSStatefulColor *color = [[[self colorSetWithValue:styleInfo[@"color"] fromPalette:colorPalette colorStyles:colorStyles] colors] firstObject];

        if (!color) {
            // shadows need an explicit color
            return;
        }

        SDSShadow *shadow = [SDSShadow new];
        shadow.color = color;
        shadow.blurRadius = [self scalarWithValue:styleInfo[@"blur-radius"] sheet:scalars];
        shadow.spread = [self scalarWithValue:styleInfo[@"spread"] sheet:scalars];
        shadow.opacity = [self scalarWithValue:styleInfo[@"opacity"] sheet:scalars];
        shadow.offsetX = [self scalarWithValue:styleInfo[@"offset-x"] sheet:scalars];
        shadow.offsetY = [self scalarWithValue:styleInfo[@"offset-y"] sheet:scalars];

        shadow.borderWidth = [self scalarWithValue:styleInfo[@"outer-stroke-width"] sheet:scalars];
        shadow.borderColor = [[self colorSetWithValue:styleInfo[@"outer-stroke-color"] fromPalette:colorPalette colorStyles:colorStyles] colorForUsage:SDSStatefulColorUsageBorder];

        shadowStyles[shadowStyle] = shadow;
    }];

    return [shadowStyles copy];
}

/// will return nil if obj is nil
+ (nullable SDSStatefulScalar *)scalarWithValue:(nullable NSObject *)obj sheet:(SDSScalarSheet)sheet {
    if (!obj) {
        return nil;
    }

    NSString *string = safeString(obj);
    SDSStatefulScalar *scalar = string ? sheet[string] : nil;

    if (scalar) {
        return scalar;
    }

    return [SDSStatefulScalar statefulScalarWithValue:obj];
}

@end
