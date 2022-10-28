//
//  UIView+SDSStatefulColor.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 11.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "UIView+SDSStatefulColor.h"

@implementation UIView (SDSStatefulColor)

- (void)sds_applyBackgroundColorStyle:(SDSColorStyle)style NS_SWIFT_NAME(apply(backgroundColorStyle:)) {
    [self sds_applyBackgroundColorStyle:style fromStyleSheet:[SDSStyleSheet global]];
}

- (void)sds_applyBackgroundColorStyle:(SDSTextStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet {
    self.backgroundColor = [[[styleSheet colorSetForStyle:style] colorForUsage:SDSStatefulColorUsageBackground] normal];
}

- (void)sds_applyBorderColorStyle:(SDSColorStyle)style {
    [self sds_applyBorderColorStyle:style fromStyleSheet:[SDSStyleSheet global]];
}

- (void)sds_applyBorderColorStyle:(SDSColorStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet {
    self.layer.borderColor = [[[styleSheet colorSetForStyle:style] colorForUsage:SDSStatefulColorUsageBorder] normal].CGColor;
}

@end
