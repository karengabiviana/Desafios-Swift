//
//  ListContentInternal+Accessibility.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 27/01/2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

extension ListContentInternal.LeadingElement {

    var accessibilityIdentifier: String {
        switch self {
        case .image, .remoteImage:
            return "cui-leading-image"
        case .badge:
            return "cui-leading-badge"
        case .checkmark:
            return "cui-leading-checkmark"
        }
    }
}

extension ListContentInternal.LeadingSecondaryElement {

    var accessibilityIdentifier: String {
        switch self {
        case .text:
            return "cui-leading-secondary-text"
        case .statusLine:
            return "cui-leading-secondary-status-line"
        }
    }
}

extension ListContentInternal.TrailingElement {

    var accessibilityIdentifier: String {
        switch self {
        case .text:
            return "cui-trailing-text"
        case .badge:
            return "cui-trailing-badge"
        case .control(let type):
            switch type {
            case .toggle:
                return "cui-trailing-switch"
            case .checkmark:
                return "cui-trailing-checkmark"
            }
        case .image:
            return "cui-trailing-image"
        }
    }
}

extension ListContentInternal.TrailingSecondaryElement {

    var accessibilityIdentifier: String {
        switch self {
        case .moreButton:
            return "cui-trailing-secondary-more"
        case .navigationChevron:
            return "cui-trailing-secondary-navigation-chevron"
        }
    }
}

extension ListContentInternal.TextElement {

    var accessibilityIdentifier: String {
        "cui-text-element"
    }
}

extension StatusLineModel {

    var accessibilityIdentifier: String {
        "cui-status-line"
    }
}

extension StatusIndeterminateModel {

    var accessibilityIdentifier: String {
        "cui-status-indeterminate"
    }
}
