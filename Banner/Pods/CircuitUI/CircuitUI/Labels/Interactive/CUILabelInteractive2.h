//
//  CUILabelInteractive2.h
//  SDSDesignSystem
//
//  Created by Illia Lukisha on 19/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import <CircuitUI/CUILabel.h>
#import <CircuitUI/CUILabelInteractiveVariant.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Label implementing the Interactive-label-2 style of Circuit UI Mobile.
 * Modify the `variant` property to use the different variants of the Interactive-label-2 style.
 */
NS_SWIFT_NAME(LabelInteractive2)
@interface CUILabelInteractive2 : CUILabel

@property (nonatomic) CUILabelInteractiveVariant variant;

@end

NS_ASSUME_NONNULL_END
