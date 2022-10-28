//
//  CUIButtonOnColoredBackground.m
//  CircuitUI
//
//  Created by Florian Schliep on 05.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButtonOnColoredBackground.h"
#import "CUIButton+Private.h"
#import "CUIButtonStyle.h"

@implementation CUIButtonOnColoredBackground

@dynamic destructive;

- (instancetype)initWithVariant:(CUIButtonVariant)variant appearance:(CUIButtonOnColoredBackgroundAppearance)appearance {
    self = [super init];
    if (self) {
        _variant = [self validateVariantAndFixIfNeeded:variant];
        _appearance = appearance;
    }

    return self;
}

- (SDSButtonStyleConfiguration *)createButtonStyleConfiguration {
    SDSButtonStyleConfiguration *config = [SDSButtonStyleConfiguration buttonStyleConfigurationWithTextStyleConfiguration:CUIButtonOnColoredBackgroundStyleCreateTextStyle(self.variant, self.appearance)];
    config.minimumHeight = [SDSStatefulScalar statefulScalarWithValue:@(CUIButtonStyleMinHeight(CUIButtonSizeGiga))];
    config.paddingHorizontal = [SDSStatefulScalar statefulScalarWithValue:@(CUIButtonStyleHorizontalPadding(CUIButtonSizeGiga, self.variant, self.hasTitleInCurrentState))];
    config.borderWidth = [SDSStatefulScalar statefulScalarWithValue:@(CUIButtonStyleBorderWidth(self.variant))];

    return config;
}

- (void)setVariant:(CUIButtonVariant)variant {
    _variant = [self validateVariantAndFixIfNeeded:variant];
    [self reloadButtonStyle];
}

- (void)setAppearance:(CUIButtonOnColoredBackgroundAppearance)appearance {
    _appearance = appearance;
    [self reloadButtonStyle];
}

- (CUIButtonVariant)validateVariantAndFixIfNeeded:(CUIButtonVariant)variant {
    switch (variant) {
        case CUIButtonVariantTertiary: {
            NSAssert(NO, @"CUIButtonOnColoredBackground does not support CUIButtonVariantTertiary");
            return CUIButtonVariantPrimary;
        }
        case CUIButtonVariantPrimary:
        case CUIButtonVariantSecondary:
            break;
    }

    return variant;
}

@end
