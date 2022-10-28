//
//  CUIColorHelpers.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 25.02.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

static inline CGFloat CUIColorComponentFromString(NSString * _Nonnull string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = (length == 2) ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned long long hexComponent;
    [[NSScanner scannerWithString:fullHex ? : @""] scanHexLongLong:&hexComponent];
    return hexComponent / 255.0;
}

static inline UIColor * _Nullable CUIColorFromHex(NSString * _Nullable hexString) {
    if (!hexString.length) {
        return nil;
    }

    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;

    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = CUIColorComponentFromString(colorString, 0, 1);
            green = CUIColorComponentFromString(colorString, 1, 1);
            blue  = CUIColorComponentFromString(colorString, 2, 1);
            break;

        case 4: // #ARGB
            alpha = CUIColorComponentFromString(colorString, 0, 1);
            red   = CUIColorComponentFromString(colorString, 1, 1);
            green = CUIColorComponentFromString(colorString, 2, 1);
            blue  = CUIColorComponentFromString(colorString, 3, 1);
            break;

        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = CUIColorComponentFromString(colorString, 0, 2);
            green = CUIColorComponentFromString(colorString, 2, 2);
            blue  = CUIColorComponentFromString(colorString, 4, 2);
            break;

        case 8: // #AARRGGBB
            alpha = CUIColorComponentFromString(colorString, 0, 2);
            red   = CUIColorComponentFromString(colorString, 2, 2);
            green = CUIColorComponentFromString(colorString, 4, 2);
            blue  = CUIColorComponentFromString(colorString, 6, 2);
            break;

        default:
            return nil;
    }

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

static inline NSString * _Nonnull CUIColorAddAlphaComponentToHex(NSString * _Nonnull hex, NSInteger alpha) {
    // bound percent from 0 to 100
    NSInteger percent = MAX(0, MIN(100, alpha));
    // map percent to nearest integer (0 - 255)
    unsigned long hexComponent = lround((double)percent/100. * 255.);
    // get 2-letter hexadecimal representation and append hex
    return [NSString stringWithFormat:@"%02lX%@", hexComponent, hex];
}
