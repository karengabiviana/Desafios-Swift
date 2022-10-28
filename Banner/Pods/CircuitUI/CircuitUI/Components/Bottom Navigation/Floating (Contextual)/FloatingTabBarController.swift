//
//  FloatingTabBarController.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 28/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

/**
 * Tab Bar Controller implementing the "contextual" Bottom Navigation style of Circuit UI.
 */
@objc(CUIFloatingTabBarController)
public final class FloatingTabBarController: TabBarController {

    // MARK: - Initializers
    // This is initializer is only available to not introduce a breaking API change by adding a parameter for the axis.
    // Once we have to introduce a breaking change, we should remove this again.
    @objc
    public convenience init() {
        self.init(axis: .horizontal)
    }

    @objc
    public init(axis: TabBarAxis) {
        super.init(tabBarControllerView: FloatingTabBarControllerView(tabBar: TabBar(appearance: .floating, axis: axis, symmetricalSpacing: .mega)))
    }

    // MARK: - Layout
    private func updateChildControllersLayoutIfNeeded() {
        let newInsets: UIEdgeInsets

        switch tabBarControllerView.tabBar.axis {
        case .vertical:
            let leadingInset: CGFloat = tabBarControllerView.tabBar.frame.maxX
            newInsets = UIEdgeInsets(top: .zero, left: leadingInset, bottom: .zero, right: .zero)
        case .horizontal:
            let bottomInset = tabBarControllerView.bounds.height - tabBarControllerView.tabBar.frame.minY - tabBarControllerView.safeAreaInsets.bottom
            newInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: bottomInset, right: .zero)
        }

        viewControllers.forEach {
            if $0.additionalSafeAreaInsets != newInsets {
                $0.additionalSafeAreaInsets = newInsets
            }
        }
    }

    override func didUpdateTabViewControllers() {
        updateChildControllersLayoutIfNeeded()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateChildControllersLayoutIfNeeded()
    }
}

#endif
