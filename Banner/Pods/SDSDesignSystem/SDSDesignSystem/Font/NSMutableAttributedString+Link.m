//
//  NSMutableAttributedString+Link.m
//  SDSDesignSystem
//
//  Created by Hagi on 09.06.20.
//  Copyright © 2020 SumUp. All rights reserved.
//

#import "NSMutableAttributedString+Link.h"

@implementation NSMutableAttributedString (Link)

- (void)smp_addLink:(NSURL *)link forSubstring:(NSString *)linkText color:(__Color *)highlightColor {
    NSParameterAssert(link);
    NSParameterAssert(linkText.length);
    NSParameterAssert(highlightColor);

    if (!(link && linkText.length && highlightColor)) {
        return;
    }

    NSRange linkRange = [self.string rangeOfString:linkText];
    if ((linkRange.location == NSNotFound) || !linkRange.length) {
        NSAssert(NO, @"%@ is expected to be a substring of %@", linkText, self.string);
        return;
    }

    [self addAttributes:@{
        NSForegroundColorAttributeName: highlightColor,
        NSLinkAttributeName: link,
    } range:linkRange];
}

@end
