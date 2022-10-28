//
//  AvatarControl.swift
//  CircuitUI
//
//  Created by Marcel Voß on 16.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation
import SumUpUtilities
import UIKit

#if canImport(CircuitUI_Private)

import CircuitUI_Private

/// A control that is typically used to display image input. For example, you can use it as source element to trigger the presentation of image selection/file browsing, indicating image upload (`isLoading `) and displaying validation results (`errorMessage`).
///
/// Alternatively, you can use it in its non-editable state (`isEditable`) to e.g. display a placeholder image, while not (yet) having a final image available.
public class AvatarControl: UIControl {

    /// An enum that defines different variants for an avatar.
    public enum Variant: Equatable {
        /// Defines an avatar that is used for displaying an object (e.g. a product photo).
        case object

        /// Defines an avatar that is used for displaying an identity (e.g. a person or business).
        case identity(Identity)
    }

    /// Defines the type of identity the control represents.
    public enum Identity: Equatable {
        /// Represents a individual's identity.
        case profile

        /// Represents a business' identity.
        case business
    }

    public enum Size: Equatable {
        case giga
        case yotta
    }

    // MARK: - Properties
    public var size: Size = .giga {
        didSet {
            guard size != oldValue else {
                return
            }

            configureLayoutForSize()
        }
    }

    public var variant: Variant = .object {
        didSet {
            guard variant != oldValue else {
                return
            }

            configureLayoutForVariant()
        }
    }

    /// Defines whether the avatar should appear in a loading state.
    public var isLoading = false {
        didSet {
            guard isLoading != oldValue else {
                return
            }

            configureAccessory()
            configureOverlayForState()
        }
    }

    /// Defines whether the avatar is read-only or also allows interactions with it.
    public var isEditable = false {
        didSet {
            guard isEditable != oldValue else {
                return
            }

            configureAccessory()
        }
    }

    public var errorMessage: String? {
        didSet {
            guard errorMessage != oldValue else {
                return
            }

            configureErrorStatusView()
            updateBorderStyleForState()
        }
    }

    public var image: UIImage? {
        didSet {
            configureAccessory()
            imageView.image = image ?? variant.placeholderImage
        }
    }

    private var showsError: Bool {
        errorMessage != nil
    }

    private weak var errorStatusView: InputControlContainerValidationStatusView?
    private weak var loadingOverlay: AvatarLoadingOverlayView?
    private weak var imageAccessoryView: UIImageView?
    private weak var imageViewHeightConstraint: NSLayoutConstraint?
    private weak var imageViewWidthConstraint: NSLayoutConstraint?

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = Spacing.byte.rawValue
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        stack.setContentHuggingPriority(.required, for: .vertical)
        return stack
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initializers
    public init(variant: Variant, size: Size) {
        self.variant = variant
        self.size = size
        super.init(frame: .zero)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureSubviews()
    }

    private func configureSubviews() {
        stackView.addArrangedSubview(imageView)

        addSubview(stackView,
                   with: stackView.constrain(toEdgesOf: self))

        configureLayoutForVariant()
    }

    // MARK: - Configuration
    private func configureLayoutForVariant() {
        if image == nil {
            // we only want to set the placeholder image in case there
            // hasn't been an image set yet.
            imageView.image = variant.placeholderImage
        }

        configureLayoutForSize()
    }

    private func configureLayoutForSize() {
        if imageViewHeightConstraint == nil {
            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: size.height)
            heightConstraint.isActive = true
            imageViewHeightConstraint = heightConstraint
        }

