//
//  ListItemSingleLineContentView.swift
//  CircuitUI
//
//  Created by Hagi on 21.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

/**
 * A content view that renders content elements that all fit into
 * a single line.
 */
final class ListItemSingleLineContentView: UIView, ListItemContentView {

    private weak var leadingView: UIView?
    private weak var leadingLabel: CUILabel?
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
        assert(!configuration.isMultiLineLayout, "Trying to apply a multiline configuration to a single-line cell")
        let leadingGroup = createLeadingGroup(for: configuration)
        let trailingGroup = createTrailingGroup(for: configuration)

        let stack = UIStackView(arrangedSubviews: [leadingGroup, trailingGroup])
        stack.alignment = .center
        stack.setSpacing(.byte)

        layoutMargins = .init(vertical: .kilo, horizontal: .mega)
        addSubview(stack, with: [
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            layoutMarginsGuide.topAnchor.constraint(equalTo: stack.topAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ])
    }

    private func createLeadingGroup(for configuration: ListContentConfiguration) -> UIView {
        let leadingView = configuration.leadingElement?.createView(isSelected: isSelected)
        self.leadingView = leadingView

        let titleLabel = configuration.leadingTextElement.createView(isSelected: isSelected)
        // we rather truncate the title than compressing the leading
        // badge or icon
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.leadingLabel = titleLabel
        titleLabel.numberOfLines = 0

        let leadingGroup = UIStackView(arrangedSubviews: [leadingView, titleLabel].compactMap { $0 })
        leadingGroup.alignment = .center
        leadingGroup.setSpacing(.mega)

        // ensure this is lower than the trailing group,
        // so in doubt, the titleLabel is stretched to fill the
        // horizontal space (the leading view always hugs tightly)
        leadingGroup.setContentHuggingPriority(.defaultLow, for: .horizontal)
        // ensure this is lower than the trailing group, to ensure
        // the title is truncated before pushing views out or
        // compressing them
        leadingGroup.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return leadingGroup
    }

    private func createTrailingGroup(for configuration: ListContentConfiguration) -> UIView {
        let trailingView = configuration.trailingElement?.createView(isSelected: isSelected)
        self.trailingView = trailingView
        let trailingSecondary = configuration.trailingSecondaryElement?.createView(isSelected: isSelected)
        self.trailingSecondaryView = trailingSecondary

        let trailingGroup = UIStackView(arrangedSubviews: [trailingView, trailingSecondary].compactMap { $0 })
        trailingGroup.alignment = .center
        trailingGroup.setSpacing(.kilo)

        return trailingGroup
    }

    // MARK: - Content Updates

    func applyConfiguration(_ newConfiguration: ListContentConfiguration) throws {
        guard !newConfiguration.isMultiLineLayout else {
            throw ListItemConfigurationError.contentViewTypeMismatch
        }

        try leadingView?.apply(newConfiguration.leadingElement, isSelected: isSelected)
        try leadingLabel?.apply(newConfiguration.leadingTextElement)
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
