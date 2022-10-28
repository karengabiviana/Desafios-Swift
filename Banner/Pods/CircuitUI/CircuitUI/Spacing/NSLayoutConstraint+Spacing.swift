//
//  NSLayoutConstraint+Spacing.swift
//  CircuitUI
//
//  Created by Marcel Voß on 06.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation
import UIKit

public extension NSLayoutConstraint {
    func setConstant(_ spacing: Spacing) {
        constant = spacing.rawValue
    }
}

public extension RandomAccessCollection where Element == NSLayoutConstraint {
    func setConstant(_ spacing: Spacing) {
        forEach { $0.setConstant(spacing) }
    }
}
