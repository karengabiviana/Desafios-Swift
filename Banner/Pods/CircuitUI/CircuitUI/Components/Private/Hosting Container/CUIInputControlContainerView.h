//
//  CUIInputControlContainerView.h
//  CircuitUI
//
//  Created by Marcel Voß on 06.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

@class CUIInputControlContainerValidationResult;

#import "CUIInputControlContainerViewState.h"

NS_ASSUME_NONNULL_BEGIN

/// A view that provides a common interface for views that are arranged within a container-like layout with title, subtitle and validation.
@interface CUIInputControlContainerView: UIView

@property (nonatomic, nullable, copy) NSString *title;
@property (nonatomic, nullable, copy) NSString *subtitle;

@property (nonatomic, readonly) CUIInputControlContainerViewState state;

@property (nonatomic) UIEdgeInsets hostedViewMarginInsets;

- (instancetype)initWithHostedView:(UIView *)hostedView;
- (instancetype)initWithHostedView:(UIView *)hostedView title:(nullable NSString *)title subtitle:(nullable NSString *)subtitle;

- (void)updateStyleForState:(CUIInputControlContainerViewState)state;
- (void)updateStyleForValidationResult:(nullable CUIInputControlContainerValidationResult *)validationResult;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
