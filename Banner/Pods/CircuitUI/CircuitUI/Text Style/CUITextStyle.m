//
//  CUITextStyle.m
//  CircuitUI
//
//  Created by Florian Schliep on 20.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;
#import "CUITextStyle.h"
#import "CUIFontSize.h"
#import "CUIColorRef.h"
#import "SDS+Helpers.h"

static inline SDSColorReference CUITextColorLargeAmount(BOOL strikethrough) {
    if (strikethrough) {
        return CUIColorRefN60;
    } else {
        return CUIColorRefN100;
    }
}

static inline SDSColorReference CUITextColorHeadline(CUILabelHeadlineVariant variant) {
    switch (variant) {
        case CUILabelHeadlineVariantInverted:
            return CUIColorRefN0;
        case CUILabelHeadlineVariantDefault:
            break; // attention: fallthrough!
    }

    return CUIColorRefN100;
}

static inline SDSColorReference CUITextColorSubheadline() {
    return CUIColorRefN60;
}

static inline SDSColorReference CUITextColorBody(CUILabelBodyVariant variant) {
    switch (variant) {
        case CUILabelBodyVariantSubtle:
            return CUIColorRefN60;
        case CUILabelBodyVariantSuccess:
            return CUISemanticColorRefConfirm;
        case CUILabelBodyVariantError:
            return CUISemanticColorRefAlert;
        case CUILabelBodyVariantDisabled:
            return CUIColorRefN50;
        case CUILabelBodyVariantHighlight:
        case CUILabelBodyVariantDefault:
            break; // attention: fallthrough!
    }

    return CUIColorRefN80;
}

static inline SDSColorReference CUITextColorInteractictive(CUILabelInteractiveVariant variant) {
    switch (variant) {
        case CUILabelInteractiveVariantHighlighted:
            return CUISemanticColorRefPrimary;
        case CUILabelInteractiveVariantDefault:
            break; // attention: fallthrough!
    }

    return CUIColorRefN100;
}

SDSColorReference CUITextColorStatusComponent(CUIStatusVariant variant) {
    switch (variant) {
        case CUIStatusVariantTint:
        case CUIStatusVariantConfirm:
        case CUIStatusVariantAlert:
        case CUIStatusVariantPromo:
        case CUIStatusVariantSpecial:
            return CUIColorRefN0;
        case CUIStatusVariantNeutral:
        case CUIStatusVariantNotify:
            break; // attention: fallthrough!
    }
    
    return CUIColorRefN100;
}

static inline UIFontWeight CUIFontWeightLargeAmount(BOOL strikethrough) {
    if (strikethrough) {
        return UIFontWeightRegular;
    } else {
        return UIFontWeightBold;
    }
}

static inline UIFontWeight CUIFontWeightBody(CUILabelBodyVariant variant) {
    switch (variant) {
        case CUILabelBodyVariantHighlight:
            return UIFontWeightBold;
        case CUILabelBodyVariantDefault:
        case CUILabelBodyVariantSubtle:
        case CUILabelBodyVariantDisabled:
        case CUILabelBodyVariantSuccess:
        case CUILabelBodyVariantError:
            break; // attention: fallthrough!
    }

    return UIFontWeightRegular;
}

static inline UIFontWeight CUIFontWeightInteractive(CUILabelInteractiveVariant variant) {
    switch (variant) {
        case CUILabelInteractiveVariantHighlighted:
            return UIFontWeightBold;
        case CUILabelInteractiveVariantDefault:
            break; // attention: fallthrough!
    }

    return UIFontWeightMedium;
}

static inline UIFontWeight CUIFontWeightStatusComponent() {
    return UIFontWeightBold;
}

#pragma mark - Styles

SDSTextStyleConfiguration *CUITextStyleCreateLargeAmount(BOOL strikethrough) {
    return CUITextStyleConfigurationCreate(CUIFontSizeLargeAmount, CUIFontWeightLargeAmount(strikethrough), CUITextColorLargeAmount(strikethrough));
}

SDSTextStyleConfiguration *CUITextStyleCreateHeadline1(CUILabelHeadlineVariant variant) {
    return CUITextStyleConfigurationCreate(CUIFontSizeHeadline1, UIFontWeightBold, CUITextColorHeadline(variant));
}

SDSTextStyleConfiguration *CUITextStyleCreateHeadline2(CUILabelHeadlineVariant variant) {
    return CUITextStyleConfigurationCreate(CUIFontSizeHeadline2, UIFontWeightBold, CUITextColorHeadline(variant));
}

SDSTextStyleConfiguration *CUITextStyleCreateHeadline3() {
    return CUITextStyleConfigurationCreate(CUIFontSizeHeadline3, UIFontWeightBold, CUITextColorHeadline(CUILabelHeadlineVariantDefault));

}
SDSTextStyleConfiguration *CUITextStyleCreateHeadline4() {
    return CUITextStyleConfigurationCreate(CUIFontSizeHeadline4, UIFontWeightBold, CUITextColorHeadline(CUILabelHeadlineVariantDefault));
}

SDSTextStyleConfiguration *CUITextStyleCreateSubheadline() {
    return CUITextStyleConfigurationCreate(CUIFontSizeSubheadline, UIFontWeightBold, CUITextColorSubheadline());
}

SDSTextStyleConfiguration *CUITextStyleCreateBody1(CUILabelBodyVariant variant, BOOL strikethrough) {
    return CUITextStyleConfigurationCreate(CUIFontSizeBody1, CUIFontWeightBody(variant), strikethrough ? CUIColorRefN60 : CUITextColorBody(variant));
}

SDSTextStyleConfiguration *CUITextStyleCreateBody2(CUILabelBodyVariant variant) {
    return CUITextStyleConfigurationCreate(CUIFontSizeBody2, CUIFontWeightBody(variant), CUITextColorBody(variant));
}

SDSTextStyleConfiguration *CUITextStyleCreateInteractive1(CUILabelInteractiveVariant variant) {
    return CUITextStyleConfigurationCreate(CUIFontSizeInteractive1, CUIFontWeightInteractive(variant), CUITextColorInteractictive(variant));
}

SDSTextStyleConfiguration *CUITextStyleCreateInteractive2(CUILabelInteractiveVariant variant) {
    return CUITextStyleConfigurationCreate(CUIFontSizeInteractive2, CUIFontWeightInteractive(variant), CUITextColorInteractictive(variant));
}

SDSTextStyleConfiguration *CUITextStyleCreateStatusComponent(CUIStatusVariant variant) {
    return CUITextStyleConfigurationCreate(CUIFontSizeStatusComponent, CUIFontWeightStatusComponent(), CUITextColorStatusComponent(variant));
}
