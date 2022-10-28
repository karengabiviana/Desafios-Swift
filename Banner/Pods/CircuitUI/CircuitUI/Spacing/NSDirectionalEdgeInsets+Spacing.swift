//
//  NSDirectionalEdgeInsets+Spacing.swift
//  CircuitUI
//
//  Created by Marcel Voß on 06.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation
import UIKit

public extension NSDirectionalEdgeInsets {
    init(top: Spacing, leading: Spacing, bottom: Spacing, trailing: Spacing) {
        self.init(top: top.rawValue, leading: leading.rawValue, bottom: bottom.rawValue, trailing: trailing.rawValue)
    }

    init(vertical: Spacing, horizontal: Spacing) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
