//
//  CUITextFieldValidationResult.h
//  CircuitUI
//
//  Created by Marcel Voß on 31.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// An object that is used to communicate validation results to CUITextField instances.
NS_SWIFT_NAME(TextFieldValidationResult)
@interface CUITextFieldValidationResult: NSObject

@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly, nullable) NSString *reason;

- (instancetype)initWithSuccess:(BOOL)success reason:(nullable NSString *)reason NS_DESIGNATED_INITIALIZER;

/// Constructs a new successful result with a reason.
/// @param reason The reason for which the validation has been successful.
/// @Note The reason is being shown within the UI. It should be localized and well formatted. It should ideally be a one-liner and as short as possible.
+ (instancetype)successWithReason:(nullable NSString *)reason;

/// Constructs a new unsuccessful result with a reason.
/// @param reason The reason for which the validation has failed.
/// @Note The reason is being shown within the UI. It should be localized and well formatted. It should ideally be a one-liner and as short as possible.
+ (instancetype)failureWithReason:(nullable NSString *)reason;

- (BOOL)isEqualToResult:(CUITextFieldValidationResult *)result;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
