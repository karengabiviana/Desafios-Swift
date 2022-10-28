//
//  Spacing+Extensions.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 17/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

public extension Spacing {
    static prefix func - (spacing: Spacing) -> Spacing {
        Spacing(rawValue: -spacing.rawValue)
    }
}
