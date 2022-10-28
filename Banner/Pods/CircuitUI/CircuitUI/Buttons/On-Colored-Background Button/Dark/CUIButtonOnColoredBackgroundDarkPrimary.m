//
//  CUIButtonOnColoredBackgroundDarkPrimary.m
//  CircuitUI
//
//  Created by Florian Schliep on 05.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButtonOnColoredBackgroundDarkPrimary.h"

@implementation CUIButtonOnColoredBackgroundDarkPrimary

@dynamic variant;
@dynamic appearance;

- (CUIButtonVariant)variant {
    return CUIButtonVariantPrimary;
}

- (CUIButtonOnColoredBackgroundAppearance)appearance {
    return CUIButtonOnColoredBackgroundAppearanceDark;
}

@end
