//
//  CUISemanticColor.m
//  CircuitUI
//
//  Created by Florian Schliep on 20.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISemanticColor.h"
#import "CUIColorRef.h"
#import "CUIColorHelpers.h"

@implementation CUISemanticColor

+ (UIColor *)tintColor {
    return CUIColorFromHex(CUIColorRefB70);
}

+ (UIColor *)bodyColor {
    return CUIColorFromHex(CUIColorRefN100);
}

+ (UIColor *)confirmColor {
    return CUIColorFromHex(CUISemanticColorRefConfirm);
}

+ (UIColor *)alertColor {
    return CUIColorFromHex(CUISemanticColorRefAlert);
}

+ (UIColor *)notifyColor {
    return CUIColorFromHex(CUIColorRefY80);
}

+ (UIColor *)backgroundColor {
    return CUIColorFromHex(CUIColorRefN0);
}

+ (UIColor *)overlayColor {
    return [CUIColorFromHex(CUIColorRefN100) colorWithAlphaComponent:0.4];
}

@end
