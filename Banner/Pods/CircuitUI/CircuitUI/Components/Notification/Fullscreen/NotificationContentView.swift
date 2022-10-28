//
//  NotificationContentView.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 26/06/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

/**
 The notification fullscreen component disruptively provides important information or feedback as part of a process flow.

 #### Use cases:
 * Confirmation screen after a process flow
 * Empty screen
 * Page loading error screen

 - Attention:
 The view should be pinned to all sides within containing view both vertically and horizontally. The safe area is already taken into account. Title is required. If needed, an optional image and an optional body can be included.

 - Note:
 The image view has fixed size of 280pt in width and 160pt in height, centered horizontally.

 For bigger screens (i.e. tablets), the component is limited to a maximum width of 420pt, in order to ensure an optimised readability of the text.
 */
@objc(CUINotificationContentView)
public final class NotificationContentView: UIView {

    // MARK: Types

    /**
     Depending on the layout constraints and the button label length, you might want a specific button layout, or allow
     the framework to choose the right appearance according to the guidelines.
     - Note:
     Note that for vertical layout _Primary_ and _Tertiary_ buttons are used, while for horizontal _Primary_ is paired with _Secondary_ for better a visual appearance.
     */
    @objc(CUINotificationContentViewLayout)
    public enum Layout: Int {

        /// As described in the documentation, this uses horizontal layout for wide screens, and vertical for narrow.
        case automatic

        /// Uses vertical layout in any environment.
        case vertical

        /// Uses horizontal layout in any environment.
        case horizontal
    }

    /**
     Defines notification content view action button style.

     Depending on the use case, different styles could be applied to the notification action.
     */
    @objc(CUINotificationContentViewActionStyle)
    public enum ActionStyle: Int {

        /// Apply the default style to the action button.
        case `default`

        /// Apply a style that indicates the action might change or delete data.
        case destructive

        /// Apply a style that indicates the action cancels the operation and leaves things unchanged.
        case cancel
    }

    @objc(CUINotificationContentViewActionState)
    public enum ActionState: Int {

        /// Apply the default state to the action button.
        case `default`

        /// Apply the disable style and show loading indicator when action is triggered
        case loading
    }

    /**
     Defines notification content view action button, including the title to display in the button, styling, and an optional handler to execute when the user taps the button.
     */
    @objc(CUINotificationContentViewAction)
    public class Action: NSObject {

        /// The title of the action's button.
        public let title: String

        /// The style that is applied to the action's button.
        public let style: ActionStyle

        /// Controls the state of the button associated with the Action.
        public var state: ActionState {
            didSet {
                dataChanged?()
            }
        }

        /// An optional block to execute when the user selects the action.
        public let action: ((Action) -> Void)?

        fileprivate var dataChanged: (() -> Void)?

        @objc(initWithTitle:style:action:)
        public init(title: String, style: ActionStyle = .default, action: (() -> Void)? = nil) {
            self.title = title
            self.style = style
            self.state = .default
            self.action = { _ in action?() }
        }

        @objc(initWithTitle:style:loading:action:)
        public init(title: String, style: ActionStyle = .default, state: ActionState = .default, action: ((Action) -> Void)? = nil) {
            self.title = title
            self.style = style
            self.state = state
            self.action = action
        }
    }

    @objc(CUINotificationContentViewConfiguration)
    public class Configuration: NSObject {

        // MARK: Public

        public let title: String
        public let body: String?
        public let actions: [Action]
        public let image: UIImage?
        public let layout: Layout

        fileprivate var dataChanged: (() -> Void)?

        @objc(initWithTitle:body:actions:image:layout:)
        public init(title: String,
                    body: String? = nil,
                    actions: [Action] = [],
                    image: UIImage? = nil,
                    layout: Layout = .automatic) {
            self.title = title
            self.body = body
            self.actions = actions
            self.image = image
            self.layout = layout
            self.isDisplayedInModal = false
            super.init()
            subscribeToActionsUpdates()
        }

        // swiftlint:disable:next function_default_parameter_at_end
        init(title: String,
             body: String? = nil,
             actions: [Action],
             image: UIImage? = nil,
             layout: Layout = .automatic,
             isDisplayedInModal: Bool) {
            self.title = title
            self.body = body
            self.actions = actions
            self.image = image
            self.layout = layout
            self.isDisplayedInModal = isDisplayedInModal

            super.init()
            validate()
            subscribeToActionsUpdates()
        }

        @available(*, unavailable)
        override public init() {
            fatalError("init() isn't implemented")
        }

        // MARK: Internal

        /// Set to `true` if view should be configured to be embedded in a modal window.
        let isDisplayedInModal: Bool

        /**
         Defines notification content view configuration error. The error is triggered if improper actions combinations are passed on initialization.
         */
        enum ConfigurationError: Error, CustomStringConvertible {

            /// Error when the limit of number of actions (2) has been reached.
            case actionsLimitReached

            /// Error when there are no actions. At least one action is required for notification modal presentations.
            case missingActions

