//
//  ListContentConfiguration.swift
//  CircuitUI
//
//  Created by Andras Kadar on 06.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

/**
 * A list content configuration is an internal descriptor of the List Item component.
 * It describes the styling and content for an individual element that might appear
 * in a list. The configuration should hold all the information required for display
 * and it should be directly assigned to a cell.
 *
 * The content configuration is meant to be internal in order to restrict public
 * usage to valid, CircuitUI-approved combinations of elements.
 *
 *  Example implementations:
 *
 * `ListContentConfigurationNavigation`
 * `ListContentConfigurationAction`
 */
protocol ListContentConfiguration {

    /// Leading visual element, e.g., an image/icon or badge.
    var leadingElement: ListContentInternal.LeadingElement? { get }

    /// Leading text element, e.g., the name/title.
    var leadingTextElement: ListContentInternal.TextElement { get }

    /// Leading secondary element, e.g., a subtitle or status indication.
    /// Typically presented in a second line.
    var leadingSecondaryElement: ListContentInternal.LeadingSecondaryElement? { get }

    /// Trailing element, e.g., an amount, short text, or badges.
    var trailingElement: ListContentInternal.TrailingElement? { get }

    /// Trailing visual element, e.g., a navigation chevron or "More" button.
    var trailingSecondaryElement: ListContentInternal.TrailingSecondaryElement? { get }

    /// Selection style of the cell.
    var selectionStyle: ListContentInternal.SelectionStyle { get }

}

extension ListContentConfiguration {

    var isMultiLineLayout: Bool {
        leadingSecondaryElement != nil
    }

    var reuseIdentifier: String {
        let components: [String] = [
            String(describing: Self.self),
            leadingElement?.reuseIdentifierComponent ?? "leading-nil",
            leadingTextElement.reuseIdentifierComponent,
            leadingSecondaryElement?.reuseIdentifierComponent ?? "leading-secondary-nil",
            trailingElement?.reuseIdentifierComponent ?? "trailing-nil",
            trailingSecondaryElement?.reuseIdentifierComponent ?? "trailing-secondary-nil"
        ]

        return components.joined(separator: ":")
    }

}

// MARK: - Internal Content Element Types

/**
 *  Within the namespace below, we add internal counterparts to the public
 *  element definitions (see: `ListContent`) where needed. Typically, the
 *  public elements are more constrained, while the internal types allow
 *  for more configuration options.
 */
enum ListContentInternal {

    struct TextElement {
        enum Style {
            case body1(variant: LabelBodyVariant, strikethrough: Bool = false)
            case body2(variant: LabelBodyVariant)
        }

        let text: String
        let style: Style

        init(_ text: String, style: Style) {
            self.text = text
            self.style = style
        }
    }

    enum LeadingElement {
        case image(UIImage, imageOptions: ListContent.ImageOptions)
        case remoteImage(URL?, placeholder: ListContent.ImagePlaceholder?, imageOptions: ListContent.ImageOptions)
        case checkmark(forMultipleSelection: Bool, canvasSize: CGSize, contentMode: UIView.ContentMode)
        case badge(text: String, variant: StatusVariant)
    }

    enum LeadingSecondaryElement {
        case text(TextElement)
        case statusLine(StatusLineModel, trailingText: TextElement?)
    }

    enum AccessoryElement {
        case toggle(ToggleConfiguration)
        case checkmark(forMultipleSelection: Bool, canvasSize: CGSize, contentMode: UIView.ContentMode)
    }

    struct ToggleConfiguration {
        let isOn: Bool
        let isEnabled: Bool
        let changeHandler: ((Bool) -> Void)

        init(isOn: Bool, isEnabled: Bool = true, changeHandler: @escaping ((Bool) -> Void)) {
            self.isOn = isOn
            self.isEnabled = isEnabled
            self.changeHandler = changeHandler
        }
    }

    enum TrailingElement {
        case text(TextElement)
        case badge(text: String, variant: StatusVariant)
        case control(AccessoryElement)
        case image(UIImage, imageOptions: ListContent.ImageOptions)
    }

