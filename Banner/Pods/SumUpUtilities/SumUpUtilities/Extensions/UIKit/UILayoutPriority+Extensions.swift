//
//  UILayoutPriority+AlmostRequired.swift
//
//  Created by Hagi on 24.01.18.
//  Copyright © 2018 SumUp Payments Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension UILayoutPriority {

    /**
     *   The minimal allowed layout priority. It is lower than .fittingSizeLevel, so
     *   constraints of this priority may be ignored/compressed when asking a view
     *   for its fitting or compressed size.
     */
    static let lowest = UILayoutPriority(1)

    /**
     *   Medium priority that is in between .defaultLow and .defaultHigh.
     */
    static let medium = UILayoutPriority(500)

    /**
     *   Not required, but as close as it gets. This allows you to change the priority
     *   after the constraint was created/installed. A required constraint's priority
     *   cannot be altered.
     */
    static let almostRequired = required - 1

}
