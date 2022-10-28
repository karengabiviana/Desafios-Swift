//
//  TabBarController.swift
//  SMPTabBarController
//
//  Created by Felix Lamouroux on 02.07.18.
//  Copyright © 2018 Sumup Ltd. All rights reserved.
//

#if canImport(CircuitUI_Private)
import CircuitUI_Private
import SumUpUtilities
import UIKit

@objc(CUITabBarControllerChildController)
public protocol TabBarControllerChildContoller: AnyObject {
    /// Called on the child controller to ask it to reset.
    /// This happens e.g. when tapping the selected tab bar item again.
    /// UINavigationControllers are automatically popped to root unless they implement this protocol.
    @objc optional func tabBarController(_ controller: TabBarController, resetAnimated: Bool)
    @objc optional func tabBarController(_ controller: TabBarController, didMakeActive: Bool)
}

@objc(CUITabBarControllerDelegate)
public protocol TabBarControllerDelegate: AnyObject {
    /// Tells the delegate that the user selected an item in the tab bar.
    /// - Parameters:
    ///   - controller: The tab bar controller containing viewController.
    ///   - viewController: The view controller that the user selected.
    @objc(tabBarController:didSelectViewController:)
    func tabBarController(_ controller: TabBarController, didSelect viewController: UIViewController)
}

@objc(CUITabBarController)
public class TabBarController: ViewController {

    let tabBarControllerView: TabBarControllerView

    public var isTabBarHidden: Bool {
        tabBarControllerView.isTabBarHidden
    }

    @objc
    public func setTabBarHidden(_ hidden: Bool, animated: Bool = false) {
        tabBarControllerView.setTabBarHidden(hidden, animated: animated)
    }

