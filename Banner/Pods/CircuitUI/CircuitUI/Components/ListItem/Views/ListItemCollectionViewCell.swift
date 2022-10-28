//
//  ListItemCollectionViewCell.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 15/12/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

// MARK: - Public Cell Classes

/**
 *  Use this cell class for single- and multiline action cells.
 *
 *  You should not instantiate these cells directly. Instead, use
 *  the helpers provided in `UICollectionView+Reuse` to register and
 *  dequeue cells.
 */
public final class ListItemCollectionViewCellAction: ListItemCollectionViewCell {

    /// Applies the given configuration to the cell.
    public func applyConfiguration(_ configuration: ListContentConfigurationAction) {
        super.applyConfiguration(configuration)
    }

}

/**
 *  Use this cell class for single- and multiline navigation cells.
 *
 *  You should not instantiate these cells directly. Instead, use
 *  the helpers provided in `UICollectionView+Reuse` to register and
 *  dequeue cells.
 */
public final class ListItemCollectionViewCellNavigation: ListItemCollectionViewCell {

    /// Applies the given configuration to the cell.
    public func applyConfiguration(_ configuration: ListContentConfigurationNavigation) {
        super.applyConfiguration(configuration)
    }

}

// MARK: - Base Class

/**
 *  Base class for list items. Do not use directly. Instead, use
 *  `ListItemCollectionViewCellAction` or `ListItemCollectionViewCellNavigation`.
 */
public class ListItemCollectionViewCell: UICollectionViewCell {

    override public var isSelected: Bool {
        didSet {
            listItemContentView?.isSelected = isSelected
        }
    }

    private weak var listItemContentView: ListItemContentView?

    fileprivate func applyConfiguration(_ configuration: ListContentConfiguration) {
        guard let existingContentView = listItemContentView else {
            // first time a cell is instantiated
            insertContentView(for: configuration)
            return
        }

        /*
         *  Cell reuse: try to apply the given configuration. To make
         *  cell reuse meaningful, we only allow configurations that
         *  describe the same kind of content.
         *
         *  As a fallback, we throw away the content container and create
         *  a new one, and post a warning.
         */
        do {
            try existingContentView.applyConfiguration(configuration)
            existingContentView.isSelected = isSelected
        } catch ListItemConfigurationError.reuseNotSupported {
            insertContentView(for: configuration)
        } catch let configError as ListItemConfigurationError {
            // swiftlint:disable:next line_length
            print("⚠️ This cell (\"\(configuration.leadingTextElement.text)\") was previously configured with an incompatible configuration. The content view will be instantiated from scratch and not be reused. You should use different reuse identifiers for configurations that have different element types.\n\nOld reuse identifier: \(listItemContentView?.configuration.reuseIdentifier ?? "(empty)") / New reuse identifier: \(configuration.reuseIdentifier)\n\nError: \(configError)")
            insertContentView(for: configuration)
        } catch {
            assertionFailure("Unknown configuration error: \(error). Please extend ListItemConfigurationError.")
            insertContentView(for: configuration)
        }

    }

    private func insertContentView(for configuration: ListContentConfiguration) {
        listItemContentView?.removeFromSuperview()

        let newItemContentView: ListItemContentView
        if configuration.isMultiLineLayout {
            newItemContentView = ListItemMultilineContentView(configuration: configuration)
        } else {
            newItemContentView = ListItemSingleLineContentView(configuration: configuration)
        }

        // we deliberately erase layout margins, since
        // the custom content views will set their
        // own margins based on CircuitUI constants
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = .zero

        /*
         *  During reuse, the cell size may be collapsed to .zero,
         *  leading to constraint warnings. We therefore allow one
         *  of the vertical constraints to break (if absolutely needed).
         */
        let bottom = contentView.bottomAnchor.constraint(equalTo: newItemContentView.bottomAnchor)
        bottom.priority = .required - 1

        contentView.addSubview(newItemContentView, with: [
            contentView.readableContentGuide.leadingAnchor.constraint(equalTo: newItemContentView.leadingAnchor),
            contentView.readableContentGuide.trailingAnchor.constraint(equalTo: newItemContentView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: newItemContentView.topAnchor),
            bottom
        ])

        // this is the visible background color,
        // potentially adjusted by the system
        // during cell highlighting
        backgroundColor = SemanticColor.background
        // this just ensures the background color
        // from above, and potentially the highlight
        // state, is not obscured
        contentView.backgroundColor = .clear
        newItemContentView.backgroundColor = .clear

        listItemContentView = newItemContentView

        updateSeparatorAppearance()
    }

    // MARK: Separator

    public var separatorAppearance = ListItemSeparatorAppearance.none {
        didSet {
            if oldValue != separatorAppearance {
                updateSeparatorAppearance()
            }
        }
    }

    private weak var separatorView: UIView?

    private func updateSeparatorAppearance() {
        separatorView?.removeFromSuperview()
        guard separatorAppearance != .none, let listItemContentView = listItemContentView else {
            return
        }
        let separator = SeparatorView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: separatorAppearance == .inset ? listItemContentView.contentLayoutGuide.leadingAnchor : contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        separatorView = separator
    }
}