    enum TrailingSecondaryElement {
        case moreButton
        case navigationChevron
    }

    enum SelectionStyle {
        case none
        case `default`
    }
}

// MARK: - Conversion from public to internal content elements

extension ListContentInternal.LeadingElement {

    init?(element: ListContent.LeadingElement?) {
        switch element {
        case .image(let image, let contentMode):
            let defaultOptions = ListContent.ImageOptions(contentMode: contentMode)
            self = .image(image, imageOptions: defaultOptions)
        case .remoteImage(let url, let placeholder, let imageOptions):
            self = .remoteImage(url, placeholder: placeholder, imageOptions: imageOptions)
        case .badge(let text, let variant):
            self = .badge(text: text, variant: variant)
        case .checkmark(let forMultipleSelection):
            self = .checkmark(forMultipleSelection: forMultipleSelection, canvasSize: ListContent.ImageOptions.Size.regular.pointsSize, contentMode: .scaleAspectFit)
        case nil:
            return nil
        }
    }

    init?(element: ListContentAction.LeadingElement?) {
        switch element {
        case .image(let image, let imageOptions):
            self = .image(image, imageOptions: imageOptions)
        case .remoteImage(let url, let placeholder, let imageOptions):
            self = .remoteImage(url, placeholder: placeholder, imageOptions: imageOptions)
        case .badge(let text, let variant):
            self = .badge(text: text, variant: variant)
        case .checkmark(let forMultipleSelection):
            self = .checkmark(forMultipleSelection: forMultipleSelection, canvasSize: ListContent.ImageOptions.Size.regular.pointsSize, contentMode: .scaleAspectFit)
        case nil:
            return nil
        }
    }

}

extension ListContentInternal.LeadingSecondaryElement {

    init(element: ListContent.LeadingSecondaryElement) {
        switch element {
        case .text(let descriptor):
            self = .text(.init(descriptor.text, style: .body2(variant: descriptor.variant)))
        case .statusLine(let model, let trailingText):
            self = .statusLine(model, trailingText: trailingText.map { .init($0.text, style: .body2(variant: $0.variant)) })
        }
    }

}

extension ListContentInternal.TrailingElement {

    init?(element: ListContentNavigation.TrailingElement?) {
        switch element {
        case .text(let text):
            self = .text(.init(text, style: .body2(variant: .subtle)))
        case .badge(let text, let variant):
            self = .badge(text: text, variant: variant)
        case nil:
            return nil
        }
    }

    init?(element: ListContentAction.TrailingElement?) {
        switch element {
        case .text(let text):
            self = .text(ListContentInternal.TextElement(text.text, style: text.style))
        case .image(let image, let imageOptions):
            self = .image(image, imageOptions: imageOptions)
        case nil:
            return nil
        }
    }

    init?(textWithOptions element: ListContentNavigation.TrailingTextWithOptions?) {
        guard let element = element, !element.text.isEmpty else {
            return nil
        }

        self = .text(
            .init(element.text,
                  style: .body1(variant: element.variant,
                                strikethrough: element.strikethrough)
            )
        )
    }

    init?(text: String?) {
        guard let text = text else {
            return nil
        }

        self.init(textWithOptions: .init(stringLiteral: text))
    }

    init?(control: ListContent.AccessoryElement?) {
        guard let control = control else {
            return nil
        }

        switch control {
        case .toggle(let isOn, let onChange):
            self = .control(.toggle(.init(isOn: isOn, changeHandler: onChange)))
        case .checkmark(let forMultipleSelection):
            self = .control(.checkmark(forMultipleSelection: forMultipleSelection, canvasSize: ListContent.ImageOptions.Size.regular.pointsSize, contentMode: .scaleAspectFit))
        case .toggleControl(let config):
            self = .control(.toggle(.init(isOn: config.isOn, isEnabled: config.isEnabled, changeHandler: config.changeHandler)))
        }
    }
}
