//
//  SMPNumberFormatter.m
//  SumUpUtilities
//
//  Created by Lukas Mollidor on 01.09.17.
//  Copyright © 2017 SumUp. All rights reserved.
//

#import "SMPNumberFormatter.h"
#import "NSLocale+Currency.h"
#import "SMPCurrencyCodes.h"

@implementation SMPNumberFormatter

+ (SMPNumberFormatter *)currencyFormatter {
    SMPNumberFormatter *nf = [self new];

    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];

    return nf;
}

- (void)setLocale:(NSLocale *)locale {
    [super setLocale:locale];
    [self enforceFormatting];
}

- (void)setCurrencyCode:(NSString *)currencyCode {
    [super setCurrencyCode:currencyCode];
    [self enforceFormatting];
    NSAssert(NO, @"Do not change the currency code. Set via a preconfgured locale.");
}

- (void)enforceFormatting {
    if (self.numberStyle != NSNumberFormatterCurrencyStyle) {
        return;
    }

    NSString *currencyCode = self.currencyCode;

    if ([currencyCode isEqualToString:SMPCurrencyCodeHUF] ||
        [currencyCode isEqualToString:SMPCurrencyCodeCOP]) {
        // enforce digits different from iOS defaults
        [self setMaximumFractionDigits:0];
    }

    // currencySymbol is null_resettable, reset if not customized
    // (smp_customCurrencySymbolForCode returns an optional)
    NSString *newSymbol = [NSLocale smp_customCurrencySymbolForCode:currencyCode];

    // set to dedicated new symbol or reset to defaults unless someone has set it to an empty string.
    if (![self.currencySymbol isEqualToString:@""]) {
        [self setCurrencySymbol:newSymbol];
    }
}

@end
