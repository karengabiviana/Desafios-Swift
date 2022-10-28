//
//  CUIStatusVariantColors.h
//  CircuitUI
//
//  Created by Hagi on 05.10.2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;
#import "CUIStatusVariant.h"

/**
 *  Returns a color with a high contrast, relative to the variant's
 *  tint color, to be used for text or iconography which is rendered
 *  on top of tinted views.
 */
extern UIColor * CUIContrastColorFromStatusVariant(CUIStatusVariant);

/**
 *  Returns the tint color for a given status variant, typically
 *  used for backgrounds and other view chrome.
 */
extern UIColor * CUITintColorFromStatusVariant(CUIStatusVariant variant);
