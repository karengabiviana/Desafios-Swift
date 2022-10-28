//
//  SMPCurrencyCodes.m
//  SumUpUtilities
//
//  Created by Anuraag Shakya on 12.07.19.
//

#import "SMPCurrencyCodes+MinorUnitExponent.h"

NSString * const SMPCurrencyCodeBGN = @"BGN";
NSString * const SMPCurrencyCodeBRL = @"BRL";
NSString * const SMPCurrencyCodeCHF = @"CHF";
NSString * const SMPCurrencyCodeCLP = @"CLP";
NSString * const SMPCurrencyCodeCOP = @"COP";
NSString * const SMPCurrencyCodeCZK = @"CZK";
NSString * const SMPCurrencyCodeDKK = @"DKK";
NSString * const SMPCurrencyCodeEUR = @"EUR";
NSString * const SMPCurrencyCodeGBP = @"GBP";
NSString * const SMPCurrencyCodeHUF = @"HUF";
NSString * const SMPCurrencyCodeNOK = @"NOK";
NSString * const SMPCurrencyCodePLN = @"PLN";
NSString * const SMPCurrencyCodeRON = @"RON";
NSString * const SMPCurrencyCodeSEK = @"SEK";
NSString * const SMPCurrencyCodeUSD = @"USD";
NSString * const SMPCurrencyCodeHRK = @"HRK";
// Currencies with zero minor unit exponent and not supported by SumUp
NSString * const SMPCurrencyCodeBIF = @"BIF";
NSString * const SMPCurrencyCodeDJF = @"DJF";
NSString * const SMPCurrencyCodeGNF = @"GNF";
NSString * const SMPCurrencyCodeJPY = @"JPY";
NSString * const SMPCurrencyCodeKMF = @"KMF";
NSString * const SMPCurrencyCodeKRW = @"KRW";
NSString * const SMPCurrencyCodeMGA = @"MGA";
NSString * const SMPCurrencyCodePYG = @"PYG";
NSString * const SMPCurrencyCodeRWF = @"RWF";
NSString * const SMPCurrencyCodeUGX = @"UGX";
NSString * const SMPCurrencyCodeVND = @"VND";
NSString * const SMPCurrencyCodeVUV = @"VUV";
NSString * const SMPCurrencyCodeXAF = @"XAF";
NSString * const SMPCurrencyCodeXOF = @"XOF";
NSString * const SMPCurrencyCodeXPF = @"XPF";

NSInteger SMPCurrencyCodesMinorUnitExponentForCurrencyCode(NSString *isoCode4217) {
    NSInteger standardNumberOfDecimatDigits = 2;
    if (!isoCode4217.length) {
        return standardNumberOfDecimatDigits;
    }

    // List of zero decimal currencies as obtained from https://stripe.com/docs/currencies#presentment-currencies
    if ([isoCode4217 isEqualToString:SMPCurrencyCodeCLP] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeBIF] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeDJF] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeGNF] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeJPY] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeKMF] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeKRW] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeMGA] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodePYG] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeRWF] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeUGX] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeVND] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeVUV] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeXAF] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeXOF] ||
        [isoCode4217 isEqualToString:SMPCurrencyCodeXPF]) {
        return 0;
    }

    return standardNumberOfDecimatDigits;
}
