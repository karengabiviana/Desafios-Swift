//
//  CUIStatusVariantColors.m
//  CircuitUI
//
//  Created by Hagi on 05.10.2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIStatusVariantColors.h"

#import "CUIColorHelpers.h"
#import "CUIColorRef.h"
#import "CUITextStyle.h"

UIColor * CUIContrastColorFromStatusVariant(CUIStatusVariant variant) {
    return CUIColorFromHex(CUITextColorStatusComponent(variant));
}

UIColor * CUITintColorFromStatusVariant(CUIStatusVariant variant) {
    switch (variant) {
        case CUIStatusVariantTint:
            return CUIColorFromHex(CUIColorRefB70);
        case CUIStatusVariantConfirm:
            return CUIColorFromHex(CUISemanticColorRefConfirm);
        case CUIStatusVariantNeutral:
            return CUIColorFromHex(CUISemanticColorRefNeutral);
        case CUIStatusVariantNotify:
            return CUIColorFromHex(CUISemanticColorRefNotify);
        case CUIStatusVariantAlert:
            return CUIColorFromHex(CUISemanticColorRefAlert);
        case CUIStatusVariantPromo:
            return CUIColorFromHex(CUISemanticColorRefPromo1);
        case CUIStatusVariantSpecial:
            return CUIColorFromHex(CUIColorRefN100);
    }

    NSCAssert(NO, @"Invalid status variant: %@", @(variant));
    return [UIColor blueColor];
}
