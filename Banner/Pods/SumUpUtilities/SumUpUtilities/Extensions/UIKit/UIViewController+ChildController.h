//
//  UIViewController+ChildController.h
//  Cashier
//
//  Created by Hagi on 10/02/2017.
//  Copyright © 2017 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ChildController)

- (void)smp_addChildViewController:(UIViewController *)controller in:(UIView *)containerView NS_SWIFT_NAME(addChildViewController(_:in:));

- (void)smp_removeAllChildViewControllers NS_SWIFT_NAME(removeAllChildViewControllers());

- (void)smp_removeChildViewController:(UIViewController *)controller NS_SWIFT_NAME(removeChildViewController(_:));

@end

NS_ASSUME_NONNULL_END
