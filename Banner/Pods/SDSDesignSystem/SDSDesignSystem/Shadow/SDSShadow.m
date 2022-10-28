//
//  SDSShadow.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 25.07.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSShadow+Private.h"

@implementation SDSShadow

#if TARGET_OS_IOS
- (UIEdgeInsets)coveredMarginForState:(UIControlState)state {
    CGFloat borderWidth = [self.borderWidth valueForState:state].doubleValue;
    CGFloat radius = [self.blurRadius valueForState:state].doubleValue;
    CGFloat spread = [self.spread valueForState:state].doubleValue;
    CGFloat offsetY = [self.offsetY valueForState:state].doubleValue;
    CGFloat offsetX = [self.offsetX valueForState:state].doubleValue;
    CGFloat base = borderWidth + radius + spread;
    return UIEdgeInsetsMake(MAX(base - offsetY, borderWidth),
                            MAX(base - offsetX, borderWidth),
                            MAX(base + offsetY, borderWidth),
                            MAX(base + offsetX, borderWidth));
}
#endif

@end
