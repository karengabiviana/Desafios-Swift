//
//  SDSTextStyleConfiguration.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSTextStyleConfiguration+Private.h"
#import "SDSStyleSheet+Private.h"
#import "SDSStatefulColor+Private.h"
#import "SDSStatefulObject+Private.h"

#if TARGET_OS_IOS
static UIContentSizeCategory SDSTextStyleConfigurationContentSizeCategory;
#endif

@interface SDSTextStyleConfiguration ()
@property (nonatomic, readwrite) SDSStatefulColorSet *colors;
@property (nonatomic, readwrite) SDSStatefulColor *textColor;
@end

@implementation SDSTextStyleConfiguration

+ (instancetype)configurationWithBaseFont:(SDSScalableFont *)font colors:(SDSStatefulColorSet *)colors {
    SDSTextStyleConfiguration *config = [[self alloc] init];
    config.baseFont = font;
    config.colors = colors;
    config.textColor = [colors colorForUsage:SDSStatefulColorUsageForeground];
    return config;
}

- (SDSStatefulColor *)textColor {
    NSAssert(_textColor, @"Use configurationWithBaseFont:textColor:");
    return _textColor ? : [SDSStatefulColor statefulColorFromColor:[__Color blackColor]];
}

- (SDSScalableFont *)baseFont {
    NSAssert(_baseFont, @"Use configurationWithBaseFont:textColor:");
    return _baseFont ? : [SDSScalableFont scalableFontWithBaseFont:[__Font systemFontOfSize:14]];
}

- (__Font *)scaledFont {
#if TARGET_OS_IOS
    return [self.baseFont scaledFontForContentSizeCategory:self.contentSizeCategory];
#else
    return self.baseFont.baseFont;
#endif /* TARGET_OS_IOS */
}

- (NSString *)documentation {
    NSString *fontDoc = [self.baseFont documentation];
    NSString *colorDoc = [self.textColor documentation];
    if (!colorDoc.length) {
        return fontDoc;
    }

    return [fontDoc stringByAppendingFormat:@"\nColor: %@", colorDoc];
}

#pragma mark - Font Scaling

#if TARGET_OS_IOS

+ (void)setContentSizeCategory:(UIContentSizeCategory)contentSizeCategory {
    SDSTextStyleConfigurationContentSizeCategory = contentSizeCategory;
}

+ (UIContentSizeCategory)contentSizeCategory {
    return SDSTextStyleConfigurationContentSizeCategory;
}

- (UIContentSizeCategory)contentSizeCategory {
    return [self.class contentSizeCategory] ? : [UIApplication sharedApplication].preferredContentSizeCategory;
}

- (NSDictionary<NSAttributedStringKey, id> *)textAttributesForControlState:(UIControlState)state includeColor:(BOOL)includeColor {
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithObject:self.scaledFont forKey:NSFontAttributeName];

    if (includeColor) {
        [baseDict setObject:[self.textColor valueForState:state] forKey:NSForegroundColorAttributeName];
    }

    return [baseDict copy];
}

#endif /* TARGET_OS_IOS */

@end
