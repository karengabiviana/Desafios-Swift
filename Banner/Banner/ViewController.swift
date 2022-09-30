//
//  ViewController.swift
//  Banner
//
//  Created by Karen Oliveira on 19/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    let childView = childViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitle()
//        configBanner()
        addChildVC()
    }
    
    //Title
    func configTitle() {
        view.addSubview(titleLabel)
        titleLabel.text = "Banner"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        
        setTitleConstraints()
        
    }
    func setTitleConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addChildVC() {
        view.addSubview(childView)
        setChildVCConstrainsts()
    }
    
    func setChildVCConstrainsts() {
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            childView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            childView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            childView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
