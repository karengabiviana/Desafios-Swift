//
//  CUIDateSelectControlConfiguration.h
//  CircuitUI
//
//  Created by Roman Utrata on 20.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DateSelectControlConfiguration)
@interface CUIDateSelectControlConfiguration: NSObject

/// The minimum date that a date picker can show. By default is nil
@property (nonatomic, nullable, copy) NSDate *minDate;

/// The maximum date that a date picker can show. By default is nil
@property (nonatomic, nullable, copy) NSDate *maxDate;

/// The date format template used to show in selected control. Default is ‘dd MMMM YYYY‘
/// @Note Value is localised depend on the locale.
/// For 'dd MMMM YYYY' => Output:
/// Date format for English (United States): ‘MMMM dd, yyyy‘
/// Date format for English (United Kingdom): ‘dd MMMM yyyy‘
@property (nonatomic, copy) NSString *dateFormatString;

/// The locale to use when display date in date picker and select control. Default is set to NSLocale.currentLocale
@property (nonatomic, copy) NSLocale *locale;

/// The Time Zone to use when display date in date picker and select control. Default is set to NSTimeZone.localTimeZone
@property (nonatomic, copy) NSTimeZone *timeZone;

@end

NS_ASSUME_NONNULL_END
