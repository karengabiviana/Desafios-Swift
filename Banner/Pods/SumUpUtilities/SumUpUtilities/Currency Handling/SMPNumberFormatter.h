//
//  SMPNumberFormatter.h
//  SumUpUtilities
//
//  Created by Lukas Mollidor on 01.09.17.
//  Copyright © 2017 SumUp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A sublcass of NSNumberFormatter enforcing some currency formatting differences.
 *  Avoid re-configuring instances. Do not change currency codes or locales back and forth.
 *  When in doubt, create a new instance.
 */
@interface SMPNumberFormatter : NSNumberFormatter

/**
 *  A new instance of SMPNumberFormatter configured to .CurrencyStyle.
 *
 *  @return a new formatter to display numbers formatted in .CurrencyStyle
 */
+ (SMPNumberFormatter *)currencyFormatter;

// Do not set. Set via preconfigured locale.
- (void)setCurrencyCode:(NSString *_Nullable)currencyCode NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
