//
//  UIView+AutoLayout.m
//  SumUpUtilities
//
//  Created by Florian Schliep on 16.05.18.
//  Copyright © 2018 SumUp Services GmbH. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (SMPAutoLayout)

- (void)smp_addSubview:(UIView *)view withConstraints:(NSArray<NSLayoutConstraint *> *)constraints {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
