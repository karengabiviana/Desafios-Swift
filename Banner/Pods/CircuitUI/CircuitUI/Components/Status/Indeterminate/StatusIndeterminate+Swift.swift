//
//  StatusIndeterminate+Swift.swift
//  CircuitUI
//
//  Created by Victor Kachalov on 17.06.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

/**
 *  Descriptor to fully configure the `StatusIndeterminate` component.
 *
 *  For full per-property documentation, please see the
 *  component's documentation.
 */
public struct StatusIndeterminateModel {

    let variant: StatusVariant

    public init(variant: StatusVariant) {
        self.variant = variant
    }

}

public extension StatusIndeterminate {

    convenience init(model: StatusIndeterminateModel) {
        self.init(__variant: model.variant)
        accessibilityIdentifier = model.accessibilityIdentifier
    }

    func apply(model: StatusIndeterminateModel) {
        variant = model.variant
        accessibilityIdentifier = model.accessibilityIdentifier
    }

}
