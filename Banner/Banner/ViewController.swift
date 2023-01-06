//
//  ViewController.swift
//  Banner
//
//  Created by Karen Oliveira on 19/08/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    let bannerView = Banner()
    
    let titleString = "Pix"
    let subtitleString = "Cadastre sua chave"
    let textButtonString = "Cadastre aqui"
    let bannerImage = UIImage(named: "PixKeyBannerIllustration")
    let errorImage = UIImage(systemName: "photo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitle()
        addBannerView()
        
        bannerView.configure(with: BannerModel(
            title: titleString,
            subtitle: subtitleString,
            textButton: textButtonString,
            image: bannerImage))
        
    }
    
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
    @objc func clicked() {
        print("Clicked")
    }
    
    func addBannerView() {
        view.addSubview(bannerView)
        setBannerViewConstrainsts()
    }
    
    func setBannerViewConstrainsts() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bannerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
