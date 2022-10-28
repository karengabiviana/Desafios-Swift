//
//  CALayer+Spacing.swift
//  CircuitUI
//
//  Created by Marcel Voß on 06.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation

public extension CALayer {
    func setCornerRadius(_ spacing: Spacing) {
        cornerRadius = spacing.rawValue
    }
}
