//
//  ListContentElements.swift
//  CircuitUI
//
//  Created by Andras Kadar on 18.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

/// This enum contains descriptors for list item elements. Each element,
/// depending on its position/function, has a set of allowed element types,
/// as defined by CircuitUI.
public enum ListContent {

    @available(*, deprecated, message: "Please use TextWithVariant instead.", renamed: "TextWithVariant")
    public typealias LeadingTextWithVariant = TextWithVariant

    /// Leading visual element, e.g., an image/icon or badge.
    public enum LeadingElement {
        case image(UIImage, contentMode: UIView.ContentMode)
        case remoteImage(URL?, placeholder: ImagePlaceholder?, imageOptions: ImageOptions = .init())
        case badge(text: String, variant: StatusVariant)

        /// Before using .checkmark configure UITableView to allow single or multiple selection accordingly
        case checkmark(forMultipleSelection: Bool)
    }

    /// Placeholder element for a remote image.
    /// Displayed in place of the remote image while it is being downloaded.
    public enum ImagePlaceholder {
        case image(UIImage)
    }

    public enum AccessoryElement {
        case toggleControl(ToggleConfiguration)
        case checkmark(forMultipleSelection: Bool)
        @available(*, deprecated, message: "Use toggleControl instead")
        case toggle(isOn: Bool, onChange: ((Bool) -> Void))
    }

    public struct ToggleConfiguration {
        let isOn: Bool
        let isEnabled: Bool
        let changeHandler: ((Bool) -> Void)

        public init(isOn: Bool, isEnabled: Bool = true, changeHandler: @escaping ((Bool) -> Void)) {
            self.isOn = isOn
            self.isEnabled = isEnabled
            self.changeHandler = changeHandler
        }
    }

    /// Leading text element, with optional styling variations.
    /// Using literal string syntax will apply the regular style.
    public struct TextWithVariant: ExpressibleByStringLiteral {

        let text: String
        let variant: LabelBodyVariant
        let textSize: TextSize
        let strikethrough: Bool

        var style: ListContentInternal.TextElement.Style {
            switch textSize {
            case .body1:
                return .body1(variant: variant, strikethrough: strikethrough)
            case .body2:
                return .body2(variant: variant)
            }
        }

        public init(stringLiteral value: StringLiteralType) {
            self.init(text: value)
        }

        public init(text: String,
                    variant: LabelBodyVariant = .default,
                    textSize: TextSize = .body1,
                    strikethrough: Bool = false) {
            self.text = text
            self.variant = variant
            self.textSize = textSize
            self.strikethrough = strikethrough
        }
    }

    /// Leading secondary element, like a subtitle or status indication.
    public enum LeadingSecondaryElement {
        case text(TextWithVariant)
        case statusLine(StatusLineModel, trailingText: TextWithVariant?)
    }

    /// Options for rendering images into an image view.
    public struct ImageOptions {

        public enum Size {
            case regular
            case large

            var pointsSize: CGSize {
                switch self {
                case .regular:
                    return CGSize(width: 24, height: 24)
                case .large:
                    return CGSize(width: 50, height: 50)
                }
            }
        }

        let contentMode: UIView.ContentMode
        let canvasSize: Size
        let cornerRadius: CGFloat

        public init(contentMode: UIView.ContentMode = .scaleAspectFit,
                    canvasSize: Size = .regular,
                    cornerRadius: CGFloat = 0) {
            self.contentMode = contentMode
            self.canvasSize = canvasSize
            self.cornerRadius = cornerRadius
        }
    }

    public enum TextSize {
        case body1
        case body2
    }
}

/// These elements are specific to the navigation variants of the list item.
public enum ListContentNavigation {

    /// Trailing element, like a text that gives context for the
    /// navigation target, or a badge.
    public enum TrailingElement {
        case text(String)
        case badge(text: String, variant: StatusVariant)
    }

    /// Trailing text element, with optional styling attributes.
    /// Using literal string syntax will apply a default style.
    public struct TrailingTextWithOptions: ExpressibleByStringLiteral {

        let text: String
        let variant: LabelBodyVariant
        let strikethrough: Bool

        public init(stringLiteral value: StringLiteralType) {
            self.init(text: value)
        }

        public init(text: String) {
            self.init(text: text, variant: .highlight, strikethrough: false)
        }

        public static func strikethrough(text: String) -> Self {
            self.init(text: text, variant: .default, strikethrough: true)
        }

        public static func subtle(text: String) -> Self {
            self.init(text: text, variant: .subtle, strikethrough: false)
        }

        private init(text: String, variant: LabelBodyVariant, strikethrough: Bool) {
            self.text = text
            self.variant = variant
            self.strikethrough = strikethrough
        }
    }

}

/// These elements are specific to the action variants of the list item.
public enum ListContentAction {

    /// Leading visual element, e.g., an image/icon or badge.
    public enum LeadingElement {
        case image(UIImage, imageOptions: ListContent.ImageOptions = .init())
        case remoteImage(URL?, placeholder: ListContent.ImagePlaceholder?, imageOptions: ListContent.ImageOptions = .init())
        case badge(text: String, variant: StatusVariant)

        /// Before using .checkmark configure UITableView to allow single or multiple selection accordingly
        case checkmark(forMultipleSelection: Bool)
    }

    /// Trailing element, like a text that gives context for the
    /// navigation target, or an image to communicate an action.
    public enum TrailingElement {
        case text(ListContent.TextWithVariant)
        case image(UIImage, imageOptions: ListContent.ImageOptions = .init())
    }

}
