//
//  NSLocale+Currency.h
//  SumUpUtilities
//
//  Created by Lukas Mollidor on 2017-09-08.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLocale (Currency)

/// @return A currency symbol for user-facing output, based on the currently set currency code.
/// Should be preferred over `currencySymbol` as it contains improved output for certain currencies
/// where the system defaults are not suitable. Should only return `nil` if the locale was not
/// configured correctly.
@property (nonatomic, nullable, readonly) NSString *smp_currencySymbol;

/// @return A custom currency symbol for the given currency code in case we prefer a non-system currency
/// symbol for that currency. Returns `nil` if the system default is suitable.
+ (nullable NSString *)smp_customCurrencySymbolForCode:(NSString *)currencyCode;

/// returns a new locale object where NSLocaleCurrencyCode and NSLocaleCountryCode are enforced to given values if not nil and valid.
/// if not valid NSLocale fallbacks take precedende. e.g. setting FR as country code will set EUR unless valid currency code is provided. 
- (NSLocale *)localeByEnforcingCurrencyCode:(nullable NSString *)currencyCode countryCode:(nullable NSString *)countryCode;

@end

NS_ASSUME_NONNULL_END
