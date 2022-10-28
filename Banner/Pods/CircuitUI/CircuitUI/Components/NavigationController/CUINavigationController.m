//
//  CUINavigationController.m
//  CircuitUI
//
//  Created by Illia Lukisha on 16/11/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUINavigationController.h"
#import <CircuitUI/CUINavigationController+Private.h>
#import "UINavigationControllerDelegateForwarder.h"

@interface CUINavigationController ()

@property (nonatomic, nullable) UINavigationControllerDelegateForwarder *proxy;

@end

@implementation CUINavigationController

#pragma mark - Delegate proxy

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    [self replaceExternalDelegate:delegate];
}

- (id<UINavigationControllerDelegate>)delegate {
    return self.proxy.externalDelegate;
}

-(void)setInterceptingDelegate:(id<UINavigationControllerDelegate>)interceptingDelegate {
    [self replaceInternalDelegate:interceptingDelegate];
}

-(id<UINavigationControllerDelegate>)intercepringDelegate {
    return self.proxy.internalDelegate;
}

-(void)replaceExternalDelegate:(id <UINavigationControllerDelegate>)externalDelegate {
    [self setProxy:[[UINavigationControllerDelegateForwarder alloc] initWithInternalDelegate:self.proxy.internalDelegate externalDelegate:externalDelegate]];
    [super setDelegate:self.proxy];
}

-(void)replaceInternalDelegate:(id <UINavigationControllerDelegate>)internalDelegate {
    [self setProxy:[[UINavigationControllerDelegateForwarder alloc] initWithInternalDelegate:internalDelegate externalDelegate:self.proxy.externalDelegate]];
    [super setDelegate:self.proxy];
}

#pragma mark - Overrides

- (BOOL)shouldAutorotate {
    // Will be replaced with CUIViewController obj-c shared default implementation
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // Will be replaced with CUIViewController obj-c shared default implementation
    return self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Dark Mode

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

@end
