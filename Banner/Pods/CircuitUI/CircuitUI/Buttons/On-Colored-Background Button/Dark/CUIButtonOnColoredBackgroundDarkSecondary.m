//
//  CUIButtonOnColoredBackgroundDarkSecondary.m
//  CircuitUI
//
//  Created by Florian Schliep on 05.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButtonOnColoredBackgroundDarkSecondary.h"

@implementation CUIButtonOnColoredBackgroundDarkSecondary

@dynamic variant;
@dynamic appearance;

- (CUIButtonVariant)variant {
    return CUIButtonVariantSecondary;
}

- (CUIButtonOnColoredBackgroundAppearance)appearance {
    return CUIButtonOnColoredBackgroundAppearanceDark;
}
@end
