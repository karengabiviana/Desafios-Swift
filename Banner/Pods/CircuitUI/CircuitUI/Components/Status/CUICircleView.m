//
//  CUICircleView.m
//  CircuitUI
//
//  Created by Victor Kachalov on 17.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUICircleView.h"

@implementation CUICircleView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self.widthAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
    self.layer.masksToBounds = YES;
}

@end
