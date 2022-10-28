//
//  AvatarLoadingOverlayView.swift
//  CircuitUI
//
//  Created by Marcel Voß on 16.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

final class AvatarLoadingOverlayView: UIView {

    // MARK: - Properties
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    var isLoading = false {
        didSet {
            guard isLoading else {
                loadingIndicator.stopAnimating()
                return
            }

            loadingIndicator.startAnimating()
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureSubviews()
    }

    // MARK: - Configuration
    private func configureSubviews() {
        backgroundColor = SemanticColor.overlay

        addSubview(loadingIndicator, with: [
            topAnchor.constraint(equalTo: loadingIndicator.topAnchor),
            bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor)

        ])
    }

}
