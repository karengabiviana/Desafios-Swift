//
//  UIView+ListContent.swift
//  CircuitUI
//
//  Created by Hagi on 22.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Kingfisher
import UIKit

// MARK: - View Instantiation

/**
 *  This protocol abstracts how a descriptor can be turned into an
 *  actual UIView instance, and determines whether or not it can be
 *  reused for another descriptor.
 */
protocol ReusableViewFactory {

    associatedtype ViewBaseClass: UIView

    var reuseIdentifierComponent: String { get }

    func createView(isSelected: Bool) -> ViewBaseClass

    /**
     *  Returns a casted version of the given view in case it can be
     *  reused, or `nil` otherwise.
     */
    func reusableView(_ view: UIView) -> ViewBaseClass?

}

extension ListContentInternal.TextElement: ReusableViewFactory {

    var reuseIdentifierComponent: String {
        switch style {
        case .body1:
            return "text-body-1"
        case .body2:
            return "text-body-2"
        }
    }

    func createView(isSelected: Bool) -> CUILabel {
        switch style {
        case .body1(let variant, let strikethrough):
            let body1 = LabelBody1(text)
            body1.variant = variant
            body1.isStrikethrough = strikethrough
            body1.accessibilityIdentifier = accessibilityIdentifier
            return body1
        case .body2(let variant):
            let body2 = LabelBody2(text)
            body2.variant = variant
            body2.accessibilityIdentifier = accessibilityIdentifier
            return body2
        }
    }

    func reusableView(_ view: UIView) -> CUILabel? {
        switch style {
        case .body1:
            return view as? LabelBody1
        case .body2:
            return view as? LabelBody2
        }
    }

}

extension ListContentInternal.LeadingElement: ReusableViewFactory {

    var reuseIdentifierComponent: String {
        switch self {
        case .badge:
            return "leading-badge"
        case .image(_, let imageOptions), .remoteImage(_, _, let imageOptions):
            let canvasSize = imageOptions.canvasSize.pointsSize
            return "leading-image-\(canvasSize.width)-\(canvasSize.height)"
        case .checkmark(_, let canvasSize, _):
            return "leading-checkmark-\(canvasSize.width)-\(canvasSize.height)"
        }
    }

    func createView(isSelected: Bool) -> UIView {
        switch self {
        case .image(let image, let imageOptions):
            let imageView = UIImageView(image: image,
                                        canvasSize: imageOptions.canvasSize.pointsSize,
                                        contentMode: imageOptions.contentMode,
                                        accessibilityIdentifier: accessibilityIdentifier)
            imageView.clipsToBounds = imageOptions.cornerRadius > 0
            imageView.layer.cornerRadius = imageOptions.cornerRadius
            return imageView
        case .remoteImage(let url, let placeholder, let imageOptions):
            let imageView = UIImageView(image: placeholder?.placeholderImage,
                                        canvasSize: imageOptions.canvasSize.pointsSize,
                                        contentMode: imageOptions.contentMode,
                                        accessibilityIdentifier: accessibilityIdentifier)
            imageView.clipsToBounds = imageOptions.cornerRadius > 0
            imageView.layer.cornerRadius = imageOptions.cornerRadius
            imageView.kf.indicatorType = placeholder?.indicatorType ?? .none
            imageView.kf.setImage(with: url, placeholder: placeholder?.placeholderImage)
            return imageView
        case .checkmark(let forMultipleSelection, let canvasSize, let contentMode):
            return UIImageView(image: UIImage.checkmark(isSelected: isSelected, isMultipleSelection: forMultipleSelection),
                               canvasSize: canvasSize,
                               contentMode: contentMode,
                               accessibilityIdentifier: accessibilityIdentifier)
        case .badge(let text, let variant):
            let badge = StatusBadge(text: text, variant: variant)
            badge.hugTightly()
            badge.accessibilityIdentifier = accessibilityIdentifier
            return badge
        }
    }

