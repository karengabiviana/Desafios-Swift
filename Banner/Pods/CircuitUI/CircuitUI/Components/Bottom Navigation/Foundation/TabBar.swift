//
//  TabBar.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 18/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

import CircuitUI_Private
import SumUpUtilities
import UIKit

@objc(CUITabBar)
class TabBar: UIView {

    enum Appearance {
        case plain
        case floating
    }

    /// Block is called when an index is selected with the selected index.
    var onIndexSelection: ((Int) -> Void)?

    var stackViewSafeAreaBottomConstraint: NSLayoutConstraint?

    // Stackview on top of backgroundTabBar to achieve custom look and feel for the content
    private let stackView = UIStackView()

    private var itemViews = [UITabBarItem: TabBarItemView]()
    private var itemBadgeObservers = [NSKeyValueObservation]()

    private var hasRoundedCorners: Bool {
        switch appearance {
        case .plain:
            return false
        case .floating:
            return true
        }
    }

    /// Depending on whether tab bar is overlapping with the safe area we may or may not want to constrain
    /// stack view with items inside the container view accordingly. (Leaving safe area padding on the bottom if needed)
    private var stackViewShouldRespectSafeArea: Bool {
        switch appearance {
        case .plain:
            return true
        case .floating:
            return false
        }
    }

    private var itemStyle: TabBarItemView.Style {
        switch appearance {
        case .plain:
            return .regular
        case .floating:
            return .large
        }
    }

    let axis: TabBarAxis
    private let appearance: Appearance
    private let symmetricalSpacing: Spacing

    var items: [UITabBarItem] = [] {
        didSet {
            for item in oldValue {
                itemViews[item]?.removeFromSuperview()
            }

            itemViews = [:]
            itemBadgeObservers = []

            for (idx, item) in items.enumerated() {
                let button = TabBarItemView(style: itemStyle)

                button.accessibilityIdentifier = "tab-bar-item-\(idx)"

                let observer = item.observe(\.badgeValue) { [weak self] _, _ in
                    self?.updateHighlightState()
                }
                itemBadgeObservers.append(observer)

                button.addTarget(self, action: #selector(tabButtonTapped(button:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
                itemViews[item] = button
            }

            updateHighlightState()
        }
    }

    var selectedIndex: Int = 0 {
        didSet {
            updateHighlightState()
        }
    }

    private var selectedItem: UITabBarItem? {
        items[safe: selectedIndex]
    }

    private func updateHighlightState() {
        guard let safeSelectedItem = selectedItem else {
            return
        }

        itemViews.forEach { item, itemView in
            // use item image or if selected check if selected image is available
            var image = item.image
            let isSelected = item == safeSelectedItem
            if  isSelected {
                itemView.accessibilityTraits.insert(.selected)
                image = item.selectedImage ?? image
            } else {
                itemView.accessibilityTraits.remove(.selected)
            }

            itemView.image = image
            itemView.title = item.title
            itemView.showBadge = item.badgeValue != nil

            itemView.accessibilityLabel = item.title
            if #available(iOS 13.0, *) {
                itemView.largeContentTitle = item.title
                itemView.largeContentImage = item.selectedImage ?? item.image
            }
            itemView.isSelected = isSelected
        }
    }

    @objc private func tabButtonTapped(button: UIView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: button) else {
            assertionFailure("received tapp on button which is not part of the contents of this TabBar")
            return
        }

