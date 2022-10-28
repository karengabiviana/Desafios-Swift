//
//  UIActivityIndicatorView+StartIfNeeded.swift
//
//  Created by Felix Lamouroux on 14.11.17.
//  Copyright © 2017 SumUp Payments Ltd. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    /**
     *   Starts or stops the animation, but does nothing
     *   if the current state already reflects the desired
     *   state.
     *
     *   This helps to prevent animation jumps when calling
     *   startAnimating() repeatedly.
     */
    public func setAnimating(_ animate: Bool = true) {
        guard animate != isAnimating else {
            return
        }

        if animate {
            startAnimating()
        } else {
            stopAnimating()
        }
    }

}
