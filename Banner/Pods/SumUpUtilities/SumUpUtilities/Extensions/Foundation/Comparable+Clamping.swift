//
//  Comparable+Clamping.swift
//  SumUpUtilities
//
//  Created by Marcel Voß on 29.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import Foundation

public extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
