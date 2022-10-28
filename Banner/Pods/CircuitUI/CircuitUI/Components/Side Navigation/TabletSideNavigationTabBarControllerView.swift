//
//  TabletSideNavigationTabBarControllerView.swift
//  CircuitUI
//
//  Created by Marcel Voß on 24.02.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

import SumUpUtilities
import UIKit

/// A custom `TabBarControllerView` subclass that supports a leading
/// sidebar for arranging its contained tab bar.
final class TabletSideNavigationTabBarControllerView: TabBarControllerView {

    // MARK: - Properties
    var topAccessoryView: UIView? {
        didSet {
            guard topAccessoryView !== oldValue else {
                // return early, if there's no change
                return
            }

            guard topAccessoryView != nil else {
                // remove view if nil is assigned
                oldValue?.removeFromSuperview()
                return
            }

            configureAccessoryView(topAccessoryView, in: topAccessoryContainerGuide)
        }
    }

    var bottomAccessoryView: UIView? {
        didSet {
            guard bottomAccessoryView !== oldValue else {
                // return early, if there's no change
                return
            }

            guard bottomAccessoryView != nil else {
                // remove view if nil is assigned
                oldValue?.removeFromSuperview()
                return
            }

            configureAccessoryView(bottomAccessoryView, in: bottomAccessoryContainerGuide)
        }
    }

    // we use this layout guide, in order to be able to easily remove/add
    // accessories without having to manually mess with constraint activation and
    // deactivation each time. this is also more efficient than using (rendering) container views.
    private let topAccessoryContainerGuide = UILayoutGuide()
    private let bottomAccessoryContainerGuide = UILayoutGuide()

    private let sidebarView = UIView()

    private lazy var sidebarVisibleConstraint = sidebarView.leadingAnchor.constraint(equalTo: leadingAnchor)
    private lazy var sidebarHiddenConstraint = sidebarView.trailingAnchor.constraint(equalTo: leadingAnchor)

    private(set) var isSidebarHidden: Bool {
        get {
            sidebarHiddenConstraint.isActive && !sidebarVisibleConstraint.isActive
        } set {
            let constraintToActivate = newValue ? sidebarHiddenConstraint : sidebarVisibleConstraint
            let constraintToDeactivate = newValue ? sidebarVisibleConstraint : sidebarHiddenConstraint

            constraintToDeactivate.isActive = false
            constraintToActivate.isActive = true
        }
    }

    // MARK: - Initializers
    init() {
        super.init(tabBar: TabBar(appearance: .floating, axis: .vertical, symmetricalSpacing: .mega))
    }

    // MARK: - Customization
    override func configureViews() {
        // we do not call super on purpose here, as the super class'
        // implementation adds the tab bar and the child container view
        // to incorrect views for what we want to achieve here.

        configureSidebar()
        configureAccessoryViews()

        addSubview(childContainerView)
    }

    private func configureAccessoryViews() {
        configureAccessoryView(topAccessoryView, in: topAccessoryContainerGuide)
        configureAccessoryView(bottomAccessoryView, in: bottomAccessoryContainerGuide)
    }

