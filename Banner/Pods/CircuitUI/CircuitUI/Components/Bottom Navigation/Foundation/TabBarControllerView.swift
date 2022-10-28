//
//  TabBarControllerView.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 18/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

class TabBarControllerView: UIView {

    let childContainerView = UIView()
    let tabBar: TabBar

    var tabBarContainerConstraintsVisible = [NSLayoutConstraint]()

    lazy var tabBarContainerConstraintHidden: NSLayoutConstraint = {
        tabBar.topAnchor.constraint(equalTo: bottomAnchor)
    }()

    private(set) var isTabBarHidden = false

    func setTabBarHidden(_ isHidden: Bool, animated: Bool) {
        self.isTabBarHidden = isHidden
        self.updateTabBarAppearance()
        UIView.animate(withDuration: animated ? AnimationDurationDefault : 0.0) {
            self.layoutIfNeeded()
        }
    }

    init(tabBar: TabBar) {
        self.tabBar = tabBar
        super.init(frame: .zero)
        configureViews()
        configureConstraints()
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureViews() {
        addSubview(childContainerView)
        addSubview(tabBar)

        backgroundColor = SemanticColor.background
    }

    private func updateTabBarAppearance() {
        let hiddenConstraint = tabBarContainerConstraintHidden
        let visibleConstraints = tabBarContainerConstraintsVisible

        let activeConstraints = isTabBarHidden ? [hiddenConstraint] : visibleConstraints
        let inactiveConstraints = !isTabBarHidden ? [hiddenConstraint] : visibleConstraints
        NSLayoutConstraint.deactivate(inactiveConstraints)
        NSLayoutConstraint.activate(activeConstraints)
    }

    func configureConstraints() {
        [childContainerView, tabBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout is done in the subclasses

    }
}
