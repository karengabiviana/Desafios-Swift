//
//  CUIButtonStyle.m
//  CircuitUI
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;
#import "CUIButtonStyle.h"
#import "CUIFontSize.h"
#import "CUIColorRef.h"
#import "SDS+Helpers.h"
#import "CUIColorHelpers.h"
#import "CUIDefaultButton+DebugMenu.h"

typedef NSDictionary<SDSStatefulColorUsage, SDSStatefulColor *> * CUIButtonColorSet;

CGFloat CUIButtonStyleMinHeight(CUIButtonSize size) {
    switch (size) {
        case CUIButtonSizeGiga:
            return 48.;
        case CUIButtonSizeKilo:
            return 32.;
    }

    NSCAssert(NO, @"Unhandled size: %@", @(size));
    return 0.;
}

CGFloat CUIButtonStyleHorizontalPadding(CUIButtonSize size, CUIButtonVariant variant, BOOL hasText) {
    switch (variant) {
        case CUIButtonVariantPrimary:
        case CUIButtonVariantSecondary: {
            switch (size) {
                case CUIButtonSizeKilo:
                    return 16.;
                case CUIButtonSizeGiga:
                    return hasText ? 24. : 12.;
            }
        }
        case CUIButtonVariantTertiary: {
            switch (size) {
                case CUIButtonSizeKilo:
                    return 0.;
                case CUIButtonSizeGiga:
                    return hasText ? 0. : 12.;
            }
        }
    }

    NSCAssert(NO, @"Unhandled variant: %@, size: %@", @(variant), @(size));
    return 0.;
}

CGFloat CUIButtonStyleBorderWidth(CUIButtonVariant variant) {
    switch (variant) {
        case CUIButtonVariantPrimary:
        case CUIButtonVariantTertiary:
            return 0.;
        case CUIButtonVariantSecondary:
            return 1.f;
    }

    NSCAssert(NO, @"Unhandled variant: %@", @(variant));
    return 0.;
}

static inline NSString *CUIButtonStyleDisabledStateHex(NSString *hex) {
    return CUIColorAddAlphaComponentToHex(hex, 40);
}

static inline CUIButtonColorSet CUIButtonColorSetPrimaryDefault() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:CUIDefaultButton.__useBlackWhiteTheme ? CUIColorRefN100 : CUISemanticColorRefPrimary
                                                                       highlightedRef:CUIDefaultButton.__useBlackWhiteTheme ? CUIColorRefN60 : CUIColorRefB90
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIDefaultButton.__useBlackWhiteTheme ? CUIColorRefN100 : CUISemanticColorRefPrimary)]
    };
}

static inline CUIButtonColorSet CUIButtonColorSetPrimaryDestructive() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:CUISemanticColorRefAlert
                                                                       highlightedRef:CUIColorRefR90
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUISemanticColorRefAlert)]
    };
}

static inline CUIButtonColorSet CUIButtonColorSetSecondaryDefault() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN100
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN100)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                       highlightedRef:CUIColorRefN30
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)],
        SDSStatefulColorUsageBorder: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN50
                                                                   highlightedRef:CUIColorRefN70
                                                                      disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN50)],
    };
}

static inline CUIButtonColorSet CUIButtonColorSetSecondaryDestructive() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefR70
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefR70)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                       highlightedRef:CUIColorRefN30
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)],
        SDSStatefulColorUsageBorder: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefR80
                                                                   highlightedRef:CUIColorRefR70
                                                                      disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefR70)],
    };
}

static inline CUIButtonColorSet CUIButtonColorSetTertiaryDefault() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIDefaultButton.__useBlackWhiteTheme ? CUIColorRefN100 : CUISemanticColorRefPrimary
                                                                       highlightedRef:CUIDefaultButton.__useBlackWhiteTheme ? CUIColorRefN100 : CUIColorRefB90
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIDefaultButton.__useBlackWhiteTheme ? CUIColorRefN100 : CUIColorRefB70)]
    };
}

static inline CUIButtonColorSet CUIButtonColorSetTertiaryDestructive() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUISemanticColorRefAlert
                                                                       highlightedRef:CUIColorRefR90
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUISemanticColorRefAlert)]
    };
}

static inline CUIButtonColorSet CUIButtonColorSetCTA() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN100
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN100)]
    };
}

SDSTextStyleConfiguration *CTATextStyleGiga() {
    CUIButtonColorSet colorSet = CUIButtonColorSetCTA();
    return CUITextStyleConfigurationCreateWithColorSet(CUIFontSizeButton, UIFontWeightBold, colorSet);
}

