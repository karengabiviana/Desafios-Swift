//
//  Error+Extensions.swift
//  SumUpUtilities
//
//  Created by Andras Kadar on 2/24/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import Foundation

// MARK: ErrorWithUnderlyingError

/// A protocol that provides default implementation to the `CustomNSError` protocol's `errorUserInfo` property to include
/// the `underlyingError` in the error's `userInfo` dictionary, under the `NSUnderlyingErrorKey`.
///
/// Example usage:
/// ```swift
/// enum MyCustomError: ErrorWithUnderlyingError, CustomNSError {
///   case customCase1
///   case customCase2
///   case unexpected(underlying: Error)
///
///   var underlyingError: Error? {
///     switch self {
///     case let .unexpected(error):
///       return error
///     case .customCase1,
///          .customCase2:
///       return nil
///   }
/// }
/// ```
public protocol ErrorWithUnderlyingError: Error {
    /// An optional, underlying error of the current error
    var underlyingError: Error? { get }
}

extension CustomNSError where Self: ErrorWithUnderlyingError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        if let safeUnderlyingError = underlyingError {
            userInfo[NSUnderlyingErrorKey] = safeUnderlyingError
        }
        return userInfo
    }
}

// MARK: - Error chains

public extension Error {
    /**
     Extracts and returns all the errors under the `NSUnderlyingErrorKey`, recursively.
     - Returns: An [Error] with all the underlying errors including self
     */
    var errorChain: [Error] {
        guard let underlyingError = (self as NSError).userInfo[NSUnderlyingErrorKey] as? Error else {
            return [self]
        }
        return [self] + underlyingError.errorChain
    }

    /**
     Extracts and returns all the errors under the `NSUnderlyingErrorKey`, recursively. After extracting an error, it creates a copy of itself by removing the `NSUnderlyingErrorKey` key.
     - Returns: An [Error] with all the underlying errors including self after it disassociates the connected errors.
     */
    var disassociatedErrorChain: [Error] {
        let nsError = (self as NSError)
        guard let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? Error else {
            return [self]
        }

        var userInfoCopy = nsError.userInfo
        userInfoCopy.removeValue(forKey: NSUnderlyingErrorKey)
        let copyOfSelf = NSError(domain: nsError.domain, code: nsError.code, userInfo: userInfoCopy)

        return [copyOfSelf] + underlyingError.disassociatedErrorChain
    }
}
