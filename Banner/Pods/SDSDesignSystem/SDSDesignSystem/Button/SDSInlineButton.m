//
//  SDSInlineButton.m
//  SDSDesignSystem
//
//  Created by Florian Schliep on 25.07.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSInlineButton.h"
#import "SDSShadowView.h"

@implementation SDSInlineButton

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateCornerRadius];
}

- (void)updateForControlState:(UIControlState)controlState {
    [super updateForControlState:controlState];
    [self updateCornerRadius];
}

- (void)updateCornerRadius {
    self.backgroundView.cornerRadius = CGRectGetHeight(self.bounds)/2.0;
}

@end
