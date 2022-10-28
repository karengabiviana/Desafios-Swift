//
//  CUIButtonGigaPrimary.h
//  CircuitUI
//
//  Created by Florian Schliep on 01.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIDefaultButton.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Button using the Giga size and Primary variant of Circuit UI Mobile.
 */
NS_SWIFT_NAME(ButtonGigaPrimary)
@interface CUIButtonGigaPrimary : CUIDefaultButton

@property (nonatomic) CUIButtonVariant variant NS_UNAVAILABLE;
@property (nonatomic) CUIButtonSize size NS_UNAVAILABLE;

- (instancetype)initWithVariant:(CUIButtonVariant)variant size:(CUIButtonSize)size NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
