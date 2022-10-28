//
//  FloatingTabBarControllerView.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 28/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

final class FloatingTabBarControllerView: TabBarControllerView {

    override func configureConstraints() {
        super.configureConstraints()

        let safeAreaPin: NSLayoutConstraint
        let minimumBottomMargin: NSLayoutConstraint

        let tabBarConstraints: [NSLayoutConstraint]

        switch tabBar.axis {
        case .vertical:
            // we have to override the hidden constraints, in order to properly animate appearance
            // and disappearance transitions of the tab bar in vertical mode.
            tabBarContainerConstraintHidden = tabBar.trailingAnchor.constraint(equalTo: leadingAnchor)

            safeAreaPin = tabBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
            minimumBottomMargin = tabBar.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, spacing: .mega)

            tabBarConstraints = [
                tabBar.centerYAnchor.constraint(equalTo: centerYAnchor),
                tabBar.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, spacing: .mega),
                tabBar.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, spacing: -.mega),

                // we have to artificially limit the width of the tab bar, to not allow it to grow
                // as wide as the widest tab bar item contained within it. if the text is any wider,
                // its contents are going to be truncated.
                tabBar.widthAnchor.constraint(lessThanOrEqualToSpacing: .yotta)
            ]
        case .horizontal:
            safeAreaPin = tabBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            minimumBottomMargin = tabBar.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, spacing: -.mega)

            tabBarConstraints = [
                tabBar.centerXAnchor.constraint(equalTo: centerXAnchor),
                tabBar.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, spacing: .mega),
                tabBar.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, spacing: -.mega)
            ]
        }

        safeAreaPin.priority = .defaultHigh
        minimumBottomMargin.priority = .required

        tabBarContainerConstraintsVisible = [minimumBottomMargin, safeAreaPin]

        NSLayoutConstraint.activate([
            childContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            childContainerView.topAnchor.constraint(equalTo: topAnchor),
            childContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            childContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            safeAreaPin,
            minimumBottomMargin
        ] + tabBarConstraints)
    }

}

#endif
