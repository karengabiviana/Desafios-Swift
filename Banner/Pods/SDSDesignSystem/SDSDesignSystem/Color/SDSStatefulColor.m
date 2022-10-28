//
//  SDSStatefulColor.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSStatefulColor+Private.h"
#import "SDSStatefulObject+Private.h"
#import "SDSCast.h"
#import "SDSColorHelpers.h"
#import "SDSInternalConstants.h"

SDSStatefulColorUsage const SDSStatefulColorUsageForeground = @"foreground";
SDSStatefulColorUsage const SDSStatefulColorUsageBackground = @"background";
SDSStatefulColorUsage const SDSStatefulColorUsageShadow = @"shadow";
SDSStatefulColorUsage const SDSStatefulColorUsageImage = @"image";
SDSStatefulColorUsage const SDSStatefulColorUsageBorder = @"border";
SDSStatefulColorUsage const SDSStatefulColorUsageTint = @"tint";

static inline __Color *__nullable colorInDictForStringFromPalette(NSDictionary *dict, NSString *string, SDSColorPalette palette) {
    if (!string || !dict) {
        return nil;
    }

    NSString *colorPaletteRefOrHex = safeString(dict[string]);

    if (!colorPaletteRefOrHex) {
        return nil;
    }

    return palette[colorPaletteRefOrHex] ? : colorFromHex(colorPaletteRefOrHex);
}

@implementation SDSStatefulColor

+ (nullable instancetype)statefulColorWithValue:(NSObject *)obj colorPalette:(SDSColorPalette)palette {
    NSString *colorRef = safeString(obj);

    if (colorRef) {
        __Color *color = palette[colorRef] ? : colorFromHex(colorRef);

        if (!color) {
            return nil;
        }

        SDSStatefulColor *statefulColor = [SDSStatefulColor new];
        statefulColor.normal = color;
        statefulColor.colorValuesForDocs = [[SDSStatefulString alloc] initWithNormal:colorRef];

        return statefulColor;
    }

    NSDictionary *dict = safeDict(obj);

    __Color *color = colorInDictForStringFromPalette(dict, SDSJsonKeyNormal, palette);

    if (!color) {
        return nil;
    }

    SDSStatefulColor *statefulColor = [SDSStatefulColor new];
    statefulColor.normal = color;
    statefulColor.usage = safeString(dict[@"usage"]);

    statefulColor.colorValuesForDocs = [[SDSStatefulString alloc] initWithNormal:safeString(dict[SDSJsonKeyNormal])];

    __Color *colorHighlighted = colorInDictForStringFromPalette(dict, SDSJsonKeyHighlighted, palette);

    if (colorHighlighted) {
        statefulColor.colorValuesForDocs.highlighted = safeString(dict[SDSJsonKeyHighlighted]);
        statefulColor.highlighted = colorHighlighted;
    }

    __Color *colorDisabled = colorInDictForStringFromPalette(dict, SDSJsonKeyDisabled, palette);

    if (colorDisabled) {
        statefulColor.colorValuesForDocs.disabled = safeString(dict[SDSJsonKeyDisabled]);
        statefulColor.disabled = colorDisabled;
    }

    NSObject *inverted = dict[@"inverted"];

    if (inverted) {
        statefulColor.invertedColor = [self statefulColorWithValue:inverted colorPalette:palette];
        statefulColor.invertedColor.usage = statefulColor.usage;
    }

    return statefulColor;
}

- (NSString *)documentation {
    return [self.colorValuesForDocs documentation];
}

+ (instancetype)statefulColorFromColor:(__Color *)color {
    SDSStatefulColor *statefulColor = [SDSStatefulColor new];

    statefulColor.normal = color;
    return statefulColor;
}

#if TARGET_OS_IOS

- (UIColor *)valueForState:(UIControlState)controlState inverted:(BOOL)inverted {
    SDSStatefulColor *color = self;

    if (inverted && self.invertedColor) {
        color = self.invertedColor;
    }

    return [color valueForState:controlState];
}

#endif

@end

@implementation SDSStatefulColorSet

+ (nullable instancetype)statefulColorSetWithValue:(NSObject *)obj colorPalette:(SDSColorPalette)palette {
    if (!obj) {
        return nil;
    }

    NSArray *array = safeArray(obj);

    if (!array) {
        array = [NSArray arrayWithObject:obj];
    }

    NSMutableArray<SDSStatefulColor *> *colors = [NSMutableArray arrayWithCapacity:array.count];

    for (NSObject *value in array) {
        SDSStatefulColor *color = [SDSStatefulColor statefulColorWithValue:value colorPalette:palette];

        if (color) {
            [colors addObject:color];
        }
    }

    if (!colors.count) {
        return nil;
    }

    SDSStatefulColorSet *set = [SDSStatefulColorSet new];
    set.colors = colors;
    return set;
}

+ (instancetype)statefulColorSetWithColors:(NSArray<SDSStatefulColor *> *)colors {
    SDSStatefulColorSet *set = [SDSStatefulColorSet new];
    set.colors = colors;
    return set;
}

- (SDSStatefulColor *)strictColorForUsage:(SDSStatefulColorUsage)usage {
    if (!usage) {
        return self.colors.firstObject;
    }

    for (SDSStatefulColor *color in self.colors) {
        if ([color.usage isEqualToString:usage]) {
            return color;
        }
    }

    return nil;
}

- (SDSStatefulColor *)colorForUsage:(SDSStatefulColorUsage)usage {
    SDSStatefulColor *color = [self strictColorForUsage:usage];

    return color ? : self.colors.firstObject;
}

- (NSString *)documentation {
    if (self.colors.count <= 1) {
        return [self.colors.firstObject documentation] ? : @"";
    }

    NSMutableArray<NSString *> *docs = [NSMutableArray new];

    for (SDSStatefulColor *color in self.colors) {
        NSString *colorDoc = color.documentation;

        if (!colorDoc.length) {
            continue;
        }

        [docs addObject:[NSString stringWithFormat:@"%@: %@", color.usage ? : @"default", colorDoc]];
    }

    return [docs componentsJoinedByString:@"\n"];
}

@end