            /// Error when there is more than one action of type `ActionStyle.cancel`.
            case duplicateActionCancel

            /// Error when there is more than one action of type `ActionStyle.destructive`.
            case duplicateActionDestructive

            var description: String {
                switch self {
                case .actionsLimitReached:
                    return "Maximum number of actions has been reached."
                case .missingActions:
                    return "Notification content view require at least one action."
                case .duplicateActionCancel:
                    return "Notification content view can only have one action with a style `ActionStyle.cancel`."
                case .duplicateActionDestructive:
                    return "Notification content view can only have one action with a style `ActionButtonStyle.destructive`."
                }
            }
        }

        func validate() {
            let error = ConfigurationError.self

            if isDisplayedInModal && actions.isEmpty {
                assertionFailure(error.missingActions.description)
            }

            if actions.count > 2 {
                assertionFailure(error.actionsLimitReached.description)
            }

            if actions.filter({ $0.style == .cancel }).count > 1 {
                assertionFailure(error.duplicateActionCancel.description)
            }

            if actions.filter({ $0.style == .destructive }).count > 1 {
                assertionFailure(error.duplicateActionDestructive.description)
            }
        }

        private func subscribeToActionsUpdates() {
            actions.forEach { action in
                action.dataChanged = { [weak self] in
                    self?.dataChanged?()
                }
            }
        }
    }

    // MARK: Views

    private let titleLabel = LabelHeadline4()
    private lazy var imageView = createImageView()
    private lazy var bodyLabel = createBodyLabel()
    private lazy var primaryButtons = [ButtonGigaPrimary]()
    private lazy var secondaryButtons = [DefaultButton]()

    private lazy var buttonsStack = createButtonsStackView()
    private lazy var contentStack = createContentStackView()

    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?

    // MARK: Properties

    private var currentConfiguration: Configuration
    /// Indicates if `imageView` is already loaded into memory.
    private var imageViewIsInitialized = false
    /// Indicates if `bodyLabel` is already loaded into memory.
    private var bodyLabelIsInitialized = false

    // MARK: Init

    @objc(initWithConfiguration:)
    public init(configuration: Configuration) {
        self.currentConfiguration = configuration
        super.init(frame: .zero)
        configureView()
        configureConstraints()
        applyConfiguration(configuration)
        subscribeToConfigurationUpdates()
    }

    @available(*, unavailable)
    override public init(frame: CGRect) {
        fatalError("init(frame:) isn't implemented. Use init(configiration:) instead")

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) isn't implemented. Use init(configiration:) instead")
    }

    // MARK: Initial configuration

    private func configureView() {
        addSubview(contentStack)
        backgroundColor = SemanticColor.background
        updateLabel(titleLabel)
    }

    private func configureConstraints() {
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        // When presented in modal, view should use its own size to position itself
        let compressionConstraints = [
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 0)
        ]

        compressionConstraints.forEach {
            $0.priority = .defaultLow
        }

        let safeConstraints: [NSLayoutConstraint] = [
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
            contentStack.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
            contentStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ]

        NSLayoutConstraint.activate([
            contentStack.widthAnchor.constraint(lessThanOrEqualToConstant: LayoutConstants.maxImageWidth)
        ] + safeConstraints + compressionConstraints)
    }

    // MARK: Layout

    private func createActionButtons(_ configuration: Configuration) {
        primaryButtons.removeAll()
        configuration.actions
            .filter { $0.style != .cancel }
            .forEach { action in
                primaryButtons.append(action.createPrimaryButton())
            }

        secondaryButtons.removeAll()
        configuration.actions
            .filter { $0.style == .cancel }
            .forEach { action in
                secondaryButtons.append(action.createSecondaryButton())
            }
    }

    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        imageHeightConstraint?.priority = .defaultLow
        imageWidthConstraint = imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 0)
        NSLayoutConstraint.activate([imageHeightConstraint, imageWidthConstraint].compactMap { $0 })
        return imageView
    }

    private func createBodyLabel() -> UILabel {
        let label = LabelBody2()
        updateLabel(label)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow + 1, for: .vertical)
        return label
    }

    private func createButtonsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.setSpacing(.mega)
        return stackView
    }

    private func createContentStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, buttonsStack])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }

    private func updateLabel(_ label: CUILabel) {
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
    }

    private func subscribeToConfigurationUpdates() {
        currentConfiguration.dataChanged = { [weak self] in
            guard let self = self else {
                return
            }
            self.applyConfiguration(self.currentConfiguration)
        }
    }

    // MARK: Updates

    @objc(applyConfiguration:)
    public func applyConfiguration(_ configuration: Configuration) {

        // Content
        titleLabel.text = configuration.title

        // ImageView is created and inserted only when used at least once.
        if let image = configuration.image {
            if !imageViewIsInitialized {
                contentStack.insertArrangedSubview(imageView, at: 0)
                imageViewIsInitialized = true
            }
            imageView.image = image
            imageView.isHidden = false
        } else if imageViewIsInitialized {
            imageView.image = nil
            imageView.isHidden = true
        }

        // BodyLabel is created and inserted only when used at least once.
        if let body = configuration.body {
            if !bodyLabelIsInitialized, let index = contentStack.arrangedSubviews.firstIndex(of: buttonsStack) {
                contentStack.insertArrangedSubview(bodyLabel, at: index)
                bodyLabelIsInitialized = true
            }
            bodyLabel.text = body
            bodyLabel.isHidden = false
        } else if bodyLabelIsInitialized {
            bodyLabel.text = nil
            bodyLabel.isHidden = true
        }

        // Layout
        let layoutConstants = LayoutConstants(isDisplayedInModal: configuration.isDisplayedInModal,
                                              isHorizontalLayout: configuration.layout.isHorizontalLayout(traitCollection: traitCollection),
                                              isBodyVisible: configuration.body != nil)

        createActionButtons(configuration)

        // Apply variant to secondary buttons
        secondaryButtons.forEach { button in
            button.variant = layoutConstants.isHorizontalLayout ? .secondary : .tertiary
        }

        // Button Stack
        buttonsStack.axis = layoutConstants.buttonsStackAxis
        buttonsStack.distribution = layoutConstants.buttonsStackDistribution
        buttonsStack.setSpacing(layoutConstants.buttonSpacing)
        buttonsStack.isHidden = configuration.actions.isEmpty

        buttonsStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        var buttons = [primaryButtons, secondaryButtons]
        if layoutConstants.isHorizontalLayout {
            buttons.reverse()
        }

        buttons.forEach { element in
            element.forEach(buttonsStack.addArrangedSubview(_:))
        }

        layer.cornerRadius = layoutConstants.cornerRadius
        contentStack.setSpacing(layoutConstants.contentStackSpacing)
        contentStack.setCustomSpacing(layoutConstants.spacingAfterTitleLabel, after: titleLabel)

        imageHeightConstraint?.constant = layoutConstants.imageSize.height
        imageWidthConstraint?.constant = layoutConstants.imageSize.width

        contentStack.layoutMargins = layoutConstants.layoutMargins

        currentConfiguration = configuration
        setNeedsLayout()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyConfiguration(currentConfiguration)
    }
}

