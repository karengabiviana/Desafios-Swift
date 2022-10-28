//
//  CUIButtonOnColoredBackgroundDarkPrimary.h
//  CircuitUI
//
//  Created by Florian Schliep on 05.03.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButtonOnColoredBackground.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Button to be used on colored backgrounds only, using the Dark appearance and Primary variant of Circuit UI Mobile.
 */
NS_SWIFT_NAME(ButtonOnColoredBackgroundDarkPrimary)
@interface CUIButtonOnColoredBackgroundDarkPrimary : CUIButtonOnColoredBackground

@property (nonatomic) CUIButtonVariant variant NS_UNAVAILABLE;
@property (nonatomic) CUIButtonOnColoredBackgroundAppearance appearance NS_UNAVAILABLE;

- (instancetype)initWithVariant:(CUIButtonVariant)variant appearance:(CUIButtonOnColoredBackgroundAppearance)appearance NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
