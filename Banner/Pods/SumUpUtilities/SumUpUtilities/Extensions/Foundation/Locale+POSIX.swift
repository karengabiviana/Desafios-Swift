//
//  Locale+POSIX.swift
//  SumUpUtilities
//
//  Created by Lucien Doellinger on 30/01/20.
//  Copyright © 2020 SumUp. All rights reserved.
//

import Foundation

extension Locale {

    /// US-English POSIX locale. Should be used whenever a locale should
    /// be pinned down as specific as possible, e.g., in tests or for
    /// non-localized (=machine-readable) formatting.
    public static var posix: Locale {
        .init(identifier: "en_US_POSIX")
    }
}