private extension NotificationContentView {

    private struct LayoutConstants {

        static let maxImageWidth: CGFloat = 420

        let isDisplayedInModal: Bool
        let isHorizontalLayout: Bool
        let isBodyVisible: Bool

        var cornerRadius: CGFloat {
            isDisplayedInModal ? 16 : 0
        }

        var contentStackSpacing: Spacing {
            isDisplayedInModal ? .mega : .giga
        }

        var spacingAfterTitleLabel: Spacing {
            isDisplayedInModal ?
                !isBodyVisible ? .mega : .bit :
                !isBodyVisible ? .giga : .byte
        }

        var imageSize: CGSize {
            isDisplayedInModal ?
                .init(width: 232, height: 120) :
                .init(width: 280, height: 160)
        }

        var layoutMargins: UIEdgeInsets {
            .init(vertical: .giga, horizontal: isDisplayedInModal ? .giga : .peta)
        }

        var buttonSpacing: Spacing {
            isHorizontalLayout ?
                .mega :
                isDisplayedInModal ? .mega : .bit
        }

        var buttonsStackAxis: NSLayoutConstraint.Axis {
            isHorizontalLayout ? .horizontal : .vertical
        }

        var buttonsStackDistribution: UIStackView.Distribution {
            isHorizontalLayout ? .fillEqually : .fill
        }
    }
}

private extension UITraitCollection {

    var isWideScreen: Bool {
        switch horizontalSizeClass {
        case .regular:
            return true
        case .compact, .unspecified:
            return false
        @unknown default:
            return false
        }
    }
}

private extension NotificationContentView.Layout {

    func isHorizontalLayout(traitCollection: UITraitCollection) -> Bool {
        switch self {
        case .automatic:
            return traitCollection.isWideScreen
            && !traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        case .vertical:
            return false
        case .horizontal:
            return true
        }
    }
}

private extension NotificationContentView.Action {

    func createPrimaryButton() -> ButtonGigaPrimary {
        let button = ButtonGigaPrimary()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultLow + 1, for: .vertical)

        switch style {
        case .destructive:
            button.isDestructive = true
        case .default:
            button.isDestructive = false
        case .cancel:
            break
        @unknown default:
            break
        }

        switch state {
        case .default:
            break
        case .loading:
            button.isEnabled = false
            button.startActivityIndicatorAnimation()
        }

        return button
    }

    func createSecondaryButton() -> DefaultButton {
        let button = DefaultButton()
        button.size = .giga
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)

        switch state {
        case .default:
            break
        case .loading:
            button.isEnabled = false
            button.startActivityIndicatorAnimation()
        }

        return button
    }

    // MARK: Actions

    @objc
    func didTapActionButton(_ button: DefaultButton) {
        action?(self)
    }
}
