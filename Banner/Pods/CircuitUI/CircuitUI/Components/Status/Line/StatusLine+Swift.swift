//
//  StatusLine+Swift.swift
//  CircuitUI
//
//  Created by Hagi on 12.10.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

/**
 *  Descriptor to fully configure the `StatusLine` component.
 *
 *  For full per-property documentation, please see the
 *  component's documentation.
 */
public struct StatusLineModel {

    let icon: StatusLineIcon
    let text: String
    let variant: StatusVariant

    public init(icon: StatusLineIcon, text: String, variant: StatusVariant) {
        self.icon = icon
        self.variant = variant
        self.text = text
    }

}

public extension StatusLine {

    convenience init(model: StatusLineModel) {
        self.init(__icon: model.icon, text: model.text, variant: model.variant)
        accessibilityIdentifier = model.accessibilityIdentifier
    }

    func apply(model: StatusLineModel) {
        icon = model.icon
        variant = model.variant
        text = model.text
        accessibilityIdentifier = model.accessibilityIdentifier
    }

}
