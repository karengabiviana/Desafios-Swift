//
//  ListItemMultilineContentView.swift
//  CircuitUI
//
//  Created by Hagi on 21.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

/**
 * A content view that renders content elements into a multiline
 * layout.
 */
final class ListItemMultilineContentView: UIView, ListItemContentView {

    private weak var leadingView: UIView?
    private weak var leadingLabel: CUILabel?
    private weak var leadingSecondaryView: UIView?
    private weak var trailingView: UIView?
    private weak var trailingSecondaryView: UIImageView?

    var isSelected = false {
        didSet {
            do {
                try applyConfiguration(configuration)
            } catch {
                assertionFailure("Configuration error: \(error). Can't apply configuration \(configuration) and reflect isSelected state.")
            }
        }
    }

    // MARK: - Initial Setup and Layout

    private(set) var configuration: ListContentConfiguration

    init(configuration: ListContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpForConfiguration(configuration)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpForConfiguration(_ configuration: ListContentConfiguration) {
        assert(configuration.isMultiLineLayout, "Trying to apply a single-line configuration to a multiline cell")

        let leadingGroup = createLeadingGroup(for: configuration)
        let topGroup = createTopGroup(for: configuration)
        let bottomGroup = createBottomGroup(for: configuration)

        // Assemble full layout

        let verticalStack = UIStackView(arrangedSubviews: [topGroup, bottomGroup])
        verticalStack.axis = .vertical
        // deliberately a custom spacing, to create the
        // right visual impression between the lines
        verticalStack.spacing = 6

        let horizontalStack = UIStackView(arrangedSubviews: [leadingGroup, verticalStack].compactMap { $0 })
        horizontalStack.alignment = .center
        horizontalStack.setSpacing(.mega)

        // Special case for centering trailing item.
        // If the trailing item is an image and there is no secondary trailing item, then
        // we should display the image centered vertically.
        if configuration.centersTrailingView, let trailingView = trailingView {
            trailingView.removeFromSuperview()
            horizontalStack.addArrangedSubview(trailingView)
        }

        // Special treatment for trailing secondary: Placement depends
        // on general layout

        if let trailingSecondaryElement = configuration.trailingSecondaryElement {
            let trailingSecondaryView = trailingSecondaryElement.createView(isSelected: isSelected)
            self.trailingSecondaryView = trailingSecondaryView

            if configuration.centersTrailingSecondaryView {
                horizontalStack.addArrangedSubview(trailingSecondaryView)
            } else {
                switch trailingSecondaryElement {
                case .moreButton:
                    bottomGroup.addArrangedSubview(trailingSecondaryView)
                case .navigationChevron:
                    topGroup.addArrangedSubview(trailingSecondaryView)
                }
            }
        }

        layoutMargins = .init(vertical: .kilo, horizontal: .mega)
        addSubview(horizontalStack, with: [
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor),
            layoutMarginsGuide.topAnchor.constraint(equalTo: horizontalStack.topAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: horizontalStack.bottomAnchor)
        ])

        // If trailing item is navigation chevron, constraint leading secondary view <= to trailing view so that
        // the leading view truncates and doesn't extend beyond the trailing item horizontally

        if let leadingSecondaryView = leadingSecondaryView, let trailingView = trailingView, configuration.trailingSecondaryElement == .navigationChevron {
            NSLayoutConstraint.activate([
                leadingSecondaryView.trailingAnchor.constraint(lessThanOrEqualTo: trailingView.leadingAnchor)
            ])
        }
    }

    private func createLeadingGroup(for configuration: ListContentConfiguration) -> UIView? {
        let leadingView = configuration.leadingElement?.createView(isSelected: isSelected)
        self.leadingView = leadingView
        return leadingView
    }

    private func createTopGroup(for configuration: ListContentConfiguration) -> UIStackView {
        let titleLabel = configuration.leadingTextElement.createView(isSelected: isSelected)
        self.leadingLabel = titleLabel

        // ensure this is lower than the trailing view,
        // so in doubt, the titleLabel is stretched to fill the
        // horizontal space (the leading view always hugs tightly)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        // ensure this is lower than the trailing view, to ensure
        // the title is truncated before pushing views out or
        // compressing them
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let trailingView = configuration.trailingElement?.createView(isSelected: isSelected)
        self.trailingView = trailingView

        let topGroup = UIStackView(arrangedSubviews: [titleLabel, trailingView].compactMap { $0 })
        topGroup.alignment = .center
        topGroup.setSpacing(.byte)

        return topGroup
    }

