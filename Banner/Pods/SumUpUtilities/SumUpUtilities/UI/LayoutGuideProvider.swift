//
//  LayoutGuideProvider.swift
//  SumUpCardReaderInternational
//
//  Created by Florian Schliep on 08.05.18.
//  Copyright © 2018 SumUp Services GmbH. All rights reserved.
//

import UIKit

// https://gist.github.com/IanKeen/aee3a8b4667309a95e2fc47ac3ee6ca6
public protocol LayoutGuideProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

public extension LayoutGuideProvider {
    func constrain(toEdgesOf other: LayoutGuideProvider) -> [NSLayoutConstraint] {
        [
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor),
            topAnchor.constraint(equalTo: other.topAnchor)
        ]
    }
}

extension UIView: LayoutGuideProvider { }
extension UILayoutGuide: LayoutGuideProvider { }
