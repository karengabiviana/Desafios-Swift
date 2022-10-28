//
//  CUIStatusBadge.m
//  CircuitUI
//
//  Created by Igor Gorodnikov on 20.08.2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIStatusBadge.h"
#import "CUILabel+Private.h"
#import "CUIColorRef.h"
#import "CUIColorHelpers.h"
#import "CUISpacing.h"

@implementation CUIStatusBadge

- (CGSize) intrinsicContentSize {
    return ([self.text length] == 1) ? [self singleSymbolIntrinsicContentSize] : [self defaultIntrinsicContentSize];
}

- (CGSize) singleSymbolIntrinsicContentSize {
    CGSize extendedContentSize = [super intrinsicContentSize];
    CGFloat topInset = CUISpacingNano;
    CGFloat bottomInset = CUISpacingNano;

    extendedContentSize.height += topInset + bottomInset;
    extendedContentSize.width = extendedContentSize.height;
    return extendedContentSize;
}

- (CGSize) defaultIntrinsicContentSize {
    CGSize extendedContentSize = [super intrinsicContentSize];
    CGFloat topInset = CUISpacingNano;
    CGFloat leftInset = CUISpacingBit;
    CGFloat bottomInset = CUISpacingNano;
    CGFloat rightInset = CUISpacingBit;

    extendedContentSize.height += topInset + bottomInset;
    extendedContentSize.width += leftInset + rightInset;
    return extendedContentSize;
}

@end
