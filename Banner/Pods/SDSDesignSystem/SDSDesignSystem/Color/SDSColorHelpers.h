//
//  SDSColorHelpers.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSColorHelpers_h
#define SDSColorHelpers_h

#import "SDSDesignPlatform.h"

#pragma mark Color Helpers

static inline CGFloat colorComponentFromString(NSString * _Nonnull string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = (length == 2) ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned long long hexComponent;
    [[NSScanner scannerWithString:fullHex ? : @""] scanHexLongLong:&hexComponent];
    return hexComponent / 255.0;
}

static inline __Color * _Nullable colorFromHex(NSString * _Nullable hexString) {
    if (!hexString.length) {
        return nil;
    }

    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;

    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = colorComponentFromString(colorString, 0, 1);
            green = colorComponentFromString(colorString, 1, 1);
            blue  = colorComponentFromString(colorString, 2, 1);
            break;

        case 4: // #ARGB
            alpha = colorComponentFromString(colorString, 0, 1);
            red   = colorComponentFromString(colorString, 1, 1);
            green = colorComponentFromString(colorString, 2, 1);
            blue  = colorComponentFromString(colorString, 3, 1);
            break;

        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = colorComponentFromString(colorString, 0, 2);
            green = colorComponentFromString(colorString, 2, 2);
            blue  = colorComponentFromString(colorString, 4, 2);
            break;

        case 8: // #AARRGGBB
            alpha = colorComponentFromString(colorString, 0, 2);
            red   = colorComponentFromString(colorString, 2, 2);
            green = colorComponentFromString(colorString, 4, 2);
            blue  = colorComponentFromString(colorString, 6, 2);
            break;

        default:
            return nil;
    }

    return [__Color colorWithRed:red green:green blue:blue alpha:alpha];
}

#endif /* SDSColorHelpers_h */
