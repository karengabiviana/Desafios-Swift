//
//  CUIButtonStyle.h
//  CircuitUI
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;
@import SDSDesignSystem.SDSButtonStyleConfiguration;

#import "CUIButtonVariant.h"
#import "CUIButtonOnColoredBackgroundAppearance.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat CUIButtonStyleInnerPadding = 8.;

extern CGFloat CUIButtonStyleMinHeight(CUIButtonSize size);
extern CGFloat CUIButtonStyleHorizontalPadding(CUIButtonSize size, CUIButtonVariant variant, BOOL hasText);
extern CGFloat CUIButtonStyleBorderWidth(CUIButtonVariant variant);

extern SDSTextStyleConfiguration *CUIButtonDefaultStyleCreateTextStyle(CUIButtonVariant variant, BOOL isDestructive);
extern SDSTextStyleConfiguration *CUIButtonOnColoredBackgroundStyleCreateTextStyle(CUIButtonVariant variant, CUIButtonOnColoredBackgroundAppearance appearance);
extern SDSTextStyleConfiguration *CTATextStyleGiga(void);
extern SDSTextStyleConfiguration *CTATextStyleKilo(void);

NS_ASSUME_NONNULL_END
