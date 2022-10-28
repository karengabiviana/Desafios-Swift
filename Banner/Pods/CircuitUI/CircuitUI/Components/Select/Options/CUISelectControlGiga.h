//
//  CUISelectControlGiga.h
//  CircuitUI
//
//  Created by Marcel Voß on 07.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

#import "CUISelectControl.h"

NS_ASSUME_NONNULL_BEGIN

/// A select picker in its giga size.
NS_SWIFT_NAME(SelectControlGiga)
@interface CUISelectControlGiga: CUISelectControl

@property (nonatomic) CUISelectControlSize size UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
