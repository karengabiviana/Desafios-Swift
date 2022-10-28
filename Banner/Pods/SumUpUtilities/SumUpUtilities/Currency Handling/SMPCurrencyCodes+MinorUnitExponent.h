//
//  SMPCurrencyCodes+MinorUnitExponent.h
//  SumUpUtilities
//
//  Created by Anuraag Shakya on 12.07.19.
//

#import "SMPCurrencyCodes.h"

/// Returns the minor unit exponent (i.e. number of minor currency digits) for
/// the given ISO 4217 currency code. Fallsback to the more prabable value of 2
/// minor digits in case of invalid currency code input.
NSInteger SMPCurrencyCodesMinorUnitExponentForCurrencyCode(NSString * _Nullable isoCode4217);
