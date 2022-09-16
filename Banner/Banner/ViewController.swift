//
//  ViewController.swift
//  Banner
//
//  Created by Karen Oliveira on 19/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    let banner = modBanner()
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
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    func addChildVC() {
        addChild(childView)
        view.addSubview(childView.view)
        setChildVCConstrainsts()
    }
    
    func setChildVCConstrainsts() {
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        childView.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        childView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        childView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        childView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        
    }
    
    //Banner
//    func configBanner() {
//        view.addSubview(banner)
//        banner.axis = .vertical
//        banner.distribution = .fillProportionally
//        banner.spacing = 8
////        banner.backgroundColor = .lightGray
//        banner.layer.cornerRadius = 16
//
////        banner.addArrangedSubview(banner)
//
//        setBannerConstraints()
//    }
//
//    func setBannerConstraints() {
//        banner.translatesAutoresizingMaskIntoConstraints = false
//        banner.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 120).isActive = true
//        banner.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//        banner.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        banner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -360).isActive = true
//    }
}