        if imageViewWidthConstraint == nil {
            let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: size.height)
            widthConstraint.isActive = true
            imageViewWidthConstraint = widthConstraint
        }

        imageViewWidthConstraint?.constant = size.height
        imageViewHeightConstraint?.constant = size.height
    }

    private func configureErrorStatusView() {
        guard let safeErrorResult = validationResultForErrorMessage else {
            // interpret a nil error message as "no error occured"
            errorStatusView?.removeFromSuperview()
            return
        }

        if let statusView = errorStatusView {
            // if we already have a fully configured view available,
            // we don't want to add another one and therefore only update
            // the currently presented text and return early.
            statusView.result = safeErrorResult
            return
        }

        let statusView = InputControlContainerValidationStatusView(validationResult: safeErrorResult)
        stackView.addArrangedSubview(statusView)

        errorStatusView = statusView
    }

    private func configureOverlayForState() {
        guard isLoading || isHighlighted else {
            loadingOverlay?.removeFromSuperview()
            return
        }

        if loadingOverlay == nil {
            let overlay = AvatarLoadingOverlayView()
            overlay.isLoading = isLoading
            overlay.isUserInteractionEnabled = false

            imageView.addSubview(overlay,
                                 with: overlay.constrain(toEdgesOf: imageView))

            loadingOverlay = overlay
        }

        loadingOverlay?.isLoading = isLoading
        updateBorderStyleForState()
    }

    private func configureAccessory() {
        guard isEditable, !isLoading else {
            imageAccessoryView?.removeFromSuperview()
            return
        }

        let accessory: Accessory = image == nil ? .create : .edit

        guard imageAccessoryView == nil else {
            imageAccessoryView?.image = accessory.image
            updateAccessoryState()
            return
        }

        let view = UIImageView(image: accessory.image)
        view.contentMode = .center
        view.clipsToBounds = true
        view.tintColor = SemanticColor.background

        addSubview(view, with: [
            view.heightAnchor.constraint(equalToConstant: size.accessoryHeight),
            view.widthAnchor.constraint(equalToConstant: size.accessoryHeight),
            view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Spacing.bit.rawValue),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.bit.rawValue)
        ])

        imageAccessoryView = view
        updateAccessoryState()
    }

    private func updateAccessoryState() {
        imageAccessoryView?.backgroundColor = isHighlighted ? CUIColorFromHex(ColorReference.CUIColorRefB80.rawValue) : SemanticColor.tint
    }

    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()

        // it seems like UIStackView takes over laying out its arranged subviews
        // and its subview's frames aren't calculated here yet. so, we ask the stack
        // view to perform a layout cycle, in order to be able to calculate corner radii correctly.
        stackView.layoutIfNeeded()
        imageView.layer.cornerRadius = variant.cornerRadius(for: imageView, size: size)

        guard let safeAccessoryView = imageAccessoryView else {
            return
        }

        safeAccessoryView.layer.cornerRadius = safeAccessoryView.bounds.size.height / 2
    }

    // MARK: - State
    private var needsBorder: Bool {
        showsError || isLoading
    }

    private func updateBorderStyleForState() {
        imageView.layer.borderWidth = needsBorder ? 2 : .zero

        if isLoading {
            imageView.layer.borderColor = SemanticColor.tint.cgColor
        }

        if showsError {
            imageView.layer.borderColor = SemanticColor.alert.cgColor
        }
    }

    public func displayMessage(for error: Error) {
        errorMessage = error.localizedDescription
    }

    // MARK: - UIControl
    override public func point(inside point: CGPoint,
                               with event: UIEvent?) -> Bool {
        // we only want to make our image view "tapable", as it doesn't
        // make sense when all of the stack view responds to it.
        let contains = imageView.frame.contains(point)
        if contains {
            return contains
        }

        return super.point(inside: point, with: event)
    }

    override public var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else {
                return
            }

            updateAccessoryState()
            configureOverlayForState()
        }
    }

}

extension AvatarControl {
    private enum Accessory {
        case edit
        case create

        var image: UIImage? {
            let image: UIImage

            switch self {
            case .edit:
                image = .cui_edit_16
            case .create:
                image = .cui_plus_16
            }

           return image.withRenderingMode(.alwaysTemplate)
        }
    }

    private var validationResultForErrorMessage: InputControlContainerValidationResult? {
        guard let safeMessage = errorMessage else {
            return nil
        }

        return .init(success: false, reason: safeMessage)
    }
}

extension AvatarControl.Variant {
    var placeholderImage: UIImage? {
        switch self {
        case .object:
            return .cui_imageNamed("avatar_object")
        case .identity(let identity):
            return identity.placeholderImage
        }
    }

    func cornerRadius(for imageView: UIImageView, size: AvatarControl.Size) -> CGFloat {
        switch self {
        case .identity:
            // we would like to round the image view to a full circle
            return imageView.bounds.size.height / 2
        case .object:
            switch size {
            case .giga:
                return Spacing.byte.rawValue
            case .yotta:
                return Spacing.kilo.rawValue
            }
        }
    }
}

extension AvatarControl.Identity {
    var placeholderImage: UIImage? {
        switch self {
        case .profile:
            return .cui_imageNamed("avatar_profile")
        case .business:
            return .cui_imageNamed("avatar_business")
        }
    }
}

extension AvatarControl.Size {
    var height: CGFloat {
        switch self {
        case .giga:
            return 48.0
        case .yotta:
            return 96.0
        }
    }

    var accessoryHeight: CGFloat {
        switch self {
        case .giga:
            return 24.0
        case .yotta:
            return 32.0
        }
    }
}

#endif
