//
//  SDSTextStyleConfiguration.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSTextStyleConfiguration_h
#define SDSTextStyleConfiguration_h

#import "SDSDesignPlatform.h"

@class SDSStatefulColor;
@class SDSStatefulColorSet;
@class SDSScalableFont;

NS_ASSUME_NONNULL_BEGIN

/**
 *   SDSTextStyle's are effectively names/keys for style configurations
 *   in the JSON stylesheets. Using string constants, these can be
 *   defined/extended by clients depending on their needs and the JSON
 *   format.
 *
 *   You can use the SDSDesignSymbolExtractor tool to generate the style
 *   constants automatically.
 */
NS_SWIFT_NAME(TextStyle)
typedef NSString * SDSTextStyle NS_STRING_ENUM;

/**
 *   Text style configurations are part of SDSStyleSheets and provide style
 *   information applicable to most displays of texts:
 *
 *   - UILabel via the SDSTextStyle category
 *   - SDSStyledTextField
 *   - SDSStyledTextView
 */
NS_SWIFT_NAME(TextStyleConfiguration)
@interface SDSTextStyleConfiguration : NSObject
@property (nonatomic, readonly) SDSStatefulColorSet *colors;
@property (nonatomic, readonly) SDSStatefulColor *textColor;
@property (nonatomic, readonly) NSString *documentation;

/**
 *   The font adjusted for the current preferred UIContentSizeCategory on iOS,
 *   the original font on macOS.
 */
@property (nonatomic, readonly) __Font *scaledFont;

+ (instancetype)configurationWithBaseFont:(SDSScalableFont *)font colors:(SDSStatefulColorSet *)colors;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

#if TARGET_OS_IOS

/// A dictionary of text attributes for use on attributed strings
- (NSDictionary<NSAttributedStringKey, id> *)textAttributesForControlState:(UIControlState)state includeColor:(BOOL)includeColor;

#endif

@end

NS_ASSUME_NONNULL_END

#endif
