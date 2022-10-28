//
//  CUIInputControlContainerValidationResult.h
//  CircuitUI
//
//  Created by Marcel Voß on 08.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;

@class CUITextFieldValidationResult;
@class CUISelectControlValidationResult;

NS_ASSUME_NONNULL_BEGIN

/// An object that is used to communicate validation results to CUIInputControlContainerView instances.
NS_SWIFT_NAME(InputControlContainerValidationResult)
@interface CUIInputControlContainerValidationResult: NSObject

@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly, nullable) NSString *reason;

- (instancetype)initWithSuccess:(BOOL)success reason:(nullable NSString *)reason NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTextFieldValidationResult:(CUITextFieldValidationResult *)result;
- (instancetype)initWithSelectValidationResult:(CUISelectControlValidationResult *)result;

- (BOOL)isEqualToResult:(CUIInputControlContainerValidationResult *)result;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