    func reusableView(_ view: UIView) -> UIView? {
        switch self {
        case .image, .remoteImage, .checkmark:
            // we don't check the canvas size here, as we don't
            // have access to the previous one – the containing
            // cell/content view has to check it
            return view as? UIImageView
        case .badge:
            return view as? StatusBadge
        }
    }

}

extension ListContentInternal.LeadingSecondaryElement: ReusableViewFactory {

    var reuseIdentifierComponent: String {
        switch self {
        case .text(let element):
            return "leading-secondary-\(element.reuseIdentifierComponent)"
        case .statusLine:
            return "leading-secondary-status-line"
        }
    }

    func createView(isSelected: Bool) -> UIView {
        let view: UIView
        switch self {
        case .text(let textElement):
            view = textElement.createView(isSelected: isSelected)
        case .statusLine(let model, let trailingText):
            view = StatusLineStackView(model: model, trailingText: trailingText)
        }
        view.accessibilityIdentifier = accessibilityIdentifier
        return view
    }

    func reusableView(_ view: UIView) -> UIView? {
        switch self {
        case .text(let element):
            return element.reusableView(view)
        case .statusLine:
            return view as? StatusLineStackView
        }
    }

}

extension ListContentInternal.TrailingElement: ReusableViewFactory {

    var reuseIdentifierComponent: String {
        switch self {
        case .text(let element):
            return "trailing-\(element.reuseIdentifierComponent)"
        case .badge:
            return "trailing-badge"
        case .control(let type):
            switch type {
            case .toggle:
                return "trailing-switchControl"
            case .checkmark:
                return "trailing-checkmark"
            }
        case .image(_, let imageOptions):
            let canvasSize = imageOptions.canvasSize.pointsSize
            return "trailing-image-\(canvasSize.width)-\(canvasSize.height)"
        }
    }

    func createView(isSelected: Bool) -> UIView {
        let view: UIView
        switch self {
        case .text(let textElement):
            view = textElement.createView(isSelected: isSelected)
        case .badge(let text, let variant):
            view = StatusBadge(text: text, variant: variant)
        case .control(let type):
            switch type {
            case .checkmark(let forMultipleSelection, let canvasSize, let contentMode):
                return UIImageView(image: UIImage.checkmark(isSelected: isSelected, isMultipleSelection: forMultipleSelection),
                                   canvasSize: canvasSize,
                                   contentMode: contentMode,
                                   accessibilityIdentifier: accessibilityIdentifier)
            case .toggle(let config):
                let toggle = Toggle()
                toggle.isOn = config.isOn
                toggle.isEnabled = config.isEnabled
                toggle.onChangeHandler = config.changeHandler
                view = toggle
            }
        case .image(let image, let imageOptions):
            return UIImageView(image: image,
                               canvasSize: imageOptions.canvasSize.pointsSize,
                               contentMode: imageOptions.contentMode,
                               accessibilityIdentifier: accessibilityIdentifier)
        }
        view.accessibilityIdentifier = accessibilityIdentifier
        view.hugTightly()
        return view
    }

    func reusableView(_ view: UIView) -> UIView? {
        switch self {
        case .text(let element):
            return element.reusableView(view)
        case .badge:
            return view as? StatusBadge
        case .control(let type):
            switch type {
            case .toggle:
                return view as? Toggle
            case .checkmark:
                return view as? UIImageView
            }
        case .image:
            return view as? UIImageView
        }
    }
}

extension ListContentInternal.TrailingSecondaryElement: ReusableViewFactory {

    var reuseIdentifierComponent: String {
        switch self {
        case .moreButton, .navigationChevron:
            return "trailing-secondary-image"
        }
    }

    func createView(isSelected: Bool) -> UIImageView {
        let image: UIImage?
        switch self {
        case .moreButton:
            image = .iconMore
        case .navigationChevron:
            image = .iconChevron
        }

        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.hugTightly()
        imageView.accessibilityIdentifier = accessibilityIdentifier
        return imageView
    }

    func reusableView(_ view: UIView) -> UIImageView? {
        switch self {
        case .moreButton, .navigationChevron:
            return view as? UIImageView
        }
    }

}

// MARK: - Content Updates

