//
//  TabletSideNavigationViewController.swift
//  CircuitUI
//
//  Created by Marcel Voß on 23.02.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

import CircuitUI_Private
import SumUpUtilities
import UIKit

@objc(CUITabletSideNavigationViewControllerDelegate)
public protocol TabletSideNavigationViewControllerDelegate: AnyObject {
    func sideNavigationViewController(_ sideViewController: TabletSideNavigationViewController,
                                      didSelect viewController: UIViewController)
}

@objc(CUITabletSideNavigationViewController)
@objcMembers
open class TabletSideNavigationViewController: ViewController {

    // MARK: - Properties

    // while this object uses the publicly accessible TabBarController object under the hood,
    // we consider this an implementation detail and therefore keep this information private and
    // only use this for ourselves to e.g. set delegates or perform tab selection events.
    private let tabControllerView = TabletSideNavigationTabBarControllerView()
    private lazy var floatingTabBarController = TabBarController(tabBarControllerView: tabControllerView)

    public var isSidebarHidden: Bool {
        tabControllerView.isSidebarHidden
    }

    public var isTabBarHidden: Bool {
        // if either is true, the tab bar is currently not visible.
        isSidebarHidden || floatingTabBarController.isTabBarHidden
    }

    /// The view that is shown as the top accessory view in the sidebar.
    ///
    /// Assigning `nil` to this property removes the contained view from the view hiearchy.
    public var topAccessoryView: UIView? {
        didSet {
            tabControllerView.topAccessoryView = topAccessoryView
        }
    }

    /// The view that is shown as the bottom accessory view in the sidebar.
    ///
    /// Assigning `nil` to this property removes the contained view from the view hiearchy.
    public var bottomAccessoryView: UIView? {
        didSet {
            tabControllerView.bottomAccessoryView = bottomAccessoryView
        }
    }

    public var selectedViewController: UIViewController? {
        floatingTabBarController.selectedViewController
    }

    public weak var delegate: TabletSideNavigationViewControllerDelegate?

    public let viewControllers: [UIViewController]

    // MARK: - Initializers
    /// Initializes and returns a newly created side navigation controller.
    /// - Parameter viewControllers: The view controllers that should be presented initially.
    ///
    /// In order to present this correctly, there must be least one view controller.
    public init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    // MARK: - Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()

        configureTabBarController()

        presentViewControllers(viewControllers)
        view.backgroundColor = SemanticColor.background
        assert(navigationController == nil, "This component is not meant for presentation within a UINavigationController.")
    }

    // MARK: - Customization
    private func configureTabBarController() {
        floatingTabBarController.delegate = self
        floatingTabBarController.willMove(toParent: self)
        addChild(floatingTabBarController)
        view.addSubview(floatingTabBarController.view,
                        with: floatingTabBarController.view.constrain(toEdgesOf: view))
        floatingTabBarController.didMove(toParent: self)

        view.layoutIfNeeded()

        setTabBarHidden(isTabBarHidden, animated: false)
    }

    // MARK: - Actions
    /// Presents the given view controllers in the bounds of the container.
    /// - Parameter viewControllers: The view controllers that should be presented.
    private func presentViewControllers(_ viewControllers: [UIViewController]) {
        guard viewControllers.count >= 1 else {
            assertionFailure("At least one view controller needs to be presented.")
            return
        }

        floatingTabBarController.viewControllers = viewControllers
        setSelected(index: viewControllers.startIndex, animated: false)

        floatingTabBarController.viewControllers.forEach {
            // hide the navigation bar for all view controllers,
            // as we provide our own custom navigation header here.
            prepareViewControllerControllerForPresentation($0 as? NavigationController)
        }

        updateTabBarVisibility(animated: false)
    }

    public func setSelected(index newIndex: Int, animated: Bool = false) {
        floatingTabBarController.setSelected(index: newIndex, animated: animated)

        guard let selectedViewController = selectedViewController else {
            assertionFailure("selectedViewController can not be empty after a selection has occured.")
            return
        }

        prepareViewControllerControllerForPresentation(selectedViewController as? NavigationController)
    }

    private func prepareViewControllerControllerForPresentation(_ navController: NavigationController?) {
        guard let navController = navController else {
            return
        }

        interceptNavigationEvents(navController)
    }

    public func setSidebarHidden(_ hidden: Bool, animated: Bool) {
        tabControllerView.setSidebarHidden(hidden, animated: animated)
    }

    public func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        floatingTabBarController.setTabBarHidden(hidden, animated: animated)
    }

    private func updateTabBarVisibility(animated: Bool) {
        // if there's only a single tab for this view controller, we want to make the screen
        // appear, as if there's no tab bar (therefore we hide it accordingly).
        setTabBarHidden(viewControllers.count == 1, animated: animated)
    }

    private func updateSidebarVisibility(animated: Bool) {
        guard let navController = selectedViewController as? UINavigationController else {
                  // if we don't have an navigation controller, we won't mess with the sidebar
                  // visibility ourselves, but keep what has been set within the tab controller view.
            return
        }

        // if we're two levels deep into the navigation hierarchy, we want to hide the sidebar
        // and stretch the child view controller's content to fill the entire screen (excluding the header of course).
        tabControllerView.setSidebarHidden(navController.viewControllers.count > 1, animated: animated)
    }

    private func interceptNavigationEvents(_ viewController: UIViewController) {
        guard let navigationController = viewController as? NavigationController else {
            assert(!(viewController is UINavigationController), """
            =======================================================
            Usage of `UINavigationController` in the `TabBarController`
            is deprecated. Please use `NavigationController` instead.
            This will add support for `hidesBottomBarWhenPushed` and
            new features that will be added in the future.
            =======================================================
            """)
            return
        }
        navigationController.interceptingDelegate = self
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }

}

