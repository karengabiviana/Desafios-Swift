//
//  PlainTabBarControllerView.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 28/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

final class PlainTabBarControllerView: TabBarControllerView {

    override func configureConstraints() {
        super.configureConstraints()

        let tabBarContainerBottomConstraint = tabBar.bottomAnchor.constraint(equalTo: bottomAnchor)

        tabBarContainerConstraintsVisible = [tabBarContainerBottomConstraint, tabBar.stackViewSafeAreaBottomConstraint].compactMap { $0 }

        NSLayoutConstraint.activate([
            childContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            childContainerView.topAnchor.constraint(equalTo: topAnchor),
            childContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            childContainerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),

            tabBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            tabBarContainerBottomConstraint,
            tabBar.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        tabBar.setContentCompressionResistancePriority(.required, for: .vertical)
        tabBar.setContentHuggingPriority(.required, for: .vertical)
    }
}

#endif