    override public var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }

    /// The index of the currently visible view controller.
    /// Call setSelected(index:) to change the index.
    @objc public private(set) var selectedIndex = 0

    @objc public weak var delegate: TabBarControllerDelegate?

    /// Changes the visible view controller.
    ///
    /// - Parameters:
    ///   - newIndex: The index of the view controller to show.
    ///   - animated: If true the change may be animated.
    @objc(setSelectedIndex:animated:)
    public func setSelected(index newIndex: Int, animated: Bool = false) {
        guard newIndex != selectedIndex else {
            resetCurrentViewController(animated: animated)
            return
        }

        let oldValue = selectedIndex
        selectedIndex = newIndex

        tabBarControllerView.tabBar.selectedIndex = newIndex
        updateVisibility(oldIndex: oldValue, triggerAppearanceCalls: true, animated: animated)
    }

    private func resetCurrentViewController(animated: Bool) {
        guard let vc = selectedViewController else {
            assertionFailure("no current view controller")
            return
        }

        if let childController = vc as? TabBarControllerChildContoller {
            childController.tabBarController?(self, resetAnimated: animated)
            return
        }

        let navc = vc as? UINavigationController
        navc?.popToRootViewController(animated: animated)
    }

    /// The currently visible view controller or nil if none is visible.
    @objc public var selectedViewController: UIViewController? {
        viewControllers[safe: selectedIndex]
    }

    /// Changes the visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to display. Providing a view
    ///                     controller that is not part of this
    ///                     TabBarController's viewControllers results
    ///                     in no change.
    ///   - animated: If true the change may be animated.
    public func setSelected(viewController: UIViewController, animated: Bool = false) {
        guard let index = viewControllers.firstIndex(of: viewController) else {
            assertionFailure("view controller is not part of this tabbar controller")
            return
        }

        setSelected(index: index, animated: animated)
    }

    private func notifyDelegateAboutSelectedViewController() {
        delegate?.tabBarController(self, didSelect: viewControllers[selectedIndex])
    }

    // MARK: - ChildViewControllers

    private class ContainerWrapperVC: ViewController {
        override var shouldAutomaticallyForwardAppearanceMethods: Bool {
            // the child view controllers contained in the wrapper do not appear alongside the wrapper,
            // but rather only when there are selected by the TabBarController
            return false
        }
    }

    /// To avoid setting the additionalSafeAreaInsets directly on each child
    /// view controller, we wrap them in a container view controller.
    /// - note: The fact that the wrapper class is private also helps to disintermediate
    /// the children from the tabbar (asking for the parent does not yield the
    /// tabbar controller for implicit manipulation).
    private let childContainerWrapperViewController = ContainerWrapperVC()

    /// The view controllers displayed by the tabbar controller. Only one will
    /// be visible at a time. The viewControllers may not be direct children of
    /// the TabBarController
    @objc public var viewControllers: [UIViewController] = [] {
        didSet {
            loadViewIfNeeded()

            for oldVC in oldValue {
                removeChildViewController(oldVC)
            }

            guard childContainerWrapperViewController.view.superview != nil else {
                assertionFailure("childContainerWrapperViewController is not in view")
                return
            }

            for newVC in viewControllers {
                assert(newVC.parent == nil, "viewControllers should not previously be part of other view controllers")

                childContainerWrapperViewController.addChildViewController(newVC, in: childContainerWrapperViewController.view)
                interceptNavigationEvents(newVC)
            }

            updateVisibility()
            tabBarControllerView.tabBar.items = viewControllers.map { $0.tabBarItem }
            didUpdateTabViewControllers()

            // in case we are updating the viewControllers while being visible, or in transition:
            // cascade appearance information into
            if isBeingPresented || isVisible || isBeingDismissed {
                selectedViewController?.beginAppearanceTransition(!isBeingDismissed, animated: false)
            }

            if isVisible {
                selectedViewController?.endAppearanceTransition()
            }
        }
    }

    /// For any additional updates
    func didUpdateTabViewControllers() {}

    private func updateVisibility(oldIndex: Int? = nil, triggerAppearanceCalls: Bool = false, animated: Bool = false) {
        viewControllers.enumerated().forEach { index, vc in
            let isHidden = index != selectedIndex

            // set hidden state and call appearance methods on presented
            guard index != oldIndex && isHidden else {
                // before making a child visible, let's make sure the layout margins are up-to-date
                vc.view.layoutMargins = view.layoutMargins
                vc.view.setNeedsLayout()

                if triggerAppearanceCalls {
                    vc.beginAppearanceTransition(!isHidden, animated: animated)
                }
                vc.view.isHidden = isHidden
                guard triggerAppearanceCalls else {
                  return
                }
                vc.endAppearanceTransition()
                let isActive = index != oldIndex && !isHidden
                // notify child it's active/inactive
                if let childController = vc as? TabBarControllerChildContoller {
                    childController.tabBarController?(self, didMakeActive: isActive)
                    return
                }
                // there are cases when the child is a UINavigationViewController
                guard let navc = vc as? UINavigationController, let childController = navc.viewControllers.first as? TabBarControllerChildContoller else {
                    return
                }
                childController.tabBarController?(self, didMakeActive: isActive)
                return
            }

            // ensure all others are hidden
            vc.view.isHidden = isHidden
        }

        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: { [self] in
                        setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    // MARK: Show / hide on push

    private var presentedNavigationControllers = Set<Int>()

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
    }

    // MARK: - Initializers
    init(tabBarControllerView: TabBarControllerView) {
        self.tabBarControllerView = tabBarControllerView

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable)
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func loadView() {
        view = tabBarControllerView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        tabBarControllerView.tabBar.onIndexSelection = { [weak self] index in
            self?.setSelected(index: index, animated: true)
            self?.notifyDelegateAboutSelectedViewController()
        }

        let safeContainer = tabBarControllerView.childContainerView
        addChildViewController(childContainerWrapperViewController, in: safeContainer)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedViewController?.beginAppearanceTransition(true, animated: animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedViewController?.endAppearanceTransition()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedViewController?.beginAppearanceTransition(false, animated: animated)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedViewController?.endAppearanceTransition()
    }
}

extension TabBarController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        /// When _tab_ is opened for the first, events are propagated to `NavigationController` and to it's root ViewController
        /// with content, it makes navigationController, to call delegate on first appearance.
        /// This in turn makes the view controller presentation be awkwardly animated along with TabBarController switching tabs.
        /// As tabbar for sure is visible, on the first controller in sequence, it makes sense to ignore the event completely,
        /// unless multiple controllers were pushed onto the stack.
        guard presentedNavigationControllers.contains(navigationController.hashValue) || navigationController.viewControllers.count > 1 else {
            presentedNavigationControllers.insert(navigationController.hashValue)
            return
        }
        setTabBarHidden(viewController.hidesBottomBarWhenPushed, animated: animated)
    }
}
#endif
