//
//  SDSButtonStyleConfiguration.m
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "SDSButtonStyleConfiguration+Private.h"
#import "SDSStatefulColor.h"
#import "SDSTextStyleConfiguration.h"

@implementation SDSButtonStyleConfiguration

+ (instancetype)buttonStyleConfigurationWithTextStyleConfiguration:(SDSTextStyleConfiguration *)textStyle {
    SDSButtonStyleConfiguration *config = [self new];
    config.textStyle = textStyle;
    config.backgroundColor = [textStyle.colors strictColorForUsage:SDSStatefulColorUsageBackground];
    config.statefulTintColor = [textStyle.colors strictColorForUsage:SDSStatefulColorUsageTint];
    config.borderColor = [textStyle.colors strictColorForUsage:SDSStatefulColorUsageBorder];
    config.imageColor = [textStyle.colors strictColorForUsage:SDSStatefulColorUsageImage] ?: textStyle.textColor;
    return config;
}

- (__Color *)tintColor {
    return self.textStyle.textColor.normal;
}

@end
