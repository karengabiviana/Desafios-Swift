//
//  Array+Helpers.swift
//  SumUpUtilities
//
//  Created by Florian Schliep on 06.07.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

extension Array {
    /// The getter will return the element at idx, or nil if idx is out of bounds.
    /// The behavior of the setter depends on the circumstances and the passed value:
    /// 1) If the new value is non-nil and idx is within the bounds: replace the element at idx with the new value.
    /// 2) If idx is at the end of the array: append the new value to the array.
    /// 3) If you pass nil and idx is within the bounds: remove the element at idx.
    /// 4) If idx is out of bounds, nothing will happen.
    public subscript(safe idx: Int) -> Element? {
        get {
            guard indices ~= idx else {
                return nil
            }

            return self[idx]
        }
        set {
            if idx == indices.endIndex, let element = newValue {
                self.append(element)
                return
            }
            guard indices ~= idx else {
                return
            }

            if let element = newValue {
                self[idx] = element
            } else {
                self.remove(at: idx)
            }
        }
    }
}

/// Provides the opposite operation of zip().
public func unzip<A, B>(_ array: [(A, B)]) -> ([A], [B]) {
    array.reduce(into: ([A](), [B]())) { result, element in
        result.0.append(element.0)
        result.1.append(element.1)
    }
}
