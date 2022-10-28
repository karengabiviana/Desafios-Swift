//
//  UIView+Scalars.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 10.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "UIView+Scalars.h"

@implementation UIView (Scalars)

- (void)sds_applyTintColor:(SDSColorStyle)color {
    [self sds_applyTintColor:color fromStyleSheet:[SDSStyleSheet global]];
}

- (void)sds_applyTintColor:(SDSColorStyle)color fromStyleSheet:(SDSStyleSheet *)sheet {
    self.tintColor = [[sheet colorSetForStyle:color] colorForUsage:SDSStatefulColorUsageTint].normal;
}

@end
