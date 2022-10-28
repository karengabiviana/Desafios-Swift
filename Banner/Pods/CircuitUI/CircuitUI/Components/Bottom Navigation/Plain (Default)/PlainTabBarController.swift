//
//  PlainTabBarController.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 28/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

/**
 * Tab Bar Controller implementing the default Bottom Navigation style of Circuit UI.
 */
@objc(CUIPlainTabBarController)
public final class PlainTabBarController: TabBarController {
    @objc
    public init() {
        super.init(tabBarControllerView: PlainTabBarControllerView(tabBar: TabBar(appearance: .plain, axis: .horizontal, symmetricalSpacing: .none)))
    }
}

#endif
