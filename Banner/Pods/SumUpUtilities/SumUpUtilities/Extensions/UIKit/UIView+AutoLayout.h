//
//  UIView+AutoLayout.h
//  SumUpUtilities
//
//  Created by Florian Schliep on 16.05.18.
//  Copyright © 2018 SumUp Services GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SMPAutoLayout)

- (void)smp_addSubview:(UIView *)view withConstraints:(NSArray<NSLayoutConstraint *> *)constraints NS_SWIFT_NAME(addSubview(_:with:));

@end

NS_ASSUME_NONNULL_END
