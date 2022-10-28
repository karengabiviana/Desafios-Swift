//
//  CUILabelBody1.m
//  CircuitUI
//
//  Created by Florian Schliep on 12.02.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelBody1.h"
#import "CUILabel+Private.h"

@implementation CUILabelBody1

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateBody1(self.variant, self.isStrikethrough);
}

- (CGFloat)cui_lineSpacing {
    return 4;
}

- (BOOL)cui_isStrikethrough {
    return self.isStrikethrough;
}

- (void)setStrikethrough:(BOOL)strikethrough {
    if (!strikethrough == !_strikethrough) {
        return;
    }

    _strikethrough = strikethrough;
    [self cui_updateTextStyle];
    [self cui_updateParagraphStyle];
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
