//
//  CUIStatusPill.m
//  CircuitUI
//
//  Created by Igor Gorodnikov on 07.06.2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIStatusPill.h"
#import "CUILabel+Private.h"
#import "CUIColorRef.h"
#import "CUIColorHelpers.h"
#import "CUISpacing.h"

@implementation CUIStatusPill

- (CGSize) intrinsicContentSize {
    CGSize extendedContentSize = [super intrinsicContentSize];
    CGFloat topInset = CUISpacingNano;
    CGFloat leftInset = CUISpacingByte;
    CGFloat bottomInset = CUISpacingNano;
    CGFloat rightInset = CUISpacingByte;

    extendedContentSize.height += topInset + bottomInset;
    extendedContentSize.width += leftInset + rightInset;
    return extendedContentSize;
}

@end
