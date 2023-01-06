//
//  Banner.swift
//  Banner
//
//  Created by Karen Oliveira on 19/08/22.
//

import Foundation
import UIKit

struct BannerModel {
    let title: String
    let subtitle: String
    let textButton: String
    let targetButton = "" // What I put here?
    let image: UIImage
}

class Banner: UIStackView {
    //space sizes
    let spaceSizeTiny = 4
    let spaceSizeSmall = 8
    let spaceSizeMedium = 12
    let spaceSizeLarge = 24
    //font size
    let fontSizeTitle = 18
    //color font
    let colorFont = UIColor.black
    
    //Banner elements
    let bannerImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        return image
    }()
    
    let leadingView = UIStackView()
    
    // inside leadingView
    let labelsView = UIStackView()
    
    let textButton: UIButton = {
        let button = UIButton()
        button.addTarget(Banner.self, action: #selector(clicked), for: .touchUpInside)
        return button
    }()
    
    //inside labelsView
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fillProportionally
        alignment = .center
        addArrangedSubview(leadingView)
        addArrangedSubview(bannerImage)
        configViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews() {
        leadingView.axis = .vertical
        leadingView.distribution = .equalSpacing
        leadingView.alignment = .center
        leadingView.spacing = CGFloat(spaceSizeMedium)
        leadingView.addArrangedSubview(labelsView)
        leadingView.addArrangedSubview(textButton)
        
        labelsView.axis = .vertical
        labelsView.distribution = .equalSpacing
        labelsView.alignment = .center
        labelsView.spacing = CGFloat(spaceSizeTiny)
        leadingView.addArrangedSubview(titleLabel)
        leadingView.addArrangedSubview(subtitleLabel)
        
    }
    
    func configure(with viewModel: BannerModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        textButton.setTitle(viewModel.textButton, for: .normal)
        bannerImage.image = viewModel.image
    }
    
    @objc func clicked() {
        print("Clicked")
    }
    
}
