//
//  GradientView.swift
//
//  Created by Felix Lamouroux on 07.09.15.
//  Copyright © 2015 iosphere GmbH. All rights reserved.
//

import UIKit

public class GradientView: UIView {

    override public class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        // swiftlint:disable:next force_cast
        return layer as! CAGradientLayer
    }

    public var colors: [UIColor]? {
        didSet {
            if let allColors = colors {
                gradientLayer.colors = allColors.map { $0.cgColor }
            } else {
                gradientLayer.colors = nil
            }
        }
    }

    public var locations: [Double]? {
        didSet {
            if let safeLocations = locations {
                gradientLayer.locations = safeLocations as [NSNumber]
            } else {
                gradientLayer.locations = nil
            }
        }
    }

    public var startPoint: CGPoint = .zero {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }

    public var endPoint = CGPoint(x: 0, y: 1) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }
}
