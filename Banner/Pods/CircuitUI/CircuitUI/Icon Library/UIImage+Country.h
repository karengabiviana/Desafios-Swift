//
//  UIImage+Resources.h
//  CircuitUI
//
//  Created by Lucien Doellinger on 11/08/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

@import UIKit.UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Country)

/**
 Retrieve a country flag image from a country code.
 @param countryCode ISO 3166-1 alpha-2 country code.
 @return The flag image or nil if an image is not available for the specified country.
 */
+ (nullable UIImage *)cui_countryFlagFromCode:(NSString *)countryCode;

@end

NS_ASSUME_NONNULL_END