// MARK: - UINavigationControllerDelegate
extension TabletSideNavigationViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let navigationController = navigationController as? NavigationController else {
            assertionFailure("contained navigation controller must inherit from NavigationController.")
            return
        }

        func updateViewState(animated: Bool) {
            updateSidebarVisibility(animated: animated)
            updateTabBarVisibility(animated: animated)
        }

        prepareViewControllerControllerForPresentation(navigationController)

        guard let coordinator = navigationController.transitionCoordinator, animated else {
            updateViewState(animated: false)
            return
        }

        // we make sure that before we transition and get the bounds of the tab controller view below
        // that we perform a layout cycle beforehand to get the correct size ahead of completing the transition.
        view.layoutIfNeeded()
        viewController.view.layoutIfNeeded()
        tabControllerView.layoutIfNeeded()

        coordinator.animate(alongsideTransition: { ctx in
            // when doing the transition for the first time, we inherit a duration of 0 for some reason,
            // this can be checked via UIView.inheritedAnimationDuration.
            // for this reason we nest the animation with the context's duration and override just the duration,
            // but keep the timing curve of the parent animation.
            UIView.animate(withDuration: ctx.transitionDuration, delay: .zero, options: [.overrideInheritedDuration], animations: { [self] in
                updateViewState(animated: true)

                // we manually set the size of the to-be presented view controller, as pushing a view controller
                // within a UINavigationController uses the size of the currently top most view controller. this is
                // not quite correct in this case, as the size of the contained view controller might changes in size
                // while the transition occures.
                viewController.view.frame = tabControllerView.childContainerView.bounds
                viewController.view.layoutIfNeeded()
            }, completion: nil)
        }, completion: { _ in
            // we need to update in didShow in case the back gesture was aborted
            updateViewState(animated: true)
        })
    }
}

// MARK: - TabBarControllerDelegate
extension TabletSideNavigationViewController: TabBarControllerDelegate {
    public func tabBarController(_ controller: TabBarController,
                                 didSelect viewController: UIViewController) {
        prepareViewControllerControllerForPresentation(viewController as? NavigationController)

        delegate?.sideNavigationViewController(self, didSelect: viewController)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TabletSideNavigationViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // because we use a custom UINavigationBar and modify it ourselves, we have to manually
        // tell the navigation controller that it can not use the interactive pop gesture. while theoretically
        // possible, we don't have any control over the interaction... this could be solved with a custom UINavigationController
        // implementation or maybe some sort of KVO. for the sake of time/value, I consider this good enough for the time being, given
        // the edge swipe gesture shouldn't be very common on iPad (and our previously in place custom navigation bar didn't support it either).
        return false
    }
}

#endif
