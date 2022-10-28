//
//  ListContentConfigurationAction.swift
//  CircuitUI
//
//  Created by Andras Kadar on 16.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

// swiftlint:disable function_default_parameter_at_end

/// Use this configuration to create single- or multiline action list items.
/// You cannot instantiate this struct directly. Instead, use the provided
/// factory methods.
public struct ListContentConfigurationAction: ListContentConfiguration {

    // MARK: - Public Factory Methods

    /// Creates a configuration for a single-line action item, typically used
    /// for modal actions triggered from a list item, or items that aren't
    /// meant for user-interaction at all.
    public static func singleLine(leadingElement: ListContent.LeadingElement? = nil,
                                  leadingText: String,
                                  trailingText: String? = nil) -> Self {
        .init(leadingElement: ListContentInternal.LeadingElement(element: leadingElement),
              leadingTextElement: .init(leadingText, style: .body1(variant: .default)),
              leadingSecondaryElement: nil,
              trailingElement: ListContentInternal.TrailingElement(text: trailingText),
              trailingSecondaryElement: nil,
              selectionStyle: .default)
    }

    /// Creates a configuration for a single-line action item with a control element
    public static func singleLine(leadingElement: ListContent.LeadingElement? = nil,
                                  leadingText: String,
                                  trailingControl: ListContent.AccessoryElement) -> Self {
        .init(leadingElement: ListContentInternal.LeadingElement(element: leadingElement),
              leadingTextElement: .init(leadingText, style: .body1(variant: .default)),
              leadingSecondaryElement: nil,
              trailingElement: ListContentInternal.TrailingElement(control: trailingControl),
              trailingSecondaryElement: nil,
              selectionStyle: .none)
    }

    /// Creates a configuration for a single-line action item with configurable leading and trailing texts
    public static func singleLine(leadingText: ListContent.TextWithVariant,
                                  trailingText: ListContent.TextWithVariant? = nil) -> Self {
        .init(leadingElement: nil,
              leadingTextElement: .init(leadingText.text, style: leadingText.style),
              leadingSecondaryElement: nil,
              trailingElement: trailingText.map { ListContentInternal.TrailingElement.text(.init($0.text, style: $0.style)) },
              trailingSecondaryElement: nil,
              selectionStyle: .none)
    }

    /// Creates a configuration for a multiline action item, typically used
    /// in lists of data where modal actions are available.
    @available(*, deprecated, message: "Please use multiline() with `trailingElement` parameter instead of `trailingText`. Important: to match previous behavior of `trailingText` use `.highlight` variant e.g. `.text(.init(text: \"\", variant: .highlight)`")
    public static func multiline(leadingElement: ListContentAction.LeadingElement? = nil,
                                 leadingText: ListContent.TextWithVariant,
                                 leadingSecondaryElement: ListContent.LeadingSecondaryElement,
                                 trailingText: String? = nil,
                                 displayMoreButton: Bool = false) -> Self {
        multiline(leadingElement: leadingElement,
                  leadingText: leadingText,
                  leadingSecondaryElement: leadingSecondaryElement,
                  trailingElement: trailingText.map { .text(.init(text: $0, variant: .highlight)) },
                  displayMoreButton: displayMoreButton)
    }

    /// Creates a configuration for a multiline action item, typically used
    /// in lists of data where modal actions are available.
    public static func multiline(leadingElement: ListContentAction.LeadingElement? = nil,
                                 leadingText: ListContent.TextWithVariant,
                                 leadingSecondaryElement: ListContent.LeadingSecondaryElement,
                                 trailingElement: ListContentAction.TrailingElement?,
                                 displayMoreButton: Bool = false) -> Self {
        .init(leadingElement: ListContentInternal.LeadingElement(element: leadingElement),
              leadingTextElement: .init(leadingText.text, style: .body1(variant: leadingText.variant)),
              leadingSecondaryElement: .init(element: leadingSecondaryElement),
              trailingElement: trailingElement.flatMap { ListContentInternal.TrailingElement(element: $0) },
              trailingSecondaryElement: displayMoreButton ? .moreButton : nil,
              selectionStyle: .default)
    }

    // MARK: - ListContentConfiguration Protocol Requirements

    let leadingElement: ListContentInternal.LeadingElement?
    let leadingTextElement: ListContentInternal.TextElement
    let leadingSecondaryElement: ListContentInternal.LeadingSecondaryElement?
    let trailingElement: ListContentInternal.TrailingElement?
    let trailingSecondaryElement: ListContentInternal.TrailingSecondaryElement?
    let selectionStyle: ListContentInternal.SelectionStyle

}
