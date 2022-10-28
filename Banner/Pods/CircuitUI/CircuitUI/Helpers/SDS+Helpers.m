//
//  SDS+Helpers.m
//  CircuitUI
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "SDS+Helpers.h"

@implementation SDSStatefulColor (Circuit)

+ (instancetype)statefulColorWithNormalRef:(SDSColorReference)normalRef highlightedRef:(SDSColorReference)highlightedRef disabledRef:(SDSColorReference)disabledRef {
    SDSStatefulColor *color = [SDSStatefulColor new];
    if (normalRef) {
        color.normal = CUIColorFromHex(normalRef);
    }
    if (highlightedRef) {
        color.highlighted = CUIColorFromHex(highlightedRef);
    }
    if (disabledRef) {
        color.disabled = CUIColorFromHex(disabledRef);
    }

    return color;
}

@end
