//
//  NSLayoutConstraint+SMPAdditions.m
//  DAZApp
//
//  Created by Felix Lamouroux on 05.12.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "NSLayoutConstraint+SMPAdditions.h"

/// Builds an array of the view and all its superviews.
NSArray* ISHLayoutHierarchyForView(UIView *view, NSArray *accumulator);
NSArray* ISHLayoutHierarchyForView(UIView *view, NSArray *accumulator) {
    if (!view) {
        return accumulator;
    } else {
        return ISHLayoutHierarchyForView(view.superview, [accumulator arrayByAddingObject:view]);
    }
}

/// Returns a common ancestor of two views (if part of the same view hierarchy)
UIView* ISHLayoutCommonAncestorForViews(UIView *view1, UIView *view2);
UIView* ISHLayoutCommonAncestorForViews(UIView *view1, UIView *view2) {
    if (!view1 || !view2) {
        // both must be non-null
        return nil;
    }

    if (view1 == view2) {
        // if both views are equal the view itself is its closest common ancestor
        return view1;
    }

    // see http://stackoverflow.com/a/30158224/195186
    NSArray *view1Hierarchy = ISHLayoutHierarchyForView(view1, @[]);
    NSArray *view2Hierarchy = ISHLayoutHierarchyForView(view2, @[]);

    return [view1Hierarchy firstObjectCommonWithArray:view2Hierarchy];
}


@implementation NSLayoutConstraint (ISHAdditions)

+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 equalToItem:(id)view2 attribute:(NSLayoutAttribute)attr2 {
    return [self constraintWithItem:view1
                          attribute:attr1
                          relatedBy:NSLayoutRelationEqual
                             toItem:view2
                          attribute:attr2
                         multiplier:1
                           constant:0];
}

+ (void)view:(UIView *)view shouldFillContainerWithInsets:(UIEdgeInsets)insets {
    [self view:view shouldPinToTop:YES bottom:YES ofContainerWithInsets:insets];
}

+ (void)view:(UIView *)view shouldPinToTop:(BOOL)top bottom:(BOOL)bottom ofContainerWithInsets:(UIEdgeInsets)insets {
    if (!view.superview) {
        return;
    }
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *edgeInsets = @{
                                 @"top" : @(insets.top),
                                 @"left" : @(insets.left),
                                 @"bottom" : @(insets.bottom),
                                 @"right" : @(insets.right)
                                 };
    
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-left-[view]-right-|" options:0 metrics:edgeInsets views:bindings]];
   
    if (!top && !bottom) {
        // if both are NO, there is nothing more to do
        return;
    }
    
    NSString *verticalLayoutFormat;
    if (top && bottom) {
        verticalLayoutFormat = @"V:|-top-[view]-bottom-|";
    } else if (top) {
        verticalLayoutFormat = @"V:|-top-[view]";
    } else if (bottom) {
        verticalLayoutFormat = @"V:[view]-bottom-|";
    }
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalLayoutFormat options:0 metrics:edgeInsets views:bindings]];
}

+ (NSArray *)centerView:(UIView *)item inContainer:(UIView *)container {
    return [self centerView:item inContainer:container priorityX:-1 priorityY:-1];
}

+ (NSArray *)centerView:(id)item inContainer:(id)container priorityX:(UILayoutPriority)priorityX priorityY:(UILayoutPriority)priorityY {
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:item
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:container
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    if ((priorityX >= 0) && (priorityX <= 1000)) {
        centerX.priority = priorityX;
    }
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:item
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:container
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0];
    if ((priorityY >= 0) && (priorityY <= 1000)) {
        centerY.priority = priorityY;
    }
    NSArray *constraints = @[centerX, centerY];
    [container addConstraints:constraints];
    return constraints;
}

@end
