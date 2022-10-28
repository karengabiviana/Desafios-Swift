//
//  CUIButtonGigaSecondary.m
//  CircuitUI
//
//  Created by Florian Schliep on 02.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButtonGigaSecondary.h"
#import "CUIButton+Private.h"

@implementation CUIButtonGigaSecondary

@dynamic size;
@dynamic variant;

- (CUIButtonSize)size {
    return CUIButtonSizeGiga;
}

- (CUIButtonVariant)variant {
    return CUIButtonVariantSecondary;
}

@end
