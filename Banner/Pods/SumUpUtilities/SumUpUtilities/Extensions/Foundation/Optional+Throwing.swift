//
//  Optional+Throwing.swift
//  SumUpUtilities
//
//  Created by Marcel Voß on 20.04.20.
//  Copyright © 2020 SumUp. All rights reserved.
//

import Foundation

public extension Optional {

    /// Safely unwraps the wrapped value and returns the wrapped value in case unwrapping was successful, otherwise throws an error.
    /// - Parameter error: The error that should be thrown in case the wrapped value is nil.
    func unwrap(or error: @autoclosure () -> Error) throws -> Wrapped {
        guard let wrappedValue = self else {
            throw error()
        }
        return wrappedValue
    }
}
