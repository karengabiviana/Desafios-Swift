//
//  NSNumber+Comparable.swift
//  SumUpUtilities
//
//  Created by Lucien von Doellinger on 11/06/19.
//  Copyright © 2019 SumUp. All rights reserved.
//

import Foundation

extension NSNumber: Comparable {
    public static func == (lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.compare(rhs) == .orderedSame
    }

    public static func <= (lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.compare(rhs) != .orderedDescending
    }

    public static func >= (lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.compare(rhs) != .orderedAscending
    }

    public static func > (lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.compare(rhs) == .orderedDescending
    }

    public static func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }
}
