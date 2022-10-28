//
//  SDSIncreasedTapTargetStyledButton.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 03.08.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSIncreasedTapTargetStyledButton_h
#define SDSIncreasedTapTargetStyledButton_h

#import <UIKit/UIKit.h>
#import "SDSStyledButton.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This class increases the tappable area around the button while still keeping its intrinsic content size,
 *  thus not affecting the layout of its superview.
 */
NS_SWIFT_NAME(IncreasedTapTargetStyledButton)
@interface SDSIncreasedTapTargetStyledButton : SDSStyledButton

/// The inset will increase the tap target around the bounds, positive values extend it.
@property (nonatomic) UIEdgeInsets extendedTapTargetInsets;

@end

NS_ASSUME_NONNULL_END

#endif
