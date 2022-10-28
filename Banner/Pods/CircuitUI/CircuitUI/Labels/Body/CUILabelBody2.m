//
//  CUILabelBody2.m
//  CircuitUI
//
//  Created by Florian Schliep on 12.02.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelBody2.h"
#import "CUILabel+Private.h"

@implementation CUILabelBody2

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateBody2(self.variant);
}

- (CGFloat)cui_lineSpacing {
    return 3;
}

- (void)setVariant:(CUILabelBodyVariant)variant {
    _variant = variant;
    [self cui_updateTextStyle];

    if (!CUILabelBodyVariantSupportsLinks(variant)) {
        [self cui_updateParagraphStyle];
    }
}

- (void)addLinkWithURL:(NSURL *)url toSubstring:(NSString *)substring {
    [self addLinkWithURL:url toSubstring:substring onOpenURL:nil];
}

- (void)addLinkWithURL:(NSURL *)url toSubstring:(NSString *)substring onOpenURL:(nullable CUIURLCompletion)onOpenURL {
    if (!CUILabelBodyVariantSupportsLinks(self.variant)) {
        NSAssert(NO, @"Cannot add link to label with variant: %@", @(self.variant));
        return;
    }

    [self cui_addLinkWithURL:url toSubstring:substring onOpenURL:onOpenURL];
}

- (void)addLinkWithURL:(NSURL *)url toSubstringWithRange:(NSRange)range {
    [self addLinkWithURL:url toSubstringWithRange:range onOpenURL:nil];
}

- (void)addLinkWithURL:(NSURL *)url toSubstringWithRange:(NSRange)range onOpenURL:(nullable CUIURLCompletion)onOpenURL {
    if (!CUILabelBodyVariantSupportsLinks(self.variant)) {
        NSAssert(NO, @"Cannot add link to label with variant: %@", @(self.variant));
        return;
    }

    [self cui_addLinkWithURL:url toSubstringWithRange:range onOpenURL:onOpenURL];
}

@end
