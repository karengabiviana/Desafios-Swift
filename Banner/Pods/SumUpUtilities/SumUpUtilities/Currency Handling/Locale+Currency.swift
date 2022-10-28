//
//  Locale+Currency.swift
//  SumUpUtilities
//
//  Created by Hagi on 26.07.19.
//  Copyright © 2019 SumUp. All rights reserved.
//

import Foundation

extension Locale {

    /// Convenience property to avoid NSLocale/Locale casting.
    /// Implementation is in NSLocale+Currency.h.
    public var smp_currencySymbol: String? {
        (self as NSLocale).smp_currencySymbol
    }

}
