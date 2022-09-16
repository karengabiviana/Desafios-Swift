//
//  Banner.swift
//  Banner
//
//  Created by Karen Oliveira on 19/08/22.
//

import Foundation
import UIKit

class modBanner: UIView {
    
    var view = UIStackView()
    var columnLeftStackView = UIStackView()
    var columnRightStackView = UIStackView()
    var title = UILabel()
    var body = UILabel()
    var button = UIButton()
    var illustration = UIImageView()
    
    
    func configStackView() {
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 16
        view.backgroundColor = .green
        
        columnLeftStackView.axis = .vertical
        columnLeftStackView.distribution = .fillProportionally
        columnLeftStackView.spacing = 8
        columnLeftStackView.backgroundColor = .red
        
        columnRightStackView.axis = .vertical
        columnRightStackView.distribution = .fillProportionally
        columnRightStackView.spacing = 8
        columnRightStackView.backgroundColor = .blue
        
    }
    
    func addElementsStackView() {
        view.addArrangedSubview(columnLeftStackView)
        view.addArrangedSubview(columnRightStackView)
        
        columnLeftStackView.addArrangedSubview(title)
        columnLeftStackView.addArrangedSubview(body)
        columnLeftStackView.addArrangedSubview(button)
        
        columnRightStackView.addArrangedSubview(illustration)
    }
    
    
}