/**
 *  Basic guidelines/internal notes:
 *
 *  - only elements of the same kind can be re-applied, otherwise a
 *  `ListItemConfigurationError.elementTypeMismatch` error should be
 *  thrown, which will cause the cell layout to be set up from scratch
 *
 *  - you can toggle the hidden state without breaking cell reuse,
 *  as all elements are currently in stack views. If hiding a particular
 *  element has further implications on the entire layout, the content
 *  view implementation has to catch that.
 *
 *  - rule of thumb: apply minor content changes to the existing view,
 *  but avoid any kind of constraint changes or view instantiations –
 *  in doubt, just bail out
 */

extension UIView {

    func apply(_ element: ListContentInternal.LeadingElement?, isSelected: Bool) throws {
        guard let element = element else {
            isHidden = true
            return
        }

        isHidden = false

        switch element {
        case .image(let image, let imageOptions):
            guard let imageView = element.reusableView(self) as? UIImageView else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            imageView.kf.indicatorType = .none
            imageView.kf.cancelDownloadTask()
            imageView.contentMode = contentMode
            imageView.image = image
            imageView.clipsToBounds = imageOptions.cornerRadius > 0
            imageView.layer.cornerRadius = imageOptions.cornerRadius
        case .remoteImage(let url, let placeholder, let imageOptions):
            guard let imageView = element.reusableView(self) as? UIImageView else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            imageView.kf.indicatorType = placeholder?.indicatorType ?? .none
            imageView.kf.cancelDownloadTask()
            imageView.contentMode = contentMode
            imageView.clipsToBounds = imageOptions.cornerRadius > 0
            imageView.layer.cornerRadius = imageOptions.cornerRadius
            imageView.kf.setImage(with: url, placeholder: placeholder?.placeholderImage)
        case .badge(let text, let variant):
            guard let badge = element.reusableView(self) as? StatusBadge else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            badge.text = text
            badge.variant = variant
        case .checkmark(let forMultipleSelection, _, _):
            guard let imageView = element.reusableView(self) as? UIImageView else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            imageView.image = UIImage.checkmark(isSelected: isSelected, isMultipleSelection: forMultipleSelection)
        }
    }

    func apply(_ element: ListContentInternal.LeadingSecondaryElement?) throws {
        guard let element = element else {
            isHidden = true
            return
        }

        isHidden = false

        switch element {
        case .text(let textElement):
            guard let label = element.reusableView(self) as? CUILabel else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            try label.apply(textElement)

        case .statusLine(let model, let trailingText):
            guard let stack = element.reusableView(self) as? StatusLineStackView else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            try stack.apply(model: model, trailingText: trailingText)
        }
    }

    func apply(_ element: ListContentInternal.TrailingElement?, isSelected: Bool) throws {
        guard let element = element else {
            isHidden = true
            return
        }

        isHidden = false

        switch element {
        case .text(let textElement):
            guard let label = element.reusableView(self) as? CUILabel else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            try label.apply(textElement)

        case .badge(let text, let variant):
            guard let badge = element.reusableView(self) as? StatusBadge else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            badge.text = text
            badge.variant = variant
        case .control(let type):
            switch type {
            case .checkmark(let forMultipleSelection, _, _):
                guard let imageView = element.reusableView(self) as? UIImageView else {
                    throw ListItemConfigurationError.elementTypeMismatch
                }
                imageView.image = UIImage.checkmark(isSelected: isSelected, isMultipleSelection: forMultipleSelection)
            case .toggle(let config):
                guard let toggle = element.reusableView(self) as? Toggle else {
                    throw ListItemConfigurationError.elementTypeMismatch
                }
                toggle.isOn = config.isOn
                toggle.isEnabled = config.isEnabled
                toggle.onChangeHandler = config.changeHandler
            }
        case .image(let image, let imageOptions):
            guard let imageView = element.reusableView(self) as? UIImageView else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            imageView.image = image
            imageView.contentMode = imageOptions.contentMode
        }
    }

}

extension UIImageView {