    private func createBottomGroup(for configuration: ListContentConfiguration) -> UIStackView {
        let leadingSecondary = configuration.leadingSecondaryElement?.createView(isSelected: isSelected)
        // ensure this is lower than the trailing view, to ensure
        // the subtitle is truncated before pushing views out or
        // compressing them
        leadingSecondary?.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.leadingSecondaryView = leadingSecondary

        // A third view might be added later, see trailingSecondaryView.
        // We add spacing because neither the leading nor secondary view should
        // be stretched to fill unused space
        let bottomGroup = UIStackView(arrangedSubviews: [leadingSecondary, .horizontalSpacing(minimumWidth: .byte)].compactMap { $0 })
        bottomGroup.alignment = .center
        bottomGroup.setSpacing(.none) // minimum spacing applied via spacer view

        return bottomGroup
    }

    // MARK: - Content Updates

    func applyConfiguration(_ newConfiguration: ListContentConfiguration) throws {
        guard newConfiguration.isMultiLineLayout else {
            throw ListItemConfigurationError.contentViewTypeMismatch
        }

        guard configuration.centersTrailingView == newConfiguration.centersTrailingView else {
            throw ListItemConfigurationError.elementTypeMismatch
        }

        guard configuration.centersTrailingSecondaryView == newConfiguration.centersTrailingSecondaryView else {
            throw ListItemConfigurationError.elementTypeMismatch
        }

        if let leadingCanvas = configuration.leadingImageCanvasSize,
           let newLeadingCanvas = newConfiguration.leadingImageCanvasSize,
           leadingCanvas != newLeadingCanvas {
            /*
             *  Ideally, this would be caught within apply(…) below,
             *  but the view does not have access to the previous
             *  configuration. When using SF Symbols in the image
             *  view, the image view's bounds don't exactly match the
             *  specified canvas size, so comparing the new canvas
             *  size to the existing bounds does not work reliably.
             */
            throw ListItemConfigurationError.constraintsMismatch
        }

        try leadingView?.apply(newConfiguration.leadingElement, isSelected: isSelected)
        try leadingLabel?.apply(newConfiguration.leadingTextElement)
        try leadingSecondaryView?.apply(newConfiguration.leadingSecondaryElement)
        try trailingView?.apply(newConfiguration.trailingElement, isSelected: isSelected)
        try trailingSecondaryView?.apply(newConfiguration.trailingSecondaryElement)

        configuration = newConfiguration
    }

    private(set) lazy var contentLayoutGuide: UILayoutGuide = {
        let guide = UILayoutGuide()
        addLayoutGuide(guide)
        NSLayoutConstraint.activate([
            guide.leadingAnchor.constraint(equalTo: leadingLabel?.leadingAnchor ?? leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: trailingAnchor),
            guide.bottomAnchor.constraint(equalTo: bottomAnchor),
            guide.topAnchor.constraint(equalTo: topAnchor)
        ])
        return guide
    }()
}

private extension ListContentConfiguration {

    var centersTrailingView: Bool {
        guard case .image = trailingElement else {
            return false
        }
        return trailingSecondaryElement == nil
    }

    var centersTrailingSecondaryView: Bool {
        trailingElement == nil
    }

    var leadingImageCanvasSize: CGSize? {
        switch leadingElement {
        case .image(_, let imageOptions), .remoteImage(_, _, let imageOptions):
            return imageOptions.canvasSize.pointsSize
        case .checkmark(_, let canvasSize, _):
            return canvasSize
        case .badge, .none:
            return nil
        }
    }

}

private extension UIView {

    /// A completely flexible view – it will fill any space it can
    /// while it doesn't mind being compressed either.
    static func horizontalSpacing(minimumWidth: Spacing) -> UIView {
        let view = UIView()
        let noPriority = UILayoutPriority(0)
        view.setContentHuggingPriority(noPriority, for: .horizontal)
        view.setContentHuggingPriority(noPriority, for: .vertical)
        view.setContentCompressionResistancePriority(noPriority, for: .horizontal)
        view.setContentCompressionResistancePriority(noPriority, for: .vertical)
        view.widthAnchor.constraint(greaterThanOrEqualToSpacing: minimumWidth)
        return view
    }

}
