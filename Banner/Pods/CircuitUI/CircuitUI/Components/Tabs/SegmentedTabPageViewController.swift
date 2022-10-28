//
//  SegmentedTabPageViewController.swift
//  CircuitUI
//
//  Created by Marcel Voß on 09.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

final class SegmentedTabPageViewController: UIPageViewController, SegmentedTabBase {

    // MARK: - Properties
    private let containedViewControllers: [UIViewController]

    // attempting to rapidly change a UIPageViewController's view controller can lead
    // to a crash about an unknown flushed view. this makes sure we're blocking rapidly
    // occuring changes: https://sumupteam.atlassian.net/browse/SA-47988
    private var isTransitioningPage = false

    var onDidNavigate: ((Int) -> Void)?

    var selectedIndex: Int {
        guard let currentViewController = viewControllers?.first else {
            return containedViewControllers.startIndex
        }

        return indexForViewController(currentViewController)
    }

    // MARK: - Initializers
    init(viewControllers: [UIViewController]) {
        self.containedViewControllers = viewControllers
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)

        configurePageViewController()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configurePageViewController() {
        delegate = self
        dataSource = self

        navigate(to: containedViewControllers.startIndex, skipCallback: true, animated: false)
    }

    // MARK: - Navigation
    func navigate(to index: Int, skipCallback: Bool, animated: Bool) {
        guard !isTransitioningPage else {
            if !skipCallback {
                onDidNavigate?(selectedIndex)
            }
            return
        }

        guard let nextViewController = containedViewControllers[safe: index] else {
            assertionFailure("index out of bounds.")
            return
        }

        isTransitioningPage = true

        setViewControllers([nextViewController],
                           direction: determineNavigationDirection(for: index),
                           animated: animated) { [weak self] _ in
            self?.isTransitioningPage = false
        }

        if !skipCallback {
            onDidNavigate?(index)
        }
    }

    private func determineNavigationDirection(for nextIndex: Int) -> UIPageViewController.NavigationDirection {
        // figure out the navigation direction by taking the user's layout direction into account
        let isLeftToRightInterface = view.effectiveUserInterfaceLayoutDirection == .leftToRight ? (nextIndex > selectedIndex) : (nextIndex <= selectedIndex)
        return isLeftToRightInterface ? .forward : .reverse
    }

}

// MARK: - UIPageViewControllerDataSource
extension SegmentedTabPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentViewControllerIndex = indexForViewController(viewController)
        return containedViewControllers[safe: currentViewControllerIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentViewControllerIndex = indexForViewController(viewController)
        return containedViewControllers[safe: currentViewControllerIndex + 1]
    }

    private func indexForViewController(_ viewController: UIViewController) -> Int {
        containedViewControllers.firstIndex(of: viewController) ?? .zero
    }
}

// MARK: - UIPageViewControllerDelegate
extension SegmentedTabPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed else {
            return
        }

        onDidNavigate?(selectedIndex)
    }
}
