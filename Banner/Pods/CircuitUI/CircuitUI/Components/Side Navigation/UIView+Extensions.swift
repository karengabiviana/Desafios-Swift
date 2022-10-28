//
//  UIView+Extensions.swift
//  CircuitUI
//
//  Created by Marcel Voß on 24.02.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import UIKit

extension UIView {
    func addLayoutGuide(_ guide: UILayoutGuide, with constraints: [NSLayoutConstraint]) {
        addLayoutGuide(guide)
        NSLayoutConstraint.activate(constraints)
    }
}
