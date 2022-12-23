//
//  Banner.swift
//  Banner
//
//  Created by Karen Oliveira on 19/08/22.
//

import Foundation
import UIKit

class Banner: UIView {
    
    var mainView = UIStackView()
    var columnLeftStackView = UIStackView()
    var columnRightStackView = UIStackView()
    
    var titleLabel = UILabel()
    var bodyLabel = UILabel()
    
    var titleString = "Testing"
    var bodyString = "This is a test"
    var buttonString = "Button"
    
    var button = UIButton()
    
    var illustration = UIImageView()
    
    
    func configStacksView() {
        
        columnLeftStackView.axis = .vertical
        columnLeftStackView.distribution = .fillProportionally
        columnLeftStackView.spacing = 8
        columnLeftStackView.backgroundColor = .red
        columnLeftStackView.addArrangedSubview(titleLabel)
        columnLeftStackView.addArrangedSubview(bodyLabel)
        columnLeftStackView.addArrangedSubview(button)
        
        columnRightStackView.axis = .vertical
        columnRightStackView.distribution = .fillProportionally
        columnRightStackView.spacing = 8
        columnRightStackView.backgroundColor = .blue
        columnRightStackView.addArrangedSubview(illustration)
        
        mainView.axis = .horizontal
        mainView.distribution = .fillProportionally
        mainView.spacing = 16
        mainView.backgroundColor = .green
        mainView.addArrangedSubview(columnLeftStackView)
        mainView.addArrangedSubview(columnRightStackView)
        
    }
    
    func configLabels() {
        titleLabel.text = titleString
        
        bodyLabel.text = bodyString
        
    }
    
    func configButton() {
        button.setTitle(buttonString, for: .normal)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leftAnchor.constraint(equalTo: leftAnchor),
            mainView.rightAnchor.constraint(equalTo: rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }
    
}
