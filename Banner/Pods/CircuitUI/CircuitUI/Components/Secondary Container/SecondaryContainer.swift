//
//  SecondaryContainer.swift
//  CircuitUI
//
//  Created by Marcel Voß on 16.03.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

import CircuitUI_Private
import Foundation

/// The secondary container component is a flexible container that groups related content.
/// It can be interactive. It is non-interactive by default.
///
/// For changing whether instances of this type are interactive, simply set
/// `isUserInteractionEnabled` to the appropriate value.
@objc(CUISecondaryContainer)
open class SecondaryContainer: UIControl {

    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialization()
    }

    // MARK: - Customization
    private func commonInitialization() {
        isUserInteractionEnabled = false

        clipsToBounds = true
        layer.cornerRadius = Spacing.mega.rawValue
        layoutMargins = UIEdgeInsets(vertical: .byte, horizontal: .byte)

        updateColorForCurrentState()
    }

    private func updateColorForCurrentState() {
        let color: UIColor?

        switch (isSelected, isHighlighted) {
        case (true, false), (true, true), (false, true):
            color = CUIColorFromHex(ColorReference.CUIColorRefN30.rawValue)
        case (false, false):
            color = CUIColorFromHex(ColorReference.CUIColorRefN20.rawValue)
        }

        assert(color != nil, "Couldn't load color from hex.")
        backgroundColor = color
    }

    // MARK: - UIControl Overrides
    override public var isSelected: Bool {
        didSet {
            updateColorForCurrentState()
        }
    }

    override public var isHighlighted: Bool {
        didSet {
            updateColorForCurrentState()
        }
    }
}

#endif
