//
//  NotificationBannerView.swift
//  CircuitUI
//
//  Created by Lucien von Doellinger on 12/08/21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

#if canImport(CircuitUI_Private)

import CircuitUI_Private

/**
 The notification banner component prominently communicates and promotes high-level, site-wide information to the user.
 Check the guidelines before integration.
 Depending on the use case, either a headline, a body copy or both can be used to communicate the message.

 If needed, an optional image on the trailing side can be included. The image width is flexible. The image height is based on the height of the leading content + top and bottom margins.
 Do not use “fullscreen” photography as an image.

 #### Use case examples:
 * System messages
 * Promotions & recommendations

 */

@objc(CUINotificationBannerView)
public final class NotificationBannerView: UIView {

    // MARK: Views

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textAndButtonStack, imageView])
        stackView.setSpacing(Spacing.byte)
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textAndButtonStack.widthAnchor.constraint(lessThanOrEqualToConstant: LayoutConstants.maxMessageWidth),
            textAndButtonStack.widthAnchor.constraint(greaterThanOrEqualTo: stackView.widthAnchor, multiplier: 0.5)
        ])

        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = configuration.imageContentMode
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)

        imageHeightConstraint = imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        imageHeightConstraint?.priority = .defaultLow

        NSLayoutConstraint.activate([imageHeightConstraint].compactMap { $0 })
        return imageView
    }()

    private lazy var textAndButtonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageStack, button])
        stackView.setSpacing(Spacing.byte)
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var messageStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.setSpacing(Spacing.bit)
        return stackView
    }()

    private lazy var button: DefaultButton = {
        let button = DefaultButton(variant: .primary, size: .kilo)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = LabelHeadline4()
        updateLabel(label)
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = LabelBody2()
        updateLabel(label)
        return label
    }()

    private lazy var dismissButton: DefaultButton = {
        let dismissIcon = UIImage.cui_close_16
        let dismissButton = DefaultButton(variant: .tertiary, size: .kilo)
        dismissButton.setImage(dismissIcon, for: .normal)
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        return dismissButton
    }()

    private var imageHeightConstraint: NSLayoutConstraint?

    // MARK: Properties

    private var configuration: Configuration

    // MARK: Init

    @objc(initWithConfiguration:)
    public init(configuration: Configuration) {
        self.configuration = configuration

        super.init(frame: .zero)

        configureView()
        applyConfiguration(configuration)
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
        layer.cornerRadius = LayoutConstants.cornerRadius

        // Using constraints instead of Layout Guides because it was causing a resizing bug:
        // https://sumupteam.atlassian.net/browse/SA-54136
        addSubview(contentStack, with: [
            contentStack.topAnchor.constraint(equalTo: topAnchor, spacing: .giga),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, spacing: .giga),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, spacing: -.giga),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, spacing: -.giga)
        ])

        if configuration.isDismissable {
            addSubview(dismissButton, with: [
                dismissButton.topAnchor.constraint(equalTo: topAnchor, spacing: .kilo),
                dismissButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, spacing: .kilo),
                trailingAnchor.constraint(equalTo: dismissButton.trailingAnchor, spacing: .kilo)
            ])
        }
    }

    // MARK: Updates

    override public func updateConstraints() {
        super.updateConstraints()
        imageHeightConstraint = imageView.heightAnchor.constraint(lessThanOrEqualTo: textAndButtonStack.heightAnchor, spacing: Spacing.exa)
    }

    @objc(applyContentConfiguration:)
    public func applyConfiguration(_ configuration: Configuration) {

        // Background
        let colorRef: ColorReference
        switch configuration.variant {
        case .promotional:
            colorRef = .CUIColorRefN20
        case .system:
            colorRef = .CUIColorRefB10
        }
        backgroundColor = CUIColorFromHex(colorRef.rawValue)

        // Content

        titleLabel.text = configuration.title
        titleLabel.isHidden = configuration.title?.isEmpty ?? true

        bodyLabel.text = configuration.body
        bodyLabel.isHidden = configuration.body?.isEmpty ?? true

        imageView.image = configuration.image
        imageView.isHidden = configuration.image == nil

        button.isHidden = configuration.buttonConfiguration == nil

        // Layout

        switch configuration.buttonConfiguration?.buttonType {
        case .primary:
            button.variant = .primary
        case .tertiary:
            button.variant = .tertiary
        case .none:
            break
        }

        button.setTitle(configuration.buttonConfiguration?.title, for: .normal)

        self.configuration = configuration
    }

    // MARK: Layout

    private func updateLabel(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
    }

    // MARK: Actions

    @objc
    private func didTapPrimaryButton() {
        configuration.buttonConfiguration?.action()
    }

    @objc
    private func didTapDismissButton() {
        configuration.dismissAction?()
    }
}

// MARK: Extensions

extension NotificationBannerView {
    private enum LayoutConstants {
        static let maxMessageWidth: CGFloat = 500
        static let cornerRadius = Spacing.mega.rawValue
    }
}

extension NotificationBannerView {
    // MARK: Types & Variants

    @objc(CUINotificationBannerVariant)
    public enum Variant: Int {
        /// Use the blue variant for system notification use cases. Default variant.
        case system
        /// Use the gray variant for promotional notification use cases.
        case promotional
    }

    // MARK: Configuration

    @objc(CUINotificationBannerButtonConfiguration)
    public class ButtonConfiguration: NSObject {

        @objc(CUINotificationBannerButtonType)
        public enum ButtonType: Int {
            case primary
            case tertiary
        }

        public let title: String
        public let buttonType: ButtonType
        public let action: (() -> Void)

        @objc(initWithTitle:buttonType:action:)
        public init(title: String, buttonType: ButtonType = .primary, action: @escaping (() -> Void)) {
            self.title = title
            self.buttonType = buttonType
            self.action = action
        }
    }

    @objc(CUINotificationBannerConfiguration)
    public class Configuration: NSObject {

        // MARK: Public

        public let title: String?
        public let body: String?
        public let buttonConfiguration: ButtonConfiguration?
        public let image: UIImage?
        public let variant: Variant
        public let dismissAction: (() -> Void)?
        public var imageContentMode: UIImageView.ContentMode = .scaleAspectFit

        fileprivate var isDismissable: Bool {
            dismissAction != nil
        }

        @objc(initWithTitle:body:buttonConfiguration:image:variant:)
        public convenience init(title: String?,
                                body: String?,
                                buttonConfiguration: ButtonConfiguration,
                                image: UIImage?,
                                variant: Variant) {
            self.init(title: title,
                      body: body,
                      buttonConfiguration: buttonConfiguration,
                      image: image,
                      variant: variant,
                      dismissAction: nil)
        }

        @objc(initWithTitle:body:buttonConfiguration:image:variant:dismissAction:)

        public init(title: String? = nil,
                    body: String? = nil,
                    buttonConfiguration: ButtonConfiguration? = nil,
                    image: UIImage? = nil,
                    variant: Variant = .system,
                    dismissAction: (() -> Void)? = nil) {
            self.title = title
            self.body = body
            self.buttonConfiguration = buttonConfiguration
            self.image = image
            self.variant = variant
            self.dismissAction = dismissAction
            super.init()
        }

        @available(*, unavailable)
        override public init() {
            fatalError("init() isn't implemented")
        }
    }
}

#endif
