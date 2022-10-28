//
//  UICollectionView+Reuse.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 15/12/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

public extension UICollectionView {

    /**
     *  Registers collection view cells for the given content configurations.
     *
     *  Use `dequeueReusableCell(configuration:indexPath:)` to obtain a
     *  reusable cell before applying content.
     *
     *  You can call this repeatedly, in case you obtain new configurations
     *  while the collection view is already on screen (e.g., paginated loading).
     *
     *  Using the registration and dequeuing helpers is optional, but highly
     *  recommended for a smooth scrolling experience. In cases where you
     *  have uniform content configurations, you can also opt for a static
     *  reuse identifier, and register the appropriate collection cell class
     *  (`ListItemCollectionViewCellAction` or `ListItemCollectionViewCellNavigation`)
     *  manually. Performance issues related to improper use of reuse
     *  identifiers will be logged to the console.
     */
    func register(actionCellConfigs: [ListContentConfigurationAction] = [], navigationCellConfigs: [ListContentConfigurationNavigation] = []) {
        guard !(actionCellConfigs.isEmpty && navigationCellConfigs.isEmpty) else {
            return
        }

        let uniqueActionConfigIDs = Set(actionCellConfigs.map { $0.reuseIdentifier })
        for actionID in uniqueActionConfigIDs {
            register(ListItemCollectionViewCellAction.self, forCellWithReuseIdentifier: actionID)
        }

        let uniqueNavigationConfigIDs = Set(navigationCellConfigs.map { $0.reuseIdentifier })
        for navigationID in uniqueNavigationConfigIDs {
            register(ListItemCollectionViewCellNavigation.self, forCellWithReuseIdentifier: navigationID)
        }
    }

    /**
     *  Dequeues an action cell for reuse.
     *
     *  Cells need to be registered via `register(actionCellConfigs:)` first.
     */
    func dequeueReusableCell(configuration: ListContentConfigurationAction, indexPath: IndexPath) -> ListItemCollectionViewCellAction {
        guard let cell = dequeueReusableCell(withReuseIdentifier: configuration.reuseIdentifier, for: indexPath) as? ListItemCollectionViewCellAction else {
            fatalError("Failed to dequeue action cell for reuse identifier '\(configuration.reuseIdentifier)' at index path '\(indexPath)'")
        }

        return cell
    }

    /**
     *  Dequeues a navigation cell for reuse.
     *
     *  Cells need to be registered via `register(navigationCellConfigs:)` first.
     */
    func dequeueReusableCell(configuration: ListContentConfigurationNavigation, indexPath: IndexPath) -> ListItemCollectionViewCellNavigation {
        guard let cell = dequeueReusableCell(withReuseIdentifier: configuration.reuseIdentifier, for: indexPath) as? ListItemCollectionViewCellNavigation else {
            fatalError("Failed to dequeue navigation cell for reuse identifier '\(configuration.reuseIdentifier)' at index path '\(indexPath)'")
        }

        return cell
    }

}
