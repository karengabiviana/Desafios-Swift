//
//  CUITextStyle.h
//  CircuitUI
//
//  Created by Florian Schliep on 20.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;
@import SDSDesignSystem.SDSStyleSheet;
@import SDSDesignSystem.SDSTextStyleConfiguration;

#import "CUILabelHeadlineVariant.h"
#import "CUILabelBodyVariant.h"
#import "CUILabelInteractiveVariant.h"
#import "CUIStatusVariant.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Large Amount

extern SDSTextStyleConfiguration *CUITextStyleCreateLargeAmount(BOOL strikethrough);

#pragma mark - Headline

extern SDSTextStyleConfiguration *CUITextStyleCreateHeadline1(CUILabelHeadlineVariant variant);
extern SDSTextStyleConfiguration *CUITextStyleCreateHeadline2(CUILabelHeadlineVariant variant);
extern SDSTextStyleConfiguration *CUITextStyleCreateHeadline3(void);
extern SDSTextStyleConfiguration *CUITextStyleCreateHeadline4(void);

#pragma mark - Subheadline

extern SDSTextStyleConfiguration *CUITextStyleCreateSubheadline(void);

#pragma mark - Body

extern SDSTextStyleConfiguration *CUITextStyleCreateBody1(CUILabelBodyVariant variant, BOOL strikethrough);
extern SDSTextStyleConfiguration *CUITextStyleCreateBody2(CUILabelBodyVariant variant);

#pragma mark - Interactive

extern SDSTextStyleConfiguration *CUITextStyleCreateInteractive1(CUILabelInteractiveVariant variant);
extern SDSTextStyleConfiguration *CUITextStyleCreateInteractive2(CUILabelInteractiveVariant variant);

#pragma mark - Status

extern SDSColorReference CUITextColorStatusComponent(CUIStatusVariant variant);
extern SDSTextStyleConfiguration *CUITextStyleCreateStatusComponent(CUIStatusVariant variant);

NS_ASSUME_NONNULL_END
