//
//  SegmentedTabViewController.swift
//  CircuitUI
//
//  Created by Marcel Voß on 08.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import SumUpUtilities
import UIKit

@objc(CUISegmentedTabViewControllerDelegate)
public protocol SegmentedTabViewControllerDelegate: AnyObject {
    /// Informs the delegate that a navigation has occured.
    /// - Parameters:
    ///   - viewController: The view controller that has informed the delegate.
    ///   - index: The new view controller's index.
    func segmentedTabViewController(_ viewController: SegmentedTabViewController, didSelectIndex index: Int)
}

/// The tabs component allows users to switch between different views of a screen that are at the same hierarchy level.
/// The one-line only segment titles should be short and concise, and should ideally not exceed 10 characters. It should never be truncated.
/// Refer to the documentation of the initializer to learn about setting titles of the segmented control.
@objc(CUISegmentedTabViewController)
public final class SegmentedTabViewController: ViewController {

    @objc(CUISegmentedTabViewControllerStyle)
    public enum Style: Int {
        /// A `regular` style arranges view controllers in an environment, where they will be replaced without animating between them.
        case regular

        /// A `paging` style arranges view controllers in an environment, where they can either be swiped left and right to navigate or the segmented
        /// control can be selected to navigate between view controllers in an animated fashion.
        case paging
    }

    // MARK: - Properties
    private let style: Style
    public let viewControllers: [UIViewController]

    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

    // should not be messed with. do not alter state, segments, title...
    // this can be used, if it is necessary to e.g. get its position.
    public private(set) var segmentedControl: UISegmentedControl?

    private var _selectedIndex: Int = .zero

    /// Specifies the currently selected view controller's index.
    @objc
    public var selectedIndex: Int {
        get {
            _selectedIndex
        } set {
            navigate(to: newValue, animated: true)
        }
    }

    private var layoutGuide: LayoutGuideProvider {
        view.safeAreaLayoutGuide
    }

    /// The layout guide used for constraining the segmented control's width.
    @objc
    public lazy var segmentedControlWidthLayoutGuide: UILayoutGuide = view.readableContentGuide {
        didSet {
            guard segmentedControlWidthLayoutGuide !== oldValue else {
                return
            }

            configureSegmentedControlWidthLayoutGuide()
        }
    }

    private var segmentedControlConstraints: [NSLayoutConstraint]?

    private weak var contentViewController: SegmentedTabBaseViewController?

    @objc
    public weak var delegate: SegmentedTabViewControllerDelegate?

    // MARK: - Initializers
    /// Initializes a new instance.
    /// - Parameters:
    ///   - style: The style that should be used for arranging and navigating view controllers.
    ///   - viewControllers: The view controllers that should be arranged.
    ///   - selectedIndex: The initially selected view controller.
    /// - Note: The   `UISegmentedControl`'s segment titles are derived from the view controller's title contained within the `viewControllers` array. Always make sure that every view controller has an appropriate title at the beginning of its lifetime.
    @objc
    public required init(style: Style, viewControllers: [UIViewController], selectedIndex: Int = .zero) {
        self.style = style
        self.viewControllers = viewControllers
        self._selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        configureSegmentedControl()
        configureContentViewController()

        // we don't want to animate the initial selection
        navigate(to: selectedIndex, animated: false, skipCallback: true)

        view.backgroundColor = SemanticColor.background
    }

    // MARK: - Configuration
    private func configureSegmentedControl() {
        let items: [String] = viewControllers.map {
            guard let title = $0.title else {
                let className = NSStringFromClass(type(of: self)) as String
                assertionFailure("arranged view controller \(className) must have a title set.")

                #if DEBUG
                return className
                #else
                return ""
                #endif
            }

            return title
        }

        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = selectedIndex
        control.accessibilityIdentifier = "tab-segmented-control"
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(didSelectSegment(_:)), for: .valueChanged)
        control.setContentCompressionResistancePriority(.required, for: .vertical)
        control.setContentHuggingPriority(.required, for: .vertical)

        view.addSubview(control)
        segmentedControl = control

        configureSegmentedControlWidthLayoutGuide()
    }

    private func configureSegmentedControlWidthLayoutGuide() {
        guard let safeSegmentedControl = segmentedControl else {
            assertionFailure("segmented control has not been set up yet.")
            return
        }

        if let existingConstraints = segmentedControlConstraints {
            NSLayoutConstraint.deactivate(existingConstraints)
        }

        let constraints = [
            safeSegmentedControl.leadingAnchor.constraint(equalTo: segmentedControlWidthLayoutGuide.leadingAnchor),
            safeSegmentedControl.trailingAnchor.constraint(equalTo: segmentedControlWidthLayoutGuide.trailingAnchor),
            safeSegmentedControl.topAnchor.constraint(equalTo: layoutGuide.topAnchor, spacing: .byte)
        ]

        NSLayoutConstraint.activate(constraints)
        segmentedControlConstraints = constraints
    }

    private func configureContentViewController() {
        guard let safeSegmentedControl = segmentedControl else {
            assertionFailure("cannot set up content view controller before segmented control is set up.")
            return
        }

        var viewController = createViewControllerForStyle()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.onDidNavigate = { [weak self] index in
            guard let safeSelf = self else {
                return
            }

            safeSelf._selectedIndex = index
            safeSegmentedControl.selectedSegmentIndex = index
            safeSelf.selectionFeedbackGenerator.selectionChanged()
            safeSelf.delegate?.segmentedTabViewController(safeSelf, didSelectIndex: index)
        }

        addChild(viewController)
        viewController.willMove(toParent: self)
        view.addSubview(viewController.view)

        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: safeSegmentedControl.bottomAnchor, spacing: .byte),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        viewController.didMove(toParent: self)

        contentViewController = viewController
    }

    // MARK: - Navigation
    private func navigate(to index: Int, animated: Bool = true, skipCallback: Bool = false) {
        assert(contentViewController != nil, "contentViewController must not be nil, when navigating.")
        contentViewController?.navigate(to: index, skipCallback: skipCallback, animated: animated)
    }

    private func createViewControllerForStyle() -> SegmentedTabBaseViewController {
        switch style {
        case .regular:
            return SegmentedTabRegularViewController(viewControllers: viewControllers)
        case .paging:
            return SegmentedTabPageViewController(viewControllers: viewControllers)
        }
    }

    // MARK: - Actions
    @objc
    private func didSelectSegment(_ sender: UISegmentedControl) {
        navigate(to: sender.selectedSegmentIndex, animated: true)
    }

}
