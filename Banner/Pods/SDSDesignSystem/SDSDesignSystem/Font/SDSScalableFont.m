//
//  SDSScalableFont.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 14.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSScalableFont+Private.h"

@implementation SDSScalableFont

+ (instancetype)scalableFontWithBaseFont:(__Font *)font {
    SDSScalableFont *scalableFont = [[self alloc] init];
    
    scalableFont.scaleExponent = 1;
    scalableFont.baseFont = font;
    return scalableFont;
}

#if TARGET_OS_IOS
- (__Font *)scaledFontForContentSizeCategory:(UIContentSizeCategory)contentSize {
    CGFloat scale = pow([self currentScaleFactorForContentSizeCategory:contentSize], self.scaleExponent);
    
    return [self.baseFont fontWithSize:self.baseFont.pointSize * scale];
}

#endif /* TARGET_OS_IOS */

#if TARGET_OS_IOS
- (CGFloat)currentScaleFactorForContentSizeCategory:(UIContentSizeCategory)contentSize {
    if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
        return 0.7;
    } else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
        return 0.8;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
        return 0.9;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
        // default
        return 1.0;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
        return 1.1;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        return 1.2;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        return 1.3;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
        return 1.4;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
        return 1.5;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
        return 1.6;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
        return 1.8;
    } else if ([contentSize isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
        return 2.0;
    }
    
    NSAssert(NO, @"Unsupported UIContentSizeCategory: %@", contentSize);
    return 1.0;
}

#endif /* if TARGET_OS_IOS */
@end