        onIndexSelection?(index)
    }

    private func configureView() {
        self.layer.needsDisplayOnBoundsChange = true
        accessibilityTraits.insert(.tabBar)
        updateHighlightState()
        if #available(iOS 13.0, *) {
            addInteraction(UILargeContentViewerInteraction(delegate: self))
        }
        stackView.axis = axis.isVertical ? .vertical : .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        backgroundColor = SemanticColor.background
        addSubview(stackView)
        clipsToBounds = true
    }

    private func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: axis.isVertical ? .horizontal : .vertical)

        let leadingConstraint: NSLayoutConstraint
        let highPriorityConstraints: [NSLayoutConstraint]
        let stackViewSafeAreaConstraint: NSLayoutConstraint

        switch axis {
        case.vertical:
            highPriorityConstraints = [
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, spacing: -symmetricalSpacing),
                stackView.topAnchor.constraint(equalTo: topAnchor, spacing: symmetricalSpacing)
            ]

            if stackViewShouldRespectSafeArea {
                stackViewSafeAreaConstraint = stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
            } else {
                stackViewSafeAreaConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
            }

            leadingConstraint = stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        case .horizontal:
            highPriorityConstraints = [
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, spacing: -symmetricalSpacing),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, spacing: symmetricalSpacing)
            ]

            if stackViewShouldRespectSafeArea {
                stackViewSafeAreaConstraint = stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            } else {
                stackViewSafeAreaConstraint = stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            }

            leadingConstraint = stackView.topAnchor.constraint(equalTo: topAnchor)
        }

        self.stackViewSafeAreaBottomConstraint = stackViewSafeAreaConstraint
        stackViewSafeAreaConstraint.priority = .required - 1

        highPriorityConstraints.forEach {
            $0.priority = .defaultHigh
        }

        NSLayoutConstraint.activate([
            stackViewSafeAreaConstraint,
            leadingConstraint,
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ] + highPriorityConstraints)
    }

    /// Essential functionality from `ISHBorderedView`.
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        func setBorderWidth(_ width: CGFloat, for context: CGContext) {
            context.setLineWidth(width)
            // disable anti aliasing when drawing in between screen points,
            // i.e., if the border width is not a multiple of the scale
            let roundedBorderWidth = Int(floor(width))
            let widthIsMultipleOfScreenScale = ((roundedBorderWidth % Int(UIScreen.main.scale)) == 0)
            context.setShouldAntialias(widthIsMultipleOfScreenScale)
        }

        let borderWidth: CGFloat

        switch appearance {
        case .plain:
            borderWidth = 0.5
            setBorderWidth(borderWidth, for: context)

            let color = CUIColorFromHex(ColorReference.CUIColorRefN40.rawValue)?.cgColor ?? UIColor.lightGray.cgColor
            context.setStrokeColor(color)
            context.move(to: CGPoint(x: 0, y: borderWidth / 2))
            context.addLine(to: CGPoint(x: bounds.width, y: borderWidth / 2))
            context.strokePath()
        case .floating:
            borderWidth = 2
            setBorderWidth(borderWidth, for: context)

            let color = CUIColorFromHex(ColorReference.CUIColorRefN30.rawValue)?.cgColor ?? UIColor.lightGray.cgColor
            context.setStrokeColor(color)
            context.beginPath()
            let rect = bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)

            context.addPath(UIBezierPath(roundedRect: rect, cornerRadius: bounds.height / 2).cgPath)
            context.closePath()
            context.strokePath()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch appearance {
        case .plain:
            break
        case .floating:
            let roundingValue: CGFloat = axis.isVertical ? bounds.width : bounds.height
            layer.cornerRadius = roundingValue / 2
        }
    }

    // MARK: - Initializers
    init(appearance: Appearance, axis: TabBarAxis, symmetricalSpacing: Spacing = .none) {
        self.axis = axis
        self.appearance = appearance
        self.symmetricalSpacing = symmetricalSpacing
        super.init(frame: .zero)

        configureView()
        configureConstraints()
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 13.0, *)
extension TabBar: UILargeContentViewerInteractionDelegate {
    func largeContentViewerInteraction(_ interaction: UILargeContentViewerInteraction,
                                       didEndOn item: UILargeContentViewerItem?,
                                       at point: CGPoint) {
        guard let tabBarItem = item as? TabBarItemView else {
            return
        }

        tabButtonTapped(button: tabBarItem)
    }
}

#endif
