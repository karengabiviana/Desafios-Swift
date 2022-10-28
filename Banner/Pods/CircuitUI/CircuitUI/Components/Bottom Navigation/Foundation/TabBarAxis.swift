//
//  TabBarAxis.swift
//  CircuitUI
//
//  Created by Marcel Voß on 10.02.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import Foundation

/// The axis along which the tab bar is laid out.
@objc(CUITabBarAxis)
public enum TabBarAxis: Int {
    case vertical
    case horizontal

    var isVertical: Bool {
        switch self {
        case .vertical:
            return true
        case .horizontal:
            return false
        }
    }
}
