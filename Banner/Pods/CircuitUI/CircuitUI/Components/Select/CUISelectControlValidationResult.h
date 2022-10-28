//
//  CUISelectControlValidationResult.h
//  CircuitUI
//
//  Created by Marcel Voß on 07.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// An object that is used to communicate validation results to CUISelectControl instances.
NS_SWIFT_NAME(SelectControlValidationResult)
@interface CUISelectControlValidationResult: NSObject

/// Indicates whether the instance represents a success or a failure.
@property (nonatomic, readonly) BOOL success;

/// A text that indicates why a failure has occured.
///
/// @Note For all successful results, this is always nil and only ever contains a value in case of a failure.
@property (nonatomic, readonly, nullable, copy) NSString *reason;

- (instancetype)initWithSuccess:(BOOL)success reason:(nullable NSString *)reason NS_DESIGNATED_INITIALIZER;

/// Constructs a new successful result.
+ (instancetype)success;

/// Constructs a new unsuccessful result with a reason.
/// @param reason The reason for which the validation has failed.
/// @Note The reason is being shown within the UI. It should be localized and well formatted. It should ideally be a one-liner and as short as possible.
+ (instancetype)failureWithReason:(nullable NSString *)reason;

- (BOOL)isEqualToResult:(CUISelectControlValidationResult *)result;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