    func apply(_ element: ListContentInternal.TrailingSecondaryElement?) throws {
        guard let element = element else {
            isHidden = true
            return
        }

        isHidden = false

        guard element.reusableView(self) != nil else {
            throw ListItemConfigurationError.elementTypeMismatch
        }

        switch element {
        case .moreButton:
            image = .iconMore
        case .navigationChevron:
            image = .iconChevron
        }
    }

}

extension CUILabel {

    func apply(_ element: ListContentInternal.TextElement) throws {
        guard element.reusableView(self) != nil else {
            throw ListItemConfigurationError.elementTypeMismatch
        }

        switch element.style {
        case .body1(let variant, let strikethrough):
            guard let body1 = self as? LabelBody1 else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            body1.variant = variant
            body1.isStrikethrough = strikethrough
            body1.text = element.text

        case .body2(let variant):
            guard let body2 = self as? LabelBody2 else {
                throw ListItemConfigurationError.elementTypeMismatch
            }
            body2.variant = variant
            body2.text = element.text
        }
    }

}

// MARK: - Helpers

private extension UIView {

    func hugTightly() {
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
    }

}

private extension UIImage {

    static let iconMore: UIImage? = {
        .cui_imageNamed("list_icon_more")
    }()

    static let iconChevron: UIImage? = {
        UIImage
            .cui_imageNamed("list_icon_navigation")?
            .imageFlippedForRightToLeftLayoutDirection()
    }()

}

private class StatusLineStackView: UIStackView {

    private weak var statusLine: StatusLine?
    private weak var trailingLabel: CUILabel?

    init(model: StatusLineModel, trailingText: ListContentInternal.TextElement?) {
        let status = StatusLine(model: model)
        self.statusLine = status

        super.init(frame: .zero)

        // set up after `super.init` to obtain the layout direction internally
        let extraText = formattedTrailingText(from: trailingText?.text)
        let textElement = ListContentInternal.TextElement(extraText, style: trailingText?.style ?? .body2(variant: .default))
        let label = textElement.createView(isSelected: false)
        label.accessibilityIdentifier = textElement.accessibilityIdentifier + "-status-line"
        self.trailingLabel = label

        addArrangedSubview(status)
        addArrangedSubview(label)

        label.isHidden = extraText.isEmpty

        setSpacing(.none)
    }

    func apply(model: StatusLineModel, trailingText: ListContentInternal.TextElement?) throws {
        assert(statusLine != nil)
        statusLine?.apply(model: model)

        assert(trailingLabel != nil)
        let extraText = formattedTrailingText(from: trailingText?.text)
        let textElement = ListContentInternal.TextElement(extraText, style: trailingText?.style ?? .body2(variant: .default))
        try trailingLabel?.apply(textElement)

        trailingLabel?.isHidden = extraText.isEmpty
    }

    private func formattedTrailingText(from rawText: String?) -> String {
        guard let trailingText = rawText, !trailingText.isEmpty else {
            return ""
        }

        switch effectiveUserInterfaceLayoutDirection {
        case .leftToRight:
            return " · \(trailingText)"
        case .rightToLeft:
            return "\(trailingText) · "
        @unknown default:
            return " · \(trailingText)"
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension UIImageView {
    convenience init(image: UIImage?,
                     canvasSize: CGSize,
                     contentMode: UIView.ContentMode,
                     accessibilityIdentifier: String) {
        self.init(image: image)
        self.contentMode = contentMode
        self.widthAnchor.constraint(equalToConstant: canvasSize.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: canvasSize.height).isActive = true
        self.accessibilityIdentifier = accessibilityIdentifier
    }

}

private extension UIImage {
    static func checkmark(isSelected: Bool, isMultipleSelection: Bool) -> UIImage? {
        guard isMultipleSelection else {
            return isSelected ? .selectionIconRadioButton : nil
        }
        return isSelected ? .selectionIconSelected: .selectionIconNotSelected
    }
}

private extension ListContent.ImagePlaceholder {
    var indicatorType: Kingfisher.IndicatorType? {
        switch self {
        case .image:
            return nil
        }
    }

    var placeholderImage: UIImage? {
        switch self {
        case .image(let image):
            return image
        }
    }
}
