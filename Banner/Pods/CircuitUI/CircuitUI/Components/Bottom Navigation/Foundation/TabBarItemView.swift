//
//  TabBarItemView.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 13/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

import CircuitUI_Private
import UIKit

@objc(CUITabBarItemView)
final class TabBarItemView: UIControl {

    enum Style {
        /// The style corresponding to plain tabBar
        case regular
        /// The style correspondingto floating tabBar
        case large
    }

    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    override var isSelected: Bool {
        didSet {
            updateForegroundColor()
        }
    }

    private let titleLabel: LabelInteractive2 = {
        let titleLabel = LabelInteractive2()
        titleLabel.textAlignment = .center
        titleLabel.sds_isScalingEnabled = false
        return titleLabel
    }()

    private let imageView = UIImageView()

    private let style: Style

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        isAccessibilityElement = true
        accessibilityTraits.insert(.button)
        if #available(iOS 13.0, *) {
            showsLargeContentViewer = true
            scalesLargeContentImage = true
        }

        // in compact layout we hide the title and give the image a bit more space instead
        // use compact layout if titles are hidden and on iPhone SE and smaller
        let useCompactLayout = UIScreen.main.bounds.height <= 568

        let verticalSpacing: Spacing
        switch style {
        case .regular:
            verticalSpacing = useCompactLayout ? .kilo : .byte
        case .large:
            verticalSpacing = .kilo
        }
        layoutMargins = UIEdgeInsets(vertical: verticalSpacing, horizontal: .none)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, spacing: .nano),
            imageView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            widthAnchor.constraint(lessThanOrEqualToConstant: 168) // Max item width according to Figma
        ])

        layer.addSublayer(badgeDot)
        updateBadgeVisibility()

        if useCompactLayout {
            // do not add title label for small screens
            NSLayoutConstraint.activate([
                layoutMarginsGuide.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, spacing: .nano)
            ])
            return
        }

        let bottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, spacing: .nano),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            bottomConstraint
        ])

        isHighlighted = false
    }

    /// Provides minimum width for items that are placed in the tab bar.
    override var intrinsicContentSize: CGSize {
        switch style {
        case .large:
            return CGSize(width: 80, height: UIView.noIntrinsicMetric)
        case .regular:
            return CGSize(width: 72, height: UIView.noIntrinsicMetric)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBadgeLayout()
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        updateForegroundColor()
    }

    // MARK: - 🎖 Badge

    // MARK: Configuration

    var showBadge = false {
        didSet {
            updateBadgeVisibility()
        }
    }

    var badgeSize: CGFloat = 10 {
        didSet {
            updateBadgeLayout()
        }
    }

    var badgeMaskPadding = CGFloat(2) {
        didSet {
            updateBadgeLayout()
        }
    }

    var badgeOffset = CGPoint(x: 9, y: -9) {
        didSet {
            updateBadgeLayout()
        }
    }

    var badgeColor = CUIColorFromHex(ColorReference.CUIColorRefG80.rawValue) ?? .green {
        didSet {
            updateBadgeVisibility()
        }
    }

    // MARK: Setup/Layout

    private let badgeDot = CAShapeLayer()

    private let badgeMask: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillRule = .evenOdd
        shape.fillColor = UIColor.black.cgColor
        return shape
    }()

    private func updateBadgeVisibility() {
        imageView.layer.mask = showBadge ? badgeMask : nil
        badgeDot.fillColor = badgeColor.cgColor
        badgeDot.isHidden = !showBadge
    }

    private func updateBadgeLayout() {
        // the badgeDot is relative to the self.layer
        badgeDot.bounds.size = CGSize(width: badgeSize, height: badgeSize)
        badgeDot.position = CGPoint(x: imageView.frame.midX + badgeOffset.x, y: imageView.frame.midY + badgeOffset.y)
        badgeDot.path = UIBezierPath(ovalIn: badgeDot.bounds).cgPath

        // the badgeMask is relative to the imageView
        badgeMask.frame = imageView.bounds

        // the mask is a filled rect excluding the badgeDot with padding
        let path = UIBezierPath(rect: bounds)
        // add the badgeDot with padding to the path
        let dotFrameInImageViewCOS = imageView.convert(badgeDot.frame, from: self)
        path.append(UIBezierPath(ovalIn: dotFrameInImageViewCOS.insetBy(dx: -badgeMaskPadding, dy: -badgeMaskPadding)))
        // the badgeMask uses evenOdd as a fileRule
        // which will create a black square with the dot cut out.
        badgeMask.path = path.cgPath
    }

    private func updateForegroundColor() {
        let variant: LabelInteractiveVariant
        switch tintAdjustmentMode {
        case .dimmed:
            variant = .default
        case .automatic, .normal:
            fallthrough
        @unknown default:
            variant = isSelected ? .highlighted : .default
        }
        titleLabel.variant = variant
        imageView.tintColor = (titleLabel as UILabel).textColor
    }
}

#endif
