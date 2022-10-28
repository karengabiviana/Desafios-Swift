//
//  SDSIncreasedTapTargetStyledButton.m
//  SDSDesignSystem
//
//  Created by Florian Schliep on 03.08.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSIncreasedTapTargetStyledButton.h"

static inline UIEdgeInsets SDSEdgeInsetsInvert(UIEdgeInsets insets) {
    return UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
}

@implementation SDSIncreasedTapTargetStyledButton

- (void)commonInit {
    [super commonInit];
    _extendedTapTargetInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect extendedRect = UIEdgeInsetsInsetRect(self.bounds, SDSEdgeInsetsInvert(self.extendedTapTargetInsets));
    if (CGRectContainsPoint(extendedRect, point)) {
        return YES;
    }

    return [super pointInside:point withEvent:event];
}

@end
