//
//  CUIInputControlContainerValidationStatusView.h
//  CircuitUI
//
//  Created by Marcel Voß on 02.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit;

@class CUIInputControlContainerValidationResult;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(InputControlContainerValidationStatusView)
@interface CUIInputControlContainerValidationStatusView: UIView

@property (nonatomic) CUIInputControlContainerValidationResult *result;

- (instancetype)initWithValidationResult:(CUIInputControlContainerValidationResult *)result NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
