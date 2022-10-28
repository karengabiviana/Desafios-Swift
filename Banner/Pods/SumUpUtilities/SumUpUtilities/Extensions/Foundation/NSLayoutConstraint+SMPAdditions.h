//
//  NSLayoutConstraint+SMPAdditions.h
//  DAZApp
//
//  Created by Felix Lamouroux on 05.12.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (SMPAdditions)

/**
 *  Creates a constraint that equates the two items' attributes.
 */
+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 equalToItem:(id)view2 attribute:(NSLayoutAttribute)attr2;

/**
 *  Applies layout constraints that will fill the container the given view,
 *  leaving a margin as indicated by the insets.
 *
 *  @param view   The view that should fill its container.
 *                It is important that the view has a superview when calling this method.
 *  @param insets The insets from the edge of the container.
 */
+ (void)view:(UIView *)view shouldFillContainerWithInsets:(UIEdgeInsets)insets;

/**
 *  Applies layout constraints that will pin the view to the top or bottom of the container (or both).
 *  The view will fill the width of the container (minus the insets).
 *
 *  @param view    The view that should be layouted relative to its container.
 *                 It is important that the view has a superview when calling this method.
 *  @param top     If YES the view will be pinned to the top of its container with an inset as given below.
 *  @param bottom  If YES the view will be pinned to the bottom of its container with an inset as given below.
 *  @param insets  The insets from the edge of the container.
 *
 *  @note Calling this mehtod with bottom and top YES is equivalent to calling +view:shouldFillContainerWithInsets:. 
 *        Calling it with bottom and top NO only apply width constraints.
 */
+ (void)view:(UIView *)view shouldPinToTop:(BOOL)top bottom:(BOOL)bottom ofContainerWithInsets:(UIEdgeInsets)insets;


/**
 *  Creates two layout constraints (x and y) and adds them
 *  to the container.
 *
 *  @note You need to make sure that item is a subview of
 *  container before using this method.
 *
 *  @param item         The item to be centered
 *  @param container    The container in which item will be
 *                      centered
 *  @return The two constraints that were added.
 */
+ (NSArray *)centerView:(id)item inContainer:(id)container;

/**
 *  Creates two layout constraints (x and y) with the
 *  specified priorities and adds them to the container.
 *
 *  The priorities are validated. Pass in negative values or
 *  values greater than 1000 to use default priorities.
 *
 *  @sa tgt_centerItem:inItem:
 *
 */
+ (NSArray *)centerView:(id)item inContainer:(id)container priorityX:(UILayoutPriority)priorityX priorityY:(UILayoutPriority)priorityY;

@end

NS_ASSUME_NONNULL_END
