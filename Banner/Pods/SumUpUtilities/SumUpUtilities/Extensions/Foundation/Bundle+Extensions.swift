//
//  Bundle+Extensions.swift
//  SumUpUtilities
//
//  Created by Andras Kadar on 4/1/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import Foundation

@objc
public extension Bundle {
    var bundleShortVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var bundleVersion: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
