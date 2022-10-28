//
//  UITableView+Reuse.swift
//  CircuitUI
//
//  Created by Hagi on 30.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

public extension UITableView {

    /**
     *  Registers table view cells for the given content configurations.
     *
     *  Use `dequeueReusableCell(configuration:indexPath:)` to obtain a
     *  reusable cell before applying content.
     *
     *  You can call this repeatedly, in case you obtain new configurations
     *  while the table view is already on screen (e.g., paginated loading).
     *
     *  Using the registration and dequeuing helpers is optional, but highly
     *  recommended for a smooth scrolling experience. In cases where you
     *  have uniform content configurations, you can also opt for a static
     *  reuse identifier, and register the appropriate table cell class
     *  (`ListItemTableViewCellAction` or `ListItemTableViewCellNavigation`)
     *  manually. Performance issues related to improper use of reuse
     *  identifiers will be logged to the console.
     */
    func register(actionCellConfigs: [ListContentConfigurationAction] = [], navigationCellConfigs: [ListContentConfigurationNavigation] = []) {
        guard !(actionCellConfigs.isEmpty && navigationCellConfigs.isEmpty) else {
            return
        }

        let uniqueActionConfigIDs = Set(actionCellConfigs.map { $0.reuseIdentifier })
        for actionID in uniqueActionConfigIDs {
            register(ListItemTableViewCellAction.self, forCellReuseIdentifier: actionID)
        }

        let uniqueNavigationConfigIDs = Set(navigationCellConfigs.map { $0.reuseIdentifier })
        for navigationID in uniqueNavigationConfigIDs {
            register(ListItemTableViewCellNavigation.self, forCellReuseIdentifier: navigationID)
        }
    }

    /**
     *  Dequeues an action cell for reuse.
     *
     *  Cells need to be registered via `register(actionCellConfigs:)` first.
     */
    func dequeueReusableCell(configuration: ListContentConfigurationAction, indexPath: IndexPath) -> ListItemTableViewCellAction {
        guard let cell = dequeueReusableCell(withIdentifier: configuration.reuseIdentifier, for: indexPath) as? ListItemTableViewCellAction else {
            fatalError("Failed to dequeue action cell for reuse identifier '\(configuration.reuseIdentifier)' at index path '\(indexPath)'")
        }

        return cell
    }

    /**
     *  Dequeues a navigation cell for reuse.
     *
     *  Cells need to be registered via `register(navigationCellConfigs:)` first.
     */
    func dequeueReusableCell(configuration: ListContentConfigurationNavigation, indexPath: IndexPath) -> ListItemTableViewCellNavigation {
        guard let cell = dequeueReusableCell(withIdentifier: configuration.reuseIdentifier, for: indexPath) as? ListItemTableViewCellNavigation else {
            fatalError("Failed to dequeue navigation cell for reuse identifier '\(configuration.reuseIdentifier)' at index path '\(indexPath)'")
        }

        return cell
    }

}
