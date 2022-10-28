//
//  SegmentedTabBaseViewController.swift
//  CircuitUI
//
//  Created by Marcel Voß on 13.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

protocol SegmentedTabBase {
    var selectedIndex: Int { get }
    var onDidNavigate: ((Int) -> Void)? { get set }

    func navigate(to index: Int, skipCallback: Bool, animated: Bool)
}

typealias SegmentedTabBaseViewController = SegmentedTabBase & UIViewController
