//
//  UINavigationControllerDelegateForwarder.m
//  CircuitUI
//
//  Created by Illia Lukisha on 09/11/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "UINavigationControllerDelegateForwarder.h"

@implementation UINavigationControllerDelegateForwarder

- (instancetype)initWithInternalDelegate:(id <UINavigationControllerDelegate>)internalDelegate externalDelegate:(id <UINavigationControllerDelegate>)externalDelegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    _internalDelegate = internalDelegate;
    _externalDelegate = externalDelegate;
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [_internalDelegate respondsToSelector:aSelector] || [_externalDelegate respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    BOOL internalDelegateWillRespond = [_internalDelegate respondsToSelector:aSelector];
    BOOL externalDelegateWillRespond = [_externalDelegate respondsToSelector:aSelector];

    if (internalDelegateWillRespond) {
        [anInvocation invokeWithTarget:_internalDelegate];
    }
    if (externalDelegateWillRespond) {
        [anInvocation invokeWithTarget:_externalDelegate];
    }

    if (!internalDelegateWillRespond && !externalDelegateWillRespond) {
        [super forwardInvocation:anInvocation];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    BOOL internalDelegateWillRespond = [_internalDelegate respondsToSelector:aSelector];
    BOOL externalDelegateWillRespond = [_externalDelegate respondsToSelector:aSelector];

    if (internalDelegateWillRespond && !externalDelegateWillRespond) {
        return _internalDelegate;
    }
    if (externalDelegateWillRespond && !internalDelegateWillRespond) {
        return _externalDelegate;
    }
    return [super forwardingTargetForSelector: aSelector];
}

@end
