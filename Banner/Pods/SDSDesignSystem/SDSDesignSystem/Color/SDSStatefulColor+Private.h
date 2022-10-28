//
//  SDSStatefulColor+Private.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStatefulColor_Private_h
#define SDSStatefulColor_Private_h

#import "SDSStatefulColor.h"
#import "SDSStyleSheet+Private.h"

@class SDSStatefulString;

NS_ASSUME_NONNULL_BEGIN

@interface SDSStatefulColor ()
+ (nullable instancetype)statefulColorWithValue:(NSObject *)obj colorPalette:(SDSColorPalette)palette;
+ (instancetype)statefulColorFromColor:(__Color *)color;

@property (nonatomic, readwrite, nullable) SDSStatefulColorUsage usage;
@property (nonatomic, nullable) SDSStatefulColor *invertedColor;
@property (nonatomic, nullable) SDSStatefulString *colorValuesForDocs;
@end

@interface SDSStatefulColorSet ()
+ (nullable instancetype)statefulColorSetWithValue:(NSObject *)obj colorPalette:(SDSColorPalette)palette;
+ (instancetype)statefulColorSetWithColors:(NSArray<SDSStatefulColor *> *)colors;
@property (nonatomic, readwrite) NSArray<SDSStatefulColor *> *colors;
@end

NS_ASSUME_NONNULL_END

#endif
