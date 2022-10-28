//
//  UIImage+Resources.h
//  CircuitUI
//
//  Created by Lucien Doellinger on 11/08/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "UIImage+Country.h"
#import "UIImage+Resources+Private.h"

@implementation UIImage (Country)

+ (nullable UIImage *)cui_countryFlagFromCode:(NSString *)countryCode {
    NSAssert([countryCode isKindOfClass:[NSString class]], @"countryCode must be a String.");

    if (![NSLocale.ISOCountryCodes containsObject:[countryCode uppercaseString]]) {
        return nil;
    }

    NSString *imageName = [NSString stringWithFormat:@"flag_%@_16", [countryCode lowercaseString]];
    return [UIImage cui_imageNamed:imageName];
}

@end
