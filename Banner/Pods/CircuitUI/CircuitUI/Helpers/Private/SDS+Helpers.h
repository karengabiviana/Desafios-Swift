//
//  SDS+Helpers.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;
@import SDSDesignSystem;

#import "CUIColorHelpers.h"
#import "CUILabelHeadlineVariant.h"

#pragma mark - Private API

@interface SDSStatefulColor ()
@property (nonatomic, readwrite) SDSStatefulColorUsage usage;
+ (instancetype)statefulColorFromColor:(UIColor *)color;
@end

@interface SDSStatefulColorSet ()
+ (instancetype)statefulColorSetWithColors:(NSArray<SDSStatefulColor *> *)colors;
@end

@interface SDSStatefulObject<__covariant ObjectType> ()
@property (nonatomic, readwrite) ObjectType normal;
@property (nonatomic, readwrite) ObjectType highlighted;
@property (nonatomic, readwrite) ObjectType disabled;
@end

#pragma mark - Helpers

@interface SDSStatefulColor (Circuit)
+ (instancetype)statefulColorWithNormalRef:(SDSColorReference)normalColor highlightedRef:(SDSColorReference)highlightedColor disabledRef:(SDSColorReference)disabledColor;
@end

static inline SDSTextStyleConfiguration *CUITextStyleConfigurationCreate(CGFloat size, UIFontWeight weight, SDSColorReference colorRef) {
    UIFont *font = [UIFont systemFontOfSize:size weight:weight];
    SDSStatefulColor *statefulColor = [SDSStatefulColor statefulColorFromColor:CUIColorFromHex(colorRef)];

    return [SDSTextStyleConfiguration configurationWithBaseFont:[SDSScalableFont scalableFontWithBaseFont:font]
                                                         colors:[SDSStatefulColorSet statefulColorSetWithColors:@[statefulColor]]];
}

static inline SDSTextStyleConfiguration *CUITextStyleConfigurationCreateWithColorSet(CGFloat size, UIFontWeight weight, NSDictionary<SDSStatefulColorUsage, SDSStatefulColor *> *colors) {
    UIFont *font = [UIFont systemFontOfSize:size weight:weight];

    NSMutableArray *statefulColors = [NSMutableArray arrayWithCapacity:colors.count];
    [colors enumerateKeysAndObjectsUsingBlock:^(SDSStatefulColorUsage usage, SDSStatefulColor *color, BOOL *stop) {
        color.usage = usage;
        [statefulColors addObject:color];
    }];

    return [SDSTextStyleConfiguration configurationWithBaseFont:[SDSScalableFont scalableFontWithBaseFont:font]
                                                         colors:[SDSStatefulColorSet statefulColorSetWithColors:[statefulColors copy]]];
}
