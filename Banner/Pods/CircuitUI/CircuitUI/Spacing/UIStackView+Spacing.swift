//
//  UIStackView+Spacing.swift
//  CircuitUI
//
//  Created by Marcel Voß on 06.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation
import UIKit

public extension UIStackView {
    func setSpacing(_ spacing: Spacing) {
        self.spacing = spacing.rawValue
    }

    func setCustomSpacing(_ spacing: Spacing, after arrangedSubview: UIView) {
        setCustomSpacing(spacing.rawValue, after: arrangedSubview)
    }
}