SDSTextStyleConfiguration *CTATextStyleKilo() {
    CUIButtonColorSet colorSet = CUIButtonColorSetCTA();
    return CUITextStyleConfigurationCreateWithColorSet(CUIFontSizeButtonKilo, UIFontWeightBold, colorSet);
}

SDSTextStyleConfiguration *CUIButtonDefaultStyleCreateTextStyle(CUIButtonVariant variant, BOOL isDestructive) {
    CUIButtonColorSet colorSet;
    switch (variant) {
        case CUIButtonVariantPrimary:
            colorSet = isDestructive ? CUIButtonColorSetPrimaryDestructive() : CUIButtonColorSetPrimaryDefault();
            break;;
        case CUIButtonVariantSecondary:
            colorSet = isDestructive ? CUIButtonColorSetSecondaryDestructive() : CUIButtonColorSetSecondaryDefault();
            break;;
        case CUIButtonVariantTertiary:
            colorSet = isDestructive ? CUIButtonColorSetTertiaryDestructive() : CUIButtonColorSetTertiaryDefault();
            break;
    }

    if (!colorSet) {
        NSCAssert(NO, @"Missing color set for variant: %@, isDestructive: %@", @(variant), @(isDestructive));
    }

    return CUITextStyleConfigurationCreateWithColorSet(CUIFontSizeButton, UIFontWeightBold, colorSet);
}

static inline CUIButtonColorSet CUIButtonColorSetOnColoredBackgroundPrimaryLight() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN100
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN100)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                       highlightedRef:CUIColorAddAlphaComponentToHex(CUIColorRefN0, 60)
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)]
    };
}

static inline CUIButtonColorSet CUIButtonColorSetOnColoredBackgroundPrimaryDark() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN100
                                                                       highlightedRef:CUIColorAddAlphaComponentToHex(CUIColorRefN100, 60)
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN100)]
    };
}

static inline CUIButtonColorSet CUIButtonColorSetOnColoredBackgroundSecondaryLight() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:nil
                                                                       highlightedRef:CUIColorAddAlphaComponentToHex(CUIColorRefN0, 20)
                                                                          disabledRef:nil],
        SDSStatefulColorUsageBorder: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN0
                                                                   highlightedRef:CUIColorRefN0
                                                                      disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN0)],
    };
}

static inline CUIButtonColorSet CUIButtonColorSetOnColoredBackgroundSecondaryDark() {
    return @{
        SDSStatefulColorUsageForeground: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN100
                                                                       highlightedRef:nil
                                                                          disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN100)],
        SDSStatefulColorUsageBackground: [SDSStatefulColor statefulColorWithNormalRef:nil
                                                                       highlightedRef:CUIColorAddAlphaComponentToHex(CUIColorRefN100, 20)
                                                                          disabledRef:nil],
        SDSStatefulColorUsageBorder: [SDSStatefulColor statefulColorWithNormalRef:CUIColorRefN100
                                                                   highlightedRef:CUIColorRefN100
                                                                      disabledRef:CUIButtonStyleDisabledStateHex(CUIColorRefN100)],
    };
}

SDSTextStyleConfiguration *CUIButtonOnColoredBackgroundStyleCreateTextStyle(CUIButtonVariant variant, CUIButtonOnColoredBackgroundAppearance appearance) {
    CUIButtonColorSet colorSet;
    switch (variant) {
        case CUIButtonVariantPrimary: {
            switch (appearance) {
                case CUIButtonOnColoredBackgroundAppearanceLight:
                    colorSet = CUIButtonColorSetOnColoredBackgroundPrimaryLight();
                    break;
                case CUIButtonOnColoredBackgroundAppearanceDark:
                    colorSet = CUIButtonColorSetOnColoredBackgroundPrimaryDark();
                    break;
            }
            break;
        }
        case CUIButtonVariantSecondary: {
            switch (appearance) {
                case CUIButtonOnColoredBackgroundAppearanceLight:
                    colorSet = CUIButtonColorSetOnColoredBackgroundSecondaryLight();
                    break;
                case CUIButtonOnColoredBackgroundAppearanceDark:
                    colorSet = CUIButtonColorSetOnColoredBackgroundSecondaryDark();
                    break;
            }
            break;
        }
        case CUIButtonVariantTertiary:
            break;
    }

    if (!colorSet) {
        NSCAssert(NO, @"Missing color set for variant: %@, appearance: %@", @(variant), @(appearance));
    }

    return CUITextStyleConfigurationCreateWithColorSet(CUIFontSizeButton, UIFontWeightBold, colorSet);
}
