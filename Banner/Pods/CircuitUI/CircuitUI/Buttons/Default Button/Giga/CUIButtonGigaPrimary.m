//
//  CUIButtonGigaPrimary.m
//  CircuitUI
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButtonGigaPrimary.h"

@implementation CUIButtonGigaPrimary

@dynamic size;
@dynamic variant;

- (CUIButtonSize)size {
    return CUIButtonSizeGiga;
}

- (CUIButtonVariant)variant {
    return CUIButtonVariantPrimary;
}

@end
