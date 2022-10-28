//
//  CUIDateSelectControlKilo.h
//  CircuitUI
//
//  Created by Roman Utrata on 20.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

@import UIKit;

#import "CUIDateSelectControl.h"

NS_ASSUME_NONNULL_BEGIN

/// A date select picker in its kilo size.
NS_SWIFT_NAME(DateSelectControlKilo)
@interface CUIDateSelectControlKilo: CUIDateSelectControl

@property (nonatomic) CUISelectControlSize size NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
