//
//  UIActivityIndicatorView+SDSStatefulColor.m
//  SDSDesignSystem
//
//  Created by Hagi on 28.10.19.
//  Copyright © 2019 SumUp. All rights reserved.
//

#import "UIActivityIndicatorView+SDSStatefulColor.h"

@implementation UIActivityIndicatorView (SDSStatefulColor)

- (void)sds_applyColorStyle:(SDSColorStyle)style {
    [self sds_applyColorStyle:style inverted:NO];
}

- (void)sds_applyColorStyle:(SDSColorStyle)style inverted:(BOOL)inverted {
    [self sds_applyColorStyle:style inverted:inverted fromStyleSheet:[SDSStyleSheet global]];
}

- (void)sds_applyColorStyle:(SDSColorStyle)style inverted:(BOOL)inverted fromStyleSheet:(SDSStyleSheet *)styleSheet {
    self.color = [[[styleSheet colorSetForStyle:style] colorForUsage:SDSStatefulColorUsageForeground] valueForState:UIControlStateNormal inverted:inverted];
}

@end
