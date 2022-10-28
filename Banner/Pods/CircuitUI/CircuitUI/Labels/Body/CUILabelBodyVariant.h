//
//  CUILabelBodyVariant.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 12.02.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, CUILabelBodyVariant) {
    CUILabelBodyVariantDefault,
    CUILabelBodyVariantSubtle,
    CUILabelBodyVariantHighlight,
    CUILabelBodyVariantDisabled,
    CUILabelBodyVariantSuccess,
    CUILabelBodyVariantError
} NS_SWIFT_NAME(LabelBodyVariant);

NS_SWIFT_NAME(LabelBodyVariant.supportsLinks(self:))
static inline BOOL CUILabelBodyVariantSupportsLinks(CUILabelBodyVariant variant) {
    switch (variant) {
        case CUILabelBodyVariantDefault:
            return YES;

        case CUILabelBodyVariantSubtle:
        case CUILabelBodyVariantHighlight:
        case CUILabelBodyVariantDisabled:
        case CUILabelBodyVariantSuccess:
        case CUILabelBodyVariantError:
            return NO;
    }

    NSCAssert(NO, @"Unhandled variant: %@", @(variant));
    return NO;
}
