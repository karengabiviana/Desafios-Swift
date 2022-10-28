//
//  ListContentConfigurationNavigation.swift
//  CircuitUI
//
//  Created by Andras Kadar on 16.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

// swiftlint:disable function_default_parameter_at_end

import Foundation

/// Use this configuration to create single- or multiline navigation list items.
/// You cannot instantiate this struct directly. Instead, use the provided
/// factory methods.
public struct ListContentConfigurationNavigation: ListContentConfiguration {

    // MARK: - Public Factory Methods

    /// Creates a configuration for a single-line navigation item, typically used
    /// in settings or other places where only a minimal amount of information
    /// needs to be displayed per row.
    public static func singleLine(leadingElement: ListContent.LeadingElement? = nil,
                                  leadingText: String,
                                  trailingElement: ListContentNavigation.TrailingElement? = nil) -> Self {
        .init(leadingElement: ListContentInternal.LeadingElement(element: leadingElement),
              leadingTextElement: .init(leadingText, style: .body1(variant: .default)),
              leadingSecondaryElement: nil,
              trailingElement: ListContentInternal.TrailingElement(element: trailingElement),
              trailingSecondaryElement: .navigationChevron)
    }

    /// Creates a configuration for a multiline navigation item, typically used
    /// in lists of data where navigation to a detail view is supported.
    public static func multiline(leadingElement: ListContent.LeadingElement? = nil,
                                 leadingText: ListContent.TextWithVariant,
                                 leadingSecondaryElement: ListContent.LeadingSecondaryElement,
                                 trailingText: ListContentNavigation.TrailingTextWithOptions? = nil) -> Self {
        .init(leadingElement: ListContentInternal.LeadingElement(element: leadingElement),
              leadingTextElement: .init(leadingText.text, style: .body1(variant: leadingText.variant)),
              leadingSecondaryElement: .init(element: leadingSecondaryElement),
              trailingElement: ListContentInternal.TrailingElement(textWithOptions: trailingText),
              trailingSecondaryElement: .navigationChevron)
    }

    // MARK: - ListContentConfiguration Protocol Requirements

    let leadingElement: ListContentInternal.LeadingElement?
    let leadingTextElement: ListContentInternal.TextElement
    let leadingSecondaryElement: ListContentInternal.LeadingSecondaryElement?
    let trailingElement: ListContentInternal.TrailingElement?
    let trailingSecondaryElement: ListContentInternal.TrailingSecondaryElement?
    let selectionStyle: ListContentInternal.SelectionStyle = .default

}
