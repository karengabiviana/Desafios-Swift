//
//  SelectorControl.swift
//  CircuitUI
//
//  Created by Jonathan Ting Go  on 20.10.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#if canImport(CircuitUI_Private)

import CircuitUI_Private
import SumUpUtilities
import UIKit

public enum SelectorOption: Equatable {
    case text(title: String, subtitle: String? = nil)
    case custom(view: UIView)

    /// Configures the SelectorOption to have either an image and title, or subtitle and title.
    /// If all three are provided, the component will infer the style.
    case textual(title: String, subtitle: String? = nil, image: UIImage? = nil)
}

/// The Selector Control displays multiple options upfront for users to choose from.
public class SelectorControl: UIControl {

    public enum Size: Equatable {
        case flexible
    }

    // MARK: - Properties
    public let options: [SelectorOption]
    public let numberOfButtonsPerRow: Int

    /// Array of selectors created from the options given by the user
    private var selectableOptions = [UIControl]()

    public var selectedIndex: Int = 0 {
        didSet {
            guard oldValue != selectedIndex else {
                return
            }

            updateButtonStyleForState()
        }
    }

    private let size: Size = .flexible

    /// pinned to the edges. Horizontal stackViews are dynamically created and added. The number of horizontal stackviews is computed by dividing the selection count by the numberOfSelectionPerRow
    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.setSpacing(.kilo)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()

    // MARK: - Initialization
     public init(options: [SelectorOption], numberOfButtonsPerRow: Int = 2) {
        self.numberOfButtonsPerRow = numberOfButtonsPerRow
        self.options = options
        super.init(frame: .zero)

        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SelectorControl does not support initialization using NSCoder. Contributions are welcome, though. :)")
    }

    private func commonInit() {
        self.selectableOptions = makeSelectorButtons(for: options, size: size)

        addSubview(mainStackView,
                   with: mainStackView.constrain(toEdgesOf: self))

        configureSelectorContent()
        updateButtonStyleForState()
    }

    private func makeSelectorButtons(for options: [SelectorOption], size: Size) -> [UIControl] {
        options.map { option -> UIControl in
            switch size {
            case .flexible:
                return createFlexibleSelector(selectorOption: option)
            }
        }
    }

    private func configureSelectorContent() {
        guard !selectableOptions.isEmpty else {
            return
        }

        let buttonsPerRow = selectableOptions.chunked(into: numberOfButtonsPerRow)

        for buttonsForRow in buttonsPerRow {
            let row = makeHorizontalStackView(row: buttonsForRow)
            mainStackView.addArrangedSubview(row)
        }
    }

    private func makeHorizontalStackView(row: [UIControl]) -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.isLayoutMarginsRelativeArrangement = true
        horizontalStackView.layoutMargins = .zero
        horizontalStackView.setSpacing(.kilo)

        row.forEach { button in
            button.addTarget(self, action: #selector(didSelectOption(sender:)), for: .touchUpInside)
            horizontalStackView.addArrangedSubview(button)
        }

        // if the row contains fewer than the defined number of buttons
        // per row, we have to insert placeholders, so there's an even layout.
        let numberOfButtonsInCurrentRow = row.count
        if !numberOfButtonsInCurrentRow.isMultiple(of: numberOfButtonsPerRow) {
            let placeholdersToAdd = numberOfButtonsPerRow - numberOfButtonsInCurrentRow

            for _ in 0..<placeholdersToAdd {
                let emptyView = UIView()
                emptyView.backgroundColor = SemanticColor.background
                horizontalStackView.addArrangedSubview(emptyView)
            }
        }

        return horizontalStackView
    }

    @objc
    private func didSelectOption(sender: UIControl) {
        guard let index = selectableOptions.firstIndex(of: sender) else {
            assertionFailure("selectIndex is does not contain a valid index of available options.")
            return
        }

        selectedIndex = index
        sendActions(for: .valueChanged)
    }
}

private extension SelectorControl {
    func createFlexibleSelector(selectorOption: SelectorOption) -> UIControl {
        switch selectorOption {
        case .textual(let title, _, let image?):
            return createFlexibleSelector(title: title, image: image)
        case .text(let title, let subtitle), .textual(let title, let subtitle, _):
            return createFlexibleSelector(title: title, subtitle: subtitle)
        case .custom(let view):
            return makeOptionControl(with: view)
        }
    }

    func createFlexibleSelector(title: String, subtitle: String?) -> UIControl {
        let hasSubtitle = subtitle != nil

        let titleLabel = hasSubtitle ? LabelHeadline3() : LabelBody1()
        titleLabel.numberOfLines = 2
        titleLabel.text = title
        titleLabel.textAlignment = .center

        lazy var subtitleLabel: CUILabel = {
            let label = LabelBody1()
            label.numberOfLines = 1
            label.text = subtitle
            label.textAlignment = .center
            return label
        }()

        let contentView = UIView()
        contentView.isUserInteractionEnabled = false

        contentView.addSubview(titleLabel, with: [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        if subtitle != nil {
            contentView.addSubview(subtitleLabel, with: [
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
            ])
        } else {
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }

        return makeOptionControl(with: contentView)
    }

    // the use case within mobile payments/installments. going forward, this should
    // likely reside in their domain and make use of the `.custom` option case.
    func createFlexibleSelector(title: String, image: UIImage) -> UIControl {
        let view = UIView()
        view.isUserInteractionEnabled = false

        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        view.addSubview(imageView, with: [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.widthAnchor.constraint(equalToSpacing: .giga),
            imageView.heightAnchor.constraint(equalToSpacing: .giga)
        ])

        let label = LabelBody1()
        label.text = title
        label.textAlignment = .right

        view.addSubview(label, with: [
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: imageView.trailingAnchor, spacing: .mega),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        return makeOptionControl(with: view)
    }

    func makeOptionControl(with content: UIView) -> UIControl {
        let control = UIControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.layoutMargins = .init(vertical: size.verticalSpacing, horizontal: size.horizontalSpacing)
        control.backgroundColor = SemanticColor.background
        control.layer.borderColor = CUIColorFromHex(ColorReference.CUIColorRefN40.rawValue)?.cgColor
        control.layer.setCornerRadius(.byte)
        control.accessibilityIdentifier = "selector-control-option"
        control.layer.borderWidth = 1
        control.layer.masksToBounds = true
        control.addSubview(content,
                           with: content.constrain(toEdgesOf: control.layoutMarginsGuide))
        return control
    }

    func updateButtonStyleForState() {
        for (index, option) in selectableOptions.enumerated() {
            option.backgroundColor = SemanticColor.background
            option.layer.borderColor = CUIColorFromHex(ColorReference.CUIColorRefN40.rawValue)?.cgColor
            option.layer.borderWidth = 1

            guard index == selectedIndex else {
                continue
            }

            option.backgroundColor = CUIColorFromHex(ColorReference.CUIColorRefB10.rawValue)
            option.layer.borderColor = CUIColorFromHex(ColorReference.CUIColorRefB70.rawValue)?.cgColor
            option.layer.borderWidth = 2
        }
    }
}

extension SelectorControl.Size {
    var verticalSpacing: Spacing {
        switch self {
        case .flexible:
            return .kilo
        }
    }

    var horizontalSpacing: Spacing {
        switch self {
        case .flexible:
            return .mega
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0  else {
            return [self]
        }

        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#endif
