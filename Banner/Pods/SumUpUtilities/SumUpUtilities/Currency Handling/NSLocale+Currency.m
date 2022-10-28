//
//  NSLocale+Currency.m
//  SumUpUtilities
//
//  Created by Lukas Mollidor on 2017-09-08.
//
//

#import "NSLocale+Currency.h"
#import "SMPCurrencyCodes.h"

@implementation NSLocale (Currency)

+ (NSString *)smp_customCurrencySymbolForCode:(NSString *)currencyCode {
    NSParameterAssert(currencyCode);

    if (!currencyCode.length) {
        return nil;
    }

    if ([currencyCode isEqualToString:SMPCurrencyCodeHUF]) {
        return @"Ft";
    } else if ([currencyCode isEqualToString:SMPCurrencyCodeHRK]) {
        return @"kn";
    }

    return nil;
}

- (NSString *)smp_currencySymbol {
    NSString *customSymbol = [[self class] smp_customCurrencySymbolForCode:self.currencyCode];
    if (customSymbol.length) {
        return customSymbol;
    }

    return self.currencySymbol;
}

- (NSLocale *)localeByEnforcingCurrencyCode:(NSString *)currencyCode countryCode:(NSString *)countryCode {
    currencyCode = [currencyCode uppercaseString];
    countryCode = [countryCode uppercaseString];

    NSMutableDictionary *comps = [[NSLocale componentsFromLocaleIdentifier:self.localeIdentifier] mutableCopy];

    if ((currencyCode.length == 3) && ![[self objectForKey:NSLocaleCurrencyCode] isEqualToString:currencyCode]) {
        comps[NSLocaleCurrencyCode] = currencyCode;
    }

    if ((countryCode.length == 2) && ![[self objectForKey:NSLocaleCountryCode] isEqualToString:countryCode]) {
        comps[NSLocaleCountryCode] = countryCode;
    }

    return [NSLocale localeWithLocaleIdentifier:[NSLocale localeIdentifierFromComponents:comps]];
}

@end
