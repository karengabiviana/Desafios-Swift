//
//  OnboardingCell.swift
//  CircuitUI
//
//  Created by Andrii Kravchenko on 09.07.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import UIKit

struct OnboardingSlideModel {
    let image: UIImage?
    let title: String
    let subtitle: String
}

final class TaxSettingsOnboardingCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: CUILabel = {
        let label = LabelHeadline2()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: CUILabel = {
        let label = LabelBody1()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel,
            subtitleLabel,
            UIView()
        ])
        imageView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.33, constant: 1).isActive = true
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.setSpacing(.giga)
        stack.setCustomSpacing(.byte, after: titleLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: OnboardingSlideModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        imageView.isHidden = model.image == nil
    }
}

private extension TaxSettingsOnboardingCell {

    func configure() {
        contentView.backgroundColor = SemanticColor.background

        contentView.addSubview(contentStack, with: [
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, spacing: .mega),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, spacing: .giga),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, spacing: -.giga),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, spacing: .mega)
        ])
    }
}
