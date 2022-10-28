//
//  UIEdgeInsets+Spacing.swift
//  CircuitUI
//
//  Created by Marcel Voß on 06.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation
import UIKit

public extension UIEdgeInsets {
    init(top: Spacing, left: Spacing, bottom: Spacing, right: Spacing) {
        self.init(top: top.rawValue, left: left.rawValue, bottom: bottom.rawValue, right: right.rawValue)
    }

    init(vertical: Spacing, horizontal: Spacing) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
