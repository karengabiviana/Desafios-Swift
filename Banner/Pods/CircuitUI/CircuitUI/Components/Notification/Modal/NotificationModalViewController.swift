//
//  NotificationModalViewController.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 29/06/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

/**
 The notification modal component disruptively communicate critical information while blocking everything else on the page and needs the user’s attention or action to proceed.

 #### Use cases
 * Provide information that needs users immediate attention
 * Request confirmation before performing a destructive action

 - Attention:
 The notification modal always lives on an overlay. Title and actions are required. If needed, an optional image and an optional body can be included.

 - Note:
 The image view has fixed size of 232pt in width and 120pt in height, centered horizontally.

 Always provide an option to cancel the notification modal without performing any action.

 The view controller's `dismiss(animated:)` is called automatically when any of the actions was selected.
 */
@objc(CUINotificationModalViewController)
public final class NotificationModalViewController: ViewController {

    private let configuration: NotificationContentView.Configuration
    private lazy var contentView = NotificationContentView(configuration: configuration.adjustedForModal.addingAdditionalAction { [weak self] in
        self?.dismiss(animated: true)
    })

    @objc(CUINotificationModalViewConfiguration)
    public class Configuration: NotificationContentView.Configuration {

        @objc(initWithTitle:body:actions:image:layout:)
        // swiftlint:disable:next modifier_order
        public override init(title: String,
                             body: String? = nil,
                             actions: [NotificationContentView.Action],
                             image: UIImage? = nil,
                             layout: NotificationContentView.Layout = .automatic) {
            super.init(title: title,
                       body: body,
                       actions: actions,
                       image: image,
                       layout: layout,
                       isDisplayedInModal: true)
        }
    }

    // MARK: Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: Init

    @objc(initWithConfiguration:)
    public init(configuration: Configuration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Layout

    private func configureView() {
        view.backgroundColor = SemanticColor.overlay
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let safeConstraints: [NSLayoutConstraint]

        let minimumSpacing: Spacing = .peta

        safeConstraints = [
            contentView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, spacing: minimumSpacing),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, spacing: minimumSpacing),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, spacing: -minimumSpacing),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, spacing: -minimumSpacing)
        ]

        let maxWidth: CGFloat = 420
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ] + safeConstraints)
    }
}

private extension NotificationContentView.Configuration {

    /// Creates configuration copy with `isDisplayedInModal`set to true
    var adjustedForModal: NotificationContentView.Configuration {
        .init(title: self.title,
              body: self.body,
              actions: self.actions,
              image: self.image,
              layout: self.layout,
              isDisplayedInModal: true)
    }

    func addingAdditionalAction(action: @escaping () -> Void) -> NotificationContentView.Configuration {
        .init(title: self.title,
              body: self.body,
              actions: actions.map { old in
                NotificationContentView.Action(
                    title: old.title,
                    style: old.style) {
                    action()
                    old.action?(old)
                }
              },
              image: self.image,
              layout: self.layout,
              isDisplayedInModal: self.isDisplayedInModal)
    }
}
