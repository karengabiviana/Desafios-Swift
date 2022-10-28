//
//  SeparatorView.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 15/12/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

import CircuitUI_Private

/// A vertical or horizontal hairline to visually separate content.
@objc(CUISeparatorView)
public final class SeparatorView: UIView {

    private enum Constants {

        static let separatorThickness: CGFloat = 1.0 / UIScreen.main.scale
    }

    private let axis: NSLayoutConstraint.Axis

    public init(axis: NSLayoutConstraint.Axis = .horizontal) {
        self.axis = axis
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        self.axis = .horizontal
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        self.axis = .horizontal
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = CUIColorFromHex(ColorReference.CUIColorRefN40.rawValue)
        setContentHuggingPriority(.required, for: axis.perpendicular)
    }

    override public var intrinsicContentSize: CGSize {
        switch axis {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: Constants.separatorThickness)
        case .vertical:
            return CGSize(width: Constants.separatorThickness, height: UIView.noIntrinsicMetric)
        @unknown default:
            assertionFailure()
            return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        }
    }
}

private extension NSLayoutConstraint.Axis {

    var perpendicular: NSLayoutConstraint.Axis {
        switch self {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        @unknown default:
            assertionFailure()
            return .horizontal
        }
    }
}

#endif
