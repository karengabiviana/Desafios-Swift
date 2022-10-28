//
//  SDSScalableFont.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 14.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSScalableFont_h
#define SDSScalableFont_h

#import "SDSDesignPlatform.h"
NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ScalableFont)
@interface SDSScalableFont : NSObject
@property (nonatomic, readonly) __Font *baseFont;
@property (nonatomic, readonly, nullable) NSString *documentation;

+ (instancetype)scalableFontWithBaseFont:(__Font *)font;

#if TARGET_OS_IOS
- (__Font *)scaledFontForContentSizeCategory:(UIContentSizeCategory)contentSize;
#endif

/// The scale exponent determines how the baseFont is scaled for various contentSizeCategories.
/// At exponent 1 the font is scaled linearly from factor 0.7 to 2.
/// At exponent 2 the font is scaled from 0.49 to 4.
/// At exponent 0 the font does not scale.
/// Exponents should usually be between [0-1]. Defaults to 1.
@property (nonatomic) CGFloat scaleExponent;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#endif
