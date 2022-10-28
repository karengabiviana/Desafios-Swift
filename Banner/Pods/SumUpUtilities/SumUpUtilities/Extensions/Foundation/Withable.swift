//
//  Withable.swift
//  Cashier
//
//  Created by Marcel Voß on 07.03.22.
//

import Foundation

public protocol Withable { }

/// A protocol and extension that allow a declarative/chained style.  By declaring the *what* rather than the *how* in this way, it's sometimes possible to end up with less code.
///
/// Example usage:
/// ```swift
/// private lazy var serialNumberLabel =
///     LabelBody1()
///         .with(\.variant, .highlight)
///         .with(\.adjustsFontSizeToFitWidth, true)
///         .with(\.minimumScaleFactor, 0.2)
///         .with { $0.setContentCompressionResistancePriority(.medium, for: .horizontal) }
/// ```
public extension Withable {
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }

    func with(_ closure: (_ me: Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Withable { }
