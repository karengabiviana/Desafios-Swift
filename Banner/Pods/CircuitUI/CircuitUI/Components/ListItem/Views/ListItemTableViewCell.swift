//
//  ListItemTableViewCell.swift
//  CircuitUI
//
//  Created by Andras Kadar on 06.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

// MARK: - Public Cell Classes

/**
 *  Use this cell class for single- and multiline action cells.
 *
 *  You should not instantiate these cells directly. Instead, use
 *  the helpers provided in `UITableView+Reuse` to register and
 *  dequeue cells.
 */
public final class ListItemTableViewCellAction: ListItemTableViewCell {

    /// Applies the given configuration to the cell.
    public func applyConfiguration(_ configuration: ListContentConfigurationAction) {
        super.applyConfiguration(configuration)
    }

}

/**
 *  Use this cell class for single- and multiline navigation cells.
 *
 *  You should not instantiate these cells directly. Instead, use
 *  the helpers provided in `UITableView+Reuse` to register and
 *  dequeue cells.
 */
public final class ListItemTableViewCellNavigation: ListItemTableViewCell {

    /// Applies the given configuration to the cell.
    public func applyConfiguration(_ configuration: ListContentConfigurationNavigation) {
        super.applyConfiguration(configuration)
    }

}

// MARK: - Base Class

/**
 *  Base class for list items. Do not use directly. Instead, use
 *  `ListItemTableViewCellAction` or `ListItemTableViewCellNavigation`.
 */
public class ListItemTableViewCell: UITableViewCell {

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
        switch configuration.selectionStyle {
        case .default:
            selectionStyle = .default
        case .none:
            selectionStyle = .none
        }
        listItemContentView = newItemContentView
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
       listItemContentView?.isSelected = selected
   }

}

// MARK: - Internal Helpers/Types

enum ListItemConfigurationError: Error {

    /**
     *  This error signals that the cell cannot be reused for a given
     *  configuration, as one or more elements have a different element type
     *  than the previous configuration.
     *
     *  This is recoverable gracefully by re-inserting a new content view.
     */
    case elementTypeMismatch

    /**
     *  This error signals that the cell cannot be reused for a given
     *  configuration, as a single-line configuration was passed to a cell
     *  which was previously set up for a multiline configuration, or
     *  vice-versa.
     *
     *  This is recoverable gracefully by re-inserting a new content view.
     */
    case contentViewTypeMismatch

    /**
     *  This error signals that the cell cannot be reused for a given
     *  configuration, as previously added constraints conflicts with
     *  the new configuration's desired constraints.
     *
     *  This is recoverable gracefully by re-inserting a new content view.
     */
    case constraintsMismatch

    /**
     *  This error signals that we attempted to reuse and re-configure
     *  a configuration that does not support reuse to begin with.
     *
     *  This is recoverable gracefully by re-inserting a new content view.
     */
    case reuseNotSupported
}

/**
 *  Abstracts several content view implementations.
 */
protocol ListItemContentView: UIView {

    /**
     *  The currently applied configuration.
     */
    var configuration: ListContentConfiguration { get }

    /**
     *  Creates an initial content view, based on the given configuration.
     */
    init(configuration: ListContentConfiguration)

    /**
     *  Applies the given configuration, reusing the existing view hierarchy.
     *  Should throw a `ListItemConfigurationError` if the configuration
     *  cannot be applied as it conflicts with the initially configured view
     *  hierarchy.
     *
     *  Should set the `configuration`property once applied successfully.
     */
    func applyConfiguration(_ newConfiguration: ListContentConfiguration) throws

    /**
     *  Layout guide representing the content beyond the leading element.
     *  It can be used to align visual chrome such as separator lines,
     *  respecting content's leading edge.
     */
    var contentLayoutGuide: UILayoutGuide { get }

    /**
     *  The containing view should set and update this property to reflect the selection state in its content view.
     */
    var isSelected: Bool { get set }
}
