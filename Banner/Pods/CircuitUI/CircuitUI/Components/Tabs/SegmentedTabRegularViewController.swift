//
//  SegmentedTabRegularViewController.swift
//  CircuitUI
//
//  Created by Marcel Voß on 09.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import SumUpUtilities
import UIKit

final class SegmentedTabRegularViewController: SegmentedTabBaseViewController {

    // MARK: - Properties
    private var isTransitioning = false

    let viewControllers: [UIViewController]

    var onDidNavigate: ((Int) -> Void)?

    private(set) var selectedIndex: Int = 0

    // MARK: - Initializers
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private weak var currentViewController: UIViewController?

    // MARK: - Navigation
    func navigate(to index: Int, skipCallback: Bool, animated: Bool) {
        guard !isTransitioning else {
            if let safeCurrentViewController = currentViewController,
               let oldIndex = viewControllers.firstIndex(of: safeCurrentViewController),
               !skipCallback {
                // reset the view controller's status to the
                // previously set index (i.e. undo the selection).
               onDidNavigate?(oldIndex)
            }
            return
        }

        let oldViewController = currentViewController
        guard let newViewController = viewControllers[safe: index] else {
            assertionFailure("index out of bounds.")
            return
        }

        beginTransition(from: oldViewController, to: newViewController)
        finishTransition(from: oldViewController, to: newViewController)

        selectedIndex = index

        if !skipCallback {
            onDidNavigate?(index)
        }
    }

    private func beginTransition(from fromViewController: UIViewController?,
                                 to toViewController: UIViewController) {

        isTransitioning = true
        currentViewController = toViewController

        addChildViewController(toViewController, in: view)
        fromViewController?.willMove(toParent: nil)
    }

    private func finishTransition(from fromViewController: UIViewController?,
                                  to toViewController: UIViewController) {
        toViewController.didMove(toParent: self)

        fromViewController?.view.removeFromSuperview()
        fromViewController?.removeFromParent()
        fromViewController?.didMove(toParent: nil)

        isTransitioning = false
    }

}