    private func configureSidebar() {
        sidebarView.backgroundColor = SemanticColor.background
        sidebarView.layoutMargins = UIEdgeInsets(vertical: .mega, horizontal: .mega)
        sidebarView.addSubview(tabBar)

        addSubview(sidebarView, with: [
            sidebarVisibleConstraint,
            sidebarView.topAnchor.constraint(equalTo: topAnchor),
            sidebarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sidebarView.widthAnchor.constraint(equalToConstant: 132)
        ])

        sidebarView.addLayoutGuide(topAccessoryContainerGuide, with: [
            topAccessoryContainerGuide.topAnchor.constraint(equalTo: sidebarView.safeAreaLayoutGuide.topAnchor, spacing: .mega),
            topAccessoryContainerGuide.leadingAnchor.constraint(greaterThanOrEqualTo: sidebarView.safeAreaLayoutGuide.leadingAnchor),
            topAccessoryContainerGuide.trailingAnchor.constraint(lessThanOrEqualTo: sidebarView.safeAreaLayoutGuide.trailingAnchor),
            topAccessoryContainerGuide.centerXAnchor.constraint(equalTo: sidebarView.safeAreaLayoutGuide.centerXAnchor)
        ])

        sidebarView.addLayoutGuide(bottomAccessoryContainerGuide, with: [
            bottomAccessoryContainerGuide.bottomAnchor.constraint(equalTo: sidebarView.safeAreaLayoutGuide.bottomAnchor, spacing: -.mega),
            bottomAccessoryContainerGuide.leadingAnchor.constraint(greaterThanOrEqualTo: sidebarView.safeAreaLayoutGuide.leadingAnchor),
            bottomAccessoryContainerGuide.trailingAnchor.constraint(lessThanOrEqualTo: sidebarView.safeAreaLayoutGuide.trailingAnchor),
            bottomAccessoryContainerGuide.centerXAnchor.constraint(equalTo: sidebarView.safeAreaLayoutGuide.centerXAnchor)
        ])

        setSidebarHidden(isSidebarHidden, animated: false)
    }

    private func configureAccessoryView(_ accessoryView: UIView?, in containerGuide: UILayoutGuide) {
        guard let safeAccessoryView = accessoryView else {
            return
        }

        safeAccessoryView.setContentCompressionResistancePriority(.required, for: .vertical)

        sidebarView.addSubview(safeAccessoryView,
                               with: safeAccessoryView.constrain(toEdgesOf: containerGuide))
    }

    override func configureConstraints() {
        super.configureConstraints()

        let safeAreaPin: NSLayoutConstraint
        let minimumBottomMargin: NSLayoutConstraint

        let tabBarConstraints: [NSLayoutConstraint]

        // we have to override the hidden constraints, in order to properly animate appearance
        // and disappearance transitions of the tab bar in vertical mode.
        tabBarContainerConstraintHidden = tabBar.trailingAnchor.constraint(equalTo: sidebarView.leadingAnchor)

        safeAreaPin = tabBar.leadingAnchor.constraint(equalTo: sidebarView.leadingAnchor)
        minimumBottomMargin = tabBar.leadingAnchor.constraint(greaterThanOrEqualTo: sidebarView.leadingAnchor, spacing: .mega)

        tabBarConstraints = [
            tabBar.centerYAnchor.constraint(equalTo: sidebarView.centerYAnchor),
            tabBar.topAnchor.constraint(greaterThanOrEqualTo: topAccessoryContainerGuide.bottomAnchor, spacing: .mega),
            tabBar.bottomAnchor.constraint(lessThanOrEqualTo: bottomAccessoryContainerGuide.topAnchor, spacing: -.mega),
            tabBar.centerXAnchor.constraint(equalTo: sidebarView.centerXAnchor),

            // we have to artificially limit the width of the tab bar, to not allow it to grow
            // as wide as the widest tab bar item contained within it. if the text is any wider,
            // its contents are going to be truncated.
            tabBar.widthAnchor.constraint(equalToConstant: 80)
        ]

        safeAreaPin.priority = .defaultHigh
        minimumBottomMargin.priority = .required

        tabBarContainerConstraintsVisible = [minimumBottomMargin, safeAreaPin]

        NSLayoutConstraint.activate([
            childContainerView.leadingAnchor.constraint(equalTo: sidebarView.trailingAnchor),
            childContainerView.topAnchor.constraint(equalTo: topAnchor),
            childContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            childContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            safeAreaPin,
            minimumBottomMargin
        ] + tabBarConstraints)
    }

    // MARK: - Actions
    func setSidebarHidden(_ hidden: Bool, animated: Bool) {
        guard animated else {
            isSidebarHidden = hidden
            return
        }

        // we want to inherit the animation duration from the parent animation here if possible.
        // if there's no parent animation, we still want to animate this.
        UIView.animate(withDuration: 0.2, delay: .zero) { [self] in
            isSidebarHidden = hidden
        }
    }

}

#endif
