//
//  CUILabelHeadline1.h
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabel.h"
#import "CUILabelHeadlineVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Label implementing the Headline-1 style of Circuit UI Mobile.
 */
NS_SWIFT_NAME(LabelHeadline1)
@interface CUILabelHeadline1 : CUILabel

@property (nonatomic) CUILabelHeadlineVariant variant;

@end

NS_ASSUME_NONNULL_END
