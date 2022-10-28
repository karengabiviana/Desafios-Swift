//
//  CUIDateSelectControlGiga.h
//  CircuitUI
//
//  Created by Roman Utrata on 19.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

@import UIKit;

#import "CUIDateSelectControl.h"

NS_ASSUME_NONNULL_BEGIN

/// A date select picker in its giga size.
NS_SWIFT_NAME(DateSelectControlGiga)
@interface CUIDateSelectControlGiga: CUIDateSelectControl

@property (nonatomic) CUISelectControlSize size UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
