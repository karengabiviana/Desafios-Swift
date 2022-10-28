//
//  Card.swift
//  CircuitUI
//
//  Created by Marcel Voß on 16.11.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation

#if canImport(CircuitUI_Private)

import CircuitUI_Private

/// The card component is a flexible container that groups related content.
/// It can be interactive. It is non-interactive by default.
///
/// For changing whether instances of this type are interactive, simply set
/// `isUserInteractionEnabled` to the appropriate value.
@objc(CUICard)
public class Card: UIControl {
    // MARK: - Properties
    /// The content view of the card object.
    ///
    /// If you want to customize `Card` instances by adding additional views, you should
    /// always add them to the content view so they position appropriately within its bounds.
    @objc
    public let contentView = UIView()

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

        layer.borderWidth = 2
        clipsToBounds = true
        layer.cornerRadius = Spacing.mega.rawValue
        layoutMargins = UIEdgeInsets(vertical: .giga, horizontal: .giga)

        backgroundColor = SemanticColor.background
        contentView.backgroundColor = SemanticColor.background

        let minimalCardSize = CGSize(width: 72, height: 72)
        let widthConstant = minimalCardSize.width - layoutMargins.left - layoutMargins.right
        let heightConstant = minimalCardSize.height - layoutMargins.top - layoutMargins.bottom
        addSubview(contentView, with: contentView.constrain(toEdgesOf: layoutMarginsGuide) + [
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: widthConstant),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: heightConstant)
        ])

        updateBorderColorForCurrentState()
    }

    private func updateBorderColorForCurrentState() {
        let borderColor: UIColor?

        switch (isSelected, isHighlighted) {
        case (true, false), (true, true):
            borderColor = CUIColorFromHex(ColorReference.CUIColorRefN50.rawValue)
        case (false, true):
            borderColor = CUIColorFromHex(ColorReference.CUIColorRefN40.rawValue)
        case (false, false):
            borderColor = CUIColorFromHex(ColorReference.CUIColorRefN30.rawValue)
        }

        assert(borderColor != nil, "Couldn't load color from hex.")
        layer.borderColor = borderColor?.cgColor
    }

    // MARK: - UIControl Overrides
    override public var isSelected: Bool {
        didSet {
            updateBorderColorForCurrentState()
        }
    }

    override public var isHighlighted: Bool {
        didSet {
            updateBorderColorForCurrentState()
        }
    }
}

#endif
