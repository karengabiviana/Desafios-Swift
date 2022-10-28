//
//  UIViewController+ChildController.m
//  Cashier
//
//  Created by Hagi on 10/02/2017.
//  Copyright © 2017 iosphere GmbH. All rights reserved.
//

#import "UIViewController+ChildController.h"
#import "NSLayoutConstraint+SMPAdditions.h"

@implementation UIViewController (ChildController)

- (void)smp_addChildViewController:(UIViewController *)controller in:(UIView *)containerView {
    NSParameterAssert(controller);
    NSParameterAssert(containerView);

    if (!controller || !containerView) {
        return;
    }

    [self addChildViewController:controller];

    controller.view.frame = containerView.bounds;
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:controller.view];

    [NSLayoutConstraint view:controller.view shouldFillContainerWithInsets:UIEdgeInsetsZero];

    [controller didMoveToParentViewController:self];
}

- (void)smp_removeAllChildViewControllers {
    for (UIViewController *child in self.childViewControllers) {
        [self smp_removeChildViewController:child];
    }
}

- (void)smp_removeChildViewController:(UIViewController *)controller {
    NSParameterAssert(controller);

    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

@end
