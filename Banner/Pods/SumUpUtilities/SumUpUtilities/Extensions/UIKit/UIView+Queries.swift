//
//  UIView+Queries.swift
//  SumUpUtilities
//
//  Created by Felix Lamouroux on 28.09.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import UIKit

public extension UIView {
    /// Recursively finds the first subview (or itself) that matches the predicate.
    ///
    /// The following example returns the first UIButton:
    ///
    ///     view.firstSubview { $0 is UIButton }
    ///
    /// - Parameter predicate: A closure that takes a subview of the receiver
    ///   (or the receiver itself) as its argument and returns a Boolean value
    ///   indicating whether the subview is a match.
    ///
    /// - Returns: The first subview or itself that satisfies the `predicate`
    ///   or nil if no match satisfies `predicate`.
    func firstSubview(where predicate: (UIView) -> Bool) -> UIView? {
        if predicate(self) {
            return self
        }

        for subview in subviews {
            if let match = subview.firstSubview(where: predicate) {
                return match
            }
        }

        return nil
    }

    /// Recursively finds the first subview (or itself) that matches the accessibilityIdentifier.
    ///
    /// - Parameter identifier: The accessibilityIdentifier of the view to find.
    /// - Returns: The first subview or itself that matches the accessibilityIdentifier.
    /// Nil if no matches are found.
    func firstSubview(withAccessibilityIdentifier identifier: String) -> UIView? {
        firstSubview { $0.accessibilityIdentifier == identifier }
    }

    // removes all subviews in the View.
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
