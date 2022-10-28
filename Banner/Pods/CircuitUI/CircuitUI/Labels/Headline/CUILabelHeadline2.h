//
//  CUILabelHeadline2.h
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabel.h"
#import "CUILabelHeadlineVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Label implementing the Headline-2 style of Circuit UI Mobile.
 */
NS_SWIFT_NAME(LabelHeadline2)
@interface CUILabelHeadline2 : CUILabel

@property (nonatomic) CUILabelHeadlineVariant variant;

@end

NS_ASSUME_NONNULL_END
