//
//  UINavigationControllerDelegateForwarder.h
//  CircuitUI
//
//  Created by Illia Lukisha on 09/11/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;
@import UIKit;

/// Heavily inspired by Apple's [WKScrollViewDelegateForwarder](https://github.com/WebKit/WebKit/blob/main/Source/WebKit/UIProcess/ios/WKScrollView.mm).
@interface UINavigationControllerDelegateForwarder : NSObject <UINavigationControllerDelegate>

@property (nonatomic, weak, readonly) id <UINavigationControllerDelegate> internalDelegate;
@property (nonatomic, weak, readonly) id <UINavigationControllerDelegate> externalDelegate;

- (instancetype)initWithInternalDelegate:(id <UINavigationControllerDelegate>)internalDelegate externalDelegate:(id <UINavigationControllerDelegate>)externalDelegate;

@end
